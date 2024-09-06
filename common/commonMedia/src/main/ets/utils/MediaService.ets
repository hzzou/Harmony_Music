import { common, wantAgent } from '@kit.AbilityKit';
import { media } from '@kit.MediaKit';
import { avSession } from '@kit.AVSessionKit';
import SongItemBuilder from './SongItemBuilder';
import { SongItem } from '../viewmodel/SongData';
import { AudioPlayerState, MusicPlayMode } from '../viewmodel/MusicData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Logger';
import { MediaTool } from './MediaTool';
import { BackgroundUtil } from './BackgroundUtil';
import { PreferenceUtil } from './PreferenceUtil';
import { SongConstant } from '@ohos/commonConstant';
import { CardData } from '../viewmodel/CardData';
import { formBindingData, formProvider } from '@kit.FormKit';
import { JSON } from '@kit.ArkTS';

const TAG = 'MediaService';

export class MediaService{
  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  public avPlayer?: media.AVPlayer; // 媒体播放
  private session?: avSession.AVSession; // 媒体会话管理
  private songItemBuilder: SongItemBuilder = new SongItemBuilder();
  private songItem: SongItem = new SongItem();
  private playMode: MusicPlayMode = MusicPlayMode.ORDER;
  private state: AudioPlayerState = AudioPlayerState.IDLE; //音乐播放状态
  private isFirst: boolean = true;
  private isPrepared: boolean = false;
  private musicIndex: number = 0;
  private songList: SongItem[] = []
  private formIds: string[] = [];
  private isCurrent: boolean = true;

  constructor() {
    let list: SongItem[] | undefined = AppStorage.get('songList');
    if(list){
      this.songList = list;
    }
    this.initAudioPlayer();
  }
  // 单例模式
  public static getInstance(): MediaService {
    let mediaService: MediaService | undefined = AppStorage.get('mediaService');
    if (!mediaService) {
      mediaService = new MediaService();
      AppStorage.setOrCreate('mediaService', mediaService);
    }
    return mediaService;
  }

  // player初始化
  private initAudioPlayer(){
    media.createAVPlayer()
      .then(async avPlayer=>{
        if(avPlayer !== null){
          this.avPlayer = avPlayer;
          this.setAVPlayerCallback();
          this.createSession();
        }
      })
      .catch((error: BusinessError)=>{
        Logger.error(TAG, 'this avPlayer: ', `catch error happened,error code is ${error.code}`);
      })
  }

  // 设置avPlayer上的事件监听
  private setAVPlayerCallback(){
    if(!this.avPlayer) return;

    // 点击播放条到指定的播放位置的监听
    this.avPlayer.on("seekDone", this.seekCall);

    // 监听播放器的state属性变化
    this.avPlayer.on("stateChange", this.stateCall);

    // 监听进度条刷新时间
    this.avPlayer.on("timeUpdate", this.updateTimeCall);

    // 监听错误
    this.avPlayer.on("error", this.errCall);
  }

  // 创建媒体会话管理
  async createSession(){
    if(!this.context) return;

    this.session = await avSession.createAVSession(this.context, 'SESSION_NAME', 'audio');
    this.session.activate(); //激活会话
    Logger.info(TAG, `session create done : sessionId : ${this.session.sessionId}`);
    this.setAVMetadata();

    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: this.context.abilityInfo.bundleName,
          abilityName: this.context.abilityInfo.name
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITIES,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    wantAgent.getWantAgent(wantAgentInfo)
      .then((agent)=>{
        if(this.session){
          this.session.setLaunchAbility(agent);
        }
      })

  }

  // 添加播放会话控制监听, 与系统的多媒体控制中心进行交互，允许用户在设备的全局多媒体控制界面上控制音视频
  async addSessionListener(){
    if(!this.session) return;

    this.session.on("play", this.playCall);
    this.session.on("pause", this.pauseCall);
    this.session.on("playPrevious", this.playPrevCall);
    this.session.on("playNext", this.playNextCall);
  }

  // 移除监听
  async unregisterSessionListener() {
    if (!this.session) return;
    this.session.off('play');
    this.session.off('pause');
    this.session.off('playNext');
    this.session.off('playPrevious');
  }

  // 设置session.setAVMetadata 会话元数据
  async setAVMetadata(){
    let id = this.musicIndex;
    try{
      if(this.context){
        let mediaImage = await MediaTool.getPixelMapFromResource(this.context,
        this.songList[this.musicIndex].label);
        Logger.info(TAG, 'getPixelMapFromResource success' + JSON.stringify(mediaImage));

        let metadata: avSession.AVMetadata = {
          assetId: `${id}`,
          title: this.songList[this.musicIndex].title,
          artist: this.songList[this.musicIndex].singer,
          mediaImage: mediaImage,
          duration: this.getDuration()
        };

        if (this.session) {
          this.session.setAVMetadata(metadata).then(() => {
            Logger.info(TAG, 'SetAVMetadata successfully');
          }).catch((err: BusinessError) => {
            Logger.error(TAG, `SetAVMetadata BusinessError: code: ${err.code}, message: ${err.message}`);
          });
        }
      }
    } catch (error) {
      Logger.error(TAG, `SetAVMetadata try: code: ${(error as BusinessError).code},
       message: ${(error as BusinessError).message}`);
    }
  }

  // 事件监听这种函数单独列出来是const fn = ()=>{}模式
  // 播放音乐
  private playCall: ()=>void = ()=>{
    Logger.info(TAG, `on play , do play task`);
    if (this.isFirst) {
      this.loadAssent(0);
    } else {
      this.play();
    }
  }

  // 暂停音乐播放监听
  private pauseCall: ()=>void = ()=>{
    Logger.info(TAG, `on pause , do pause task`);
    this.pause();
  }

  // 播放前一首监听
  private playPrevCall: ()=>void = ()=>{
    Logger.info(TAG, `on playPrevious , do playPrevious task`);
    this.playPrevious();
  }

  //播放下一首监听
  private playNextCall: ()=>void = ()=>{
    Logger.info(TAG, `on playNext , do playNext task`);
    this.playNextAuto(true);
  }

  // 跳到指定位置监听
  private seekCall: (seekDoneTime: number)=>void = (seekDoneTime: number)=>{
    this.isCurrent = true;
    Logger.info(TAG, `AVPlayer seek succeeded, seek time is ${seekDoneTime}`);

    this.setPlayState({
      // lapsedTime: 已用时间, updateTime: 更新时间
      position: { elapsedTime: this.getCurrentTime(), updateTime: new Date().getTime()}
    })
  }

  // state状态监听
  private stateCall: (state: string)=> Promise<void> = async (state: string)=>{
    switch (state){
      case 'idle':
        Logger.info(TAG, 'AVPlayer state idle called.');
        this.state = AudioPlayerState.IDLE;
        this.songItem = await this.songItemBuilder.build(this.songList[this.musicIndex]);
        let url = this.songItemBuilder.getRealUrl();

        if(this.avPlayer && url){
          let avFileDescriptor: media.AVFileDescriptor = {fd: url.fd, offset: url.offset, length: url.length};
          this.avPlayer.fdSrc = avFileDescriptor;
          Logger.info(TAG, 'loadAsset avPlayer.url:' + this.avPlayer.fdSrc);
        }
        break;
      case 'initialized':
        Logger.info(TAG, 'AVPlayer state initialized called.');
        this.state = AudioPlayerState.INITIALIZED;
        if(this.avPlayer){
          this.avPlayer
            .prepare()
            .then(()=>{
              Logger.info(TAG, 'AVPlayer prepare succeeded.');
            })
            .catch((err: BusinessError)=>{
              Logger.error(TAG, `Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
            });
        }
        break;
      case 'prepared':
        Logger.info(TAG, 'AVPlayer state prepared called.');
        this.state = AudioPlayerState.PREPARED;
        this.isPrepared = true;
        AppStorage.setOrCreate('totalTime', MediaTool.msToCountdownTime(this.getDuration()));
        AppStorage.setOrCreate('progressMax', this.getDuration());
        if (this.avPlayer) {
          this.avPlayer.play();
        }
        this.setAVMetadata();
        Logger.info(TAG, 'AVPlayer prepared succeeded.');
        break;
      case 'playing':
        Logger.info(TAG, 'AVPlayer state playing called.');
        this.state = AudioPlayerState.PLAY;
        break;
      case 'paused':
        Logger.info(TAG, 'AVPlayer state paused called.');
        this.state = AudioPlayerState.PAUSE;
        break;
      case 'completed':
        Logger.info(TAG, 'AVPlayer state completed called.');
        this.state = AudioPlayerState.COMPLETED;
        this.playNextAuto(false);
        break;
      case 'stopped':
        Logger.info(TAG, 'AVPlayer state stopped called.');
        this.state = AudioPlayerState.STOP;
        if (this.avPlayer) {
          this.avPlayer.reset();
        }
        break;
      case 'released':
        Logger.info(TAG, 'AVPlayer state released called.');
        this.state = AudioPlayerState.RELEASED;
        break;
      default:
        Logger.info(TAG, 'AVPlayer state unknown called.');
        this.state = AudioPlayerState.UNKNOWN;
        break;
    }
    this.updateCardData();
    this.updateIsPlay(this.state === AudioPlayerState.PLAY); // 如果是播放状态，则更新
  }

  // 进度条刷新时间
  private updateTimeCall: (updateTime: number)=>void = (updateTime: number)=>{
    if(this.isCurrent){
      AppStorage.setOrCreate("currentTime", MediaTool.msToCountdownTime(updateTime));
      AppStorage.setOrCreate<number>("progress", updateTime);
    }
  }

  // 错误监听函数
  private errCall: (err: BusinessError)=>void = (err: BusinessError)=>{
    Logger.error(TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
    this.avPlayer?.reset();
  }

  // 获取持续时间
  private getDuration(){
    if (this.isPrepared && this.avPlayer) {
      return this.avPlayer.duration;
    }
    return 0;
  }

  // 直接调用的这种函数是fn(){}模式
  // 设置播放状态
  private async setPlayState(playbackState: avSession.AVPlaybackState){
    if(this.session){
      Logger.info(TAG, `playbackState ${JSON.stringify(playbackState)}`)
      this.session.setAVPlaybackState(playbackState, (err: BusinessError)=>{
        if (err) {
          Logger.info(TAG, `avPlayer ${JSON.stringify(err)}`);
          Logger.info(TAG, `SetAVPlaybackState BusinessError: code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, 'SetAVPlaybackState successfully');
        }
      })
    }
  }

  // 获取avPlayer上的currentTime已经播放的时间
  private getCurrentTime(){
    if (this.isPrepared && this.avPlayer) {
      return this.avPlayer.currentTime;
    }
    return 0;
  }

  // 播放音乐
  public async play(){
    Logger.info(TAG, 'AVPlayer play() isPrepared:' + this.isPrepared + ', state:' + this.state);
    BackgroundUtil.startContinuousTask(this.context);
    if (!this.isPrepared) {
      this.start(0);
    } else if (this.avPlayer) {
      this.avPlayer.play().then(() => {
        Logger.info(TAG, 'progressTime play() current time:' + this.getCurrentTime());
        this.seek(this.getCurrentTime());
        this.updateIsPlay(true);
        this.state = AudioPlayerState.PLAY;
      })
    }
  }

  // 是否自动播放下一首
  public playNextAuto(isFromControl: boolean){
    Logger.info(TAG, 'playNextAuto mode:' + this.playMode);
    switch (this.playMode) {
      case MusicPlayMode.SINGLE_CYCLE:
        if (isFromControl) {
          this.playNext();
        } else if (this.avPlayer) {
          this.avPlayer.play();
        }
        break;
      case MusicPlayMode.ORDER:
        this.playNext();
        break;
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      default:
        break;
    }
  }

  // 随机播放
  private playRandom() {
    let num = Math.round(Math.random() * (this.songList.length - 1));
    if (this.musicIndex === num) {
      this.playRandom();
    } else {
      this.updateMusicIndex(num);
      this.loadAssent(num);
    }
    Logger.info(TAG, 'play Random:' + this.musicIndex);
  }

  // 播放前一首
  public playPrevious() {
    switch (this.playMode) {
      case MusicPlayMode.RANDOM:
        this.playRandom();
        break;
      case MusicPlayMode.ORDER:
      case MusicPlayMode.SINGLE_CYCLE:
        if (this.musicIndex === 0) {
          this.updateMusicIndex(this.songList.length - 1);
        } else {
          this.updateMusicIndex(this.musicIndex - 1);
        }
        Logger.info(TAG, 'setLastIndex:' + this.musicIndex);
        this.loadAssent(this.musicIndex);
        break;
      default:
        break;
    }
  }

  // 播放下一首
  private playNext(){
    Logger.info(TAG, 'playNext Index:' + this.musicIndex + ', length-1:' + (this.songList.length - 1));
    if (this.musicIndex === this.songList.length - 1) {
      this.loadAssent(0);
    } else {
      this.loadAssent(this.musicIndex + 1);
    }
  }

  // 按照index播放音乐
  async loadAssent(musicIndex: number){
    if (musicIndex >= this.songList.length) {
      Logger.error(TAG, `current musicIndex ${musicIndex}`);
      return;
    }

    BackgroundUtil.startContinuousTask(this.context);
    this.updateMusicIndex(musicIndex);

    if(this.isFirst){
      this.isFirst = false;
    }
    if(this.avPlayer){
      this.songItem = await this.songItemBuilder.build(this.songList[this.musicIndex]);
      let url = this.songItemBuilder.getRealUrl();
      console.log(JSON.stringify(url))
      if(url){
        console.log("url_1")
        let avFileDescriptor: media.AVFileDescriptor = { fd: url.fd, offset: url.offset, length: url.length };
        this.avPlayer.fdSrc = avFileDescriptor;
        Logger.info(TAG, 'loadAsset avPlayer.url:' + this.avPlayer.fdSrc);
      }
    }
    else{
      console.log("url_2")
      await this.stop();
      Logger.info(`loadAssent reset ${this.songItem} src ${this.songList[this.musicIndex].src}`)
      if (this.songItem === null || this.songItem.src !== this.songList[this.musicIndex].src) {
        await this.reset();
      }
    }
  }

  // 更新musicIndex
  private updateMusicIndex(musicIndex: number){
    Logger.info(TAG, 'updateMusicIndex ===> ' + musicIndex);
    AppStorage.setOrCreate('selectIndex', musicIndex);
    if (this.musicIndex !== musicIndex) {
      this.musicIndex = musicIndex;
    }

    Logger.info(TAG, 'this.session !== undefined ===> ' + (this.session != undefined));
    if (this.session !== undefined) {
      this.setAVMetadata();
    }
  }

  // 开始
  private start(seekMs?: number) {
    Logger.info(TAG, 'AVPlayer play() isPrepared:' + this.isPrepared + ', state:' + this.state + '，seek:' + seekMs);
    if (this.avPlayer) {
      this.avPlayer.prepare().then(() => {
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `start error ${JSON.stringify(error)}`)
        this.state = AudioPlayerState.ERROR;
        this.updateIsPlay(false);
        this.isPrepared = false;
      });
    }
  }

  // 暂停音乐播放
  public pause(){
    Logger.info(TAG, 'AVPlayer pause() isPrepared:' + this.isPrepared + ', state:' + this.state);
    if (this.isPrepared && this.state === AudioPlayerState.PLAY && this.avPlayer) {
      this.avPlayer.pause().then(() => {
        this.state = AudioPlayerState.PAUSE;
        this.updateIsPlay(false);
      });
    }
  }

  // 停止
  public async stop() {
    Logger.info(TAG, 'stop()');
    if (this.isPrepared && this.avPlayer) {
      await this.avPlayer.pause(); // 此处调用stop不生效
      this.state = AudioPlayerState.STOP;
      AppStorage.setOrCreate<boolean>('isPlay', false); // isPlay很多地方会用到判断是否是播放态展示相关组件
      this.setPlayState({state: avSession.PlaybackState.PLAYBACK_STATE_STOP})
    }
  }

  // 更新播放状态
  private updateIsPlay(isPlay: boolean) {
    AppStorage.setOrCreate<boolean>('isPlay', isPlay);
    this.setPlayState({
      state: isPlay ? avSession.PlaybackState.PLAYBACK_STATE_PLAY : avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      position: {
        elapsedTime: this.getCurrentTime(),
        updateTime: new Date().getTime()
      }
    });
  }

  // 设置到播放条的某个位置
  public seek(ms: number) {
    if (this.isPrepared && this.state != AudioPlayerState.ERROR && this.avPlayer) {
      let seekMode = this.getCurrentTime() < ms ? 0 : 1;
      let realTime = (ms <= 0 ? 0 : (ms >= this.getDuration() ? this.getDuration() : ms));
      this.isCurrent = false;
      this.avPlayer.seek(realTime, seekMode);
    }
  }

  // 重置
  private async reset() {
    Logger.info(TAG, 'reset()');
    await this.songItemBuilder.release();
    if (this.avPlayer) {
      await this.avPlayer.reset();
    }
    this.isPrepared = false;
  }

  public getFirst() {
    return this.isFirst;
  }

  public setPlayModel(playMode: MusicPlayMode) {
    this.playMode = playMode;
    Logger.info(TAG, 'setPlayModel mode: ' + this.playMode);
  }

  public getPlayMode() {
    return this.playMode;
  }

  public release() {
    if (this.avPlayer && this.session && this.context) {
      this.updateIsPlay(false);
      this.stop();
      this.reset();
      this.avPlayer.release();
      this.state = AudioPlayerState.IDLE;
      BackgroundUtil.stopContinuousTask(this.context);
      this.unregisterSessionListener();
      this.session.destroy((err: BusinessError) => {
        if (err) {
          Logger.error(TAG, `Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
        } else {
          Logger.info(TAG, `Destroy : SUCCESS `);
        }
      });
    }
  }

  public async updateCardData() {
    try {
      if (!this.context) return;

      PreferenceUtil.getInstance().removePreferencesFromCache(this.context);
      this.formIds = await PreferenceUtil.getInstance().getFormIds(this.context);
      if (this.formIds === null || this.formIds === undefined) {
        Logger.error(TAG, 'WANG formIds is null');
        return;
      }

      let cardSongList: Array<SongItem> = [];
      if (this.musicIndex + SongConstant.ADD_INDEX_ONE === this.songList.length) {
        cardSongList = this.songList.slice(SongConstant.SLICE_START_ZERO, SongConstant.SLICE_END_THREE);
      } else if (this.musicIndex + SongConstant.ADD_INDEX_TWO === this.songList.length) {
        cardSongList.push(this.songList[this.songList.length - 1]);
        cardSongList.push(this.songList[0]);
        cardSongList.push(this.songList[1]);
      } else if (this.musicIndex + SongConstant.ADD_INDEX_THREE === this.songList.length) {
        cardSongList = this.songList.slice(this.songList.length - SongConstant.SLICE_INDEX_TWO,
          this.songList.length);
        cardSongList.push(this.songList[0]);
      } else {
        cardSongList = this.songList.slice(this.musicIndex + SongConstant.SLICE_INDEX_ONE,
          this.musicIndex + SongConstant.SLICE_INDEX_FOUR);
      }
      let formData: CardData = {
        isPlay: this.state === AudioPlayerState.PLAY,
        musicName: this.songList[this.musicIndex].title,
        musicCover: this.songList[this.musicIndex].label,
        musicSinger: this.songList[this.musicIndex].singer,
        cardSongList: cardSongList
      }
      let formInfo = formBindingData.createFormBindingData(formData);

      this.formIds.forEach(formId => {
        formProvider.updateForm(formId, formInfo).then(() => {
          Logger.info(TAG, 'WANG updateForm data succeed' + ', formId:' + formId);
        }).catch((error: BusinessError) => {
          Logger.error(TAG, 'updateForm err:' + JSON.stringify(error));
          if (error.code === SongConstant.ID_NO_EXIT && this.context) {
            PreferenceUtil.getInstance().removeFormId(this.context, formId);
          }
        })
      })
    } catch (error) {
      Logger.error(TAG, `updateCardData err: ${(error as BusinessError).code}`);
    }
  }

  public async updateOnDestroy() {
    if (this.formIds === null || this.formIds === undefined) {
      Logger.error(TAG, 'formIds is null');
      return;
    }
    let formData: Record<string, boolean> = {
      'isPlay': false
    }
    let formInfo = formBindingData.createFormBindingData(formData);
    for (let index = 0; index < this.formIds.length; index++) {
      await formProvider.updateForm(this.formIds[index], formInfo);
    }
  }
}