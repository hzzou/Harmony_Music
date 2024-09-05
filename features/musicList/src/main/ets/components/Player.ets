import { StyleConstant } from '@ohos/constantCommon';
import { BreakpointType, MediaService, SongItem } from '@ohos/mediaCommon';
import { displaySync } from '@kit.ArkGraphics2D';
import { PlayerConstant } from '../constants/PlayerConstant';
import { curves } from '@kit.ArkUI';
import { MusicControl } from './MusicControl';


@Component
export struct Player{
  // 变量单向绑定到全局
  @StorageProp("selectIndex") selectIndex: number = 0;
  @StorageLink("isPlay") @Watch('animationFun') isPlay: boolean = false;
  @StorageLink("songList") songList: SongItem[] = [];
  @StorageLink("topArea") topArea: number = 0;
  @StorageLink("bottomArea") bottomArea: number = 0;
  @StorageLink("isShowPlay") @Watch('watchPlay') isShowPlay: boolean = false;
  @StorageLink("deviceHeight") deviceHeight: number = 0;

  @Link currentBreakpoint: string; // 从父组件初始化
  @State imageRotate: number = 0; // 图片旋转变量
  @State componentHeight: number = 0;
  @State mediaService: MediaService = MediaService.getInstance();

  private panOption: PanGestureOptions = new PanGestureOptions({direction: PanDirection.Vertical});
  private backDisplaySyncSlow: displaySync.DisplaySync | undefined = undefined; // 可变帧自绘制UI
  // 动画旋转，改变imageRotate, 让图片旋转
  private drawFrame: (value: displaySync.IntervalInfo)=>void = (value: displaySync.IntervalInfo)=>{
    if(this.imageRotate >= 360){
      this.imageRotate = 0;
    }
    this.imageRotate += 1;
  }

  // 从list点击播放传导过来
  watchPlay(){
    if(this.isShowPlay){
      this.isPlay = true;
      this.animationFun();
    }
  }

  // label图片开始动画
  animationFun(){
    if(this.isPlay){
      this.backDisplaySyncSlow?.start();
    }
    else{
      this.backDisplaySyncSlow?.stop();
    }
  }

  aboutToAppear(): void {
    let range : ExpectedFrameRateRange = {
      expected: 30,
      min: 0,
      max: 30
    };

    this.backDisplaySyncSlow = displaySync.create();
    this.backDisplaySyncSlow.setExpectedFrameRateRange(range); // 设置期望的帧率范围
    this.backDisplaySyncSlow.on('frame', this.drawFrame); // 订阅每一帧变化
  }

  aboutToDisappear(): void {
    this.backDisplaySyncSlow?.off('frame', this.drawFrame);
  }

  // 点击底部播放区域的时候弹出播放页
  @Builder
  musicPlayerBuilder(){
    Column(){
      MusicControl({isShowPlay: this.isShowPlay})
    }
    .height(StyleConstant.FULL_HEIGHT)
    .width(StyleConstant.FULL_WIDTH)
    .justifyContent(FlexAlign.End)
    .transition(TransitionEffect.translate({y: 1000}).animation({curve: curves.springMotion(0.6, 0.8)}))
    .onAppear(()=>{
      /*window.getLastWindow(getContext(this)).then((win: window.Window)=>{
        let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        this.topArea = px2vp(area.topRect.height);
        let bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        this.bottomArea = px2vp(bottomArea.bottomRect.height);
        Logger.info("bottomArea "+this.bottomArea);

        if(this.topArea > 0){
          win.setWindowLayoutFullScreen(true);
        }

        let sysBarProps: window.SystemBarProperties = {
          statusBarColor: '#fff'
        };
        win.setWindowSystemBarProperties(sysBarProps);
      }).catch((err: BusinessError)=>{
        Logger.error(`${err.code} + ${err.message}`)
      });*/
    })
  }

  build() {
    Row(){
      Row(){
        Image(this.songList[this.selectIndex]?.label)
          .height($r('app.float.cover_height'))
          .width($r('app.float.cover_width'))
          .borderRadius($r('app.float.label_border_radius'))
          .margin({right: $r('app.float.cover_width')})
          .rotate({angle: this.imageRotate})
          .onAppear(()=>{
            this.animationFun();
          })

        Column(){
          Text(this.songList[this.selectIndex].title)
            .fontColor($r('app.color.song_name'))
            .fontSize(new BreakpointType({
              sm: $r('app.float.song_title_sm'),
              md: $r('app.float.song_title_md'),
              lg: $r('app.float.song_title_lg')
            }).getValue(this.currentBreakpoint))

          Row(){
            Image(this.songList[this.selectIndex].mark)
              .height($r('app.float.vip_icon_height'))
              .width($r('app.float.vip_icon_width'))
              .margin({right: $r('app.float.vip_icon_margin')})

            Text(this.songList[this.selectIndex].singer)
              .fontColor($r('app.color.singer'))
              .fontSize(new BreakpointType({
                sm: $r('app.float.singer_font_sm'),
                md: $r('app.float.singer_font_md'),
                lg: $r('app.float.singer_font_lg'),
              }).getValue(this.currentBreakpoint))
              .opacity($r('app.float.singer_opacity'))
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(PlayerConstant.LAYOUT_WEIGHT_PLAYER_CONTROL)
      .onClick(()=>{
        this.isShowPlay = true;
      })

      Blank()
        .onClick(()=>{
          this.isShowPlay = true;
        })

      Row(){
        Image($r('app.media.ic_previous'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .margin({right: $r('app.float.control_icon_margin')})
          .displayPriority(PlayerConstant.DISPLAY_PRIORITY_TWO) // 显示优先级，越高越主要显示

        Image(this.isPlay ? $r('app.media.ic_play') : $r('app.media.ic_pause'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .displayPriority(PlayerConstant.DISPLAY_PRIORITY_THREE)
          .onClick(()=>{
            if(this.mediaService.getFirst()){
              this.mediaService.loadAssent(0);
            }
            else{
              this.isPlay ? this.mediaService.pause() : this.mediaService.play();
            }
          })

        Image($r('app.media.ic_next'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .margin({
            right: $r('app.float.control_icon_margin'),
            left: $r('app.float.control_icon_margin')
          })
          .displayPriority(PlayerConstant.DISPLAY_PRIORITY_TWO)
          .onClick(()=>{
            this.mediaService.playNextAuto(true)
          })

        Image($r('app.media.ic_music_list'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .displayPriority(PlayerConstant.DISPLAY_PRIORITY_ONE)
      }
      .width(new BreakpointType({
        sm: $r('app.float.play_width_sm'),
        md: $r('app.float.play_width_sm'),
        lg: $r('app.float.play_width_lg')
      }).getValue(this.currentBreakpoint))
      .justifyContent(FlexAlign.End)

    }
    .width(StyleConstant.FULL_WIDTH)
    .height($r('app.float.player_area_height'))
    .backgroundColor($r('app.color.player_background'))
    .bindContentCover($$this.isShowPlay, this.musicPlayerBuilder(), ModalTransition.DEFAULT) // 显示弹窗
    .padding({left: $r('app.float.player_padding'), right: $r('app.float.player_padding')})
    .gesture(
      PanGesture(this.panOption)
        .onActionEnd((event?: GestureEvent)=>{
          if(event && event.offsetY < -10){
            this.isShowPlay = true;
          }
        })
    )
  }
}