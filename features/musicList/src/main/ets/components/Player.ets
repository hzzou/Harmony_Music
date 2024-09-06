import { StyleConstant } from '@ohos/constantCommon';
import { BreakpointType, Logger, MediaService, SongItem } from '@ohos/mediaCommon';
import { displaySync } from '@kit.ArkGraphics2D';
import { PlayerConstant } from '../constants/PlayerConstant';
import { curves, window } from '@kit.ArkUI';
import { MusicControl } from './MusicControl';
import { BusinessError } from '@kit.BasicServicesKit';


@Component
export struct Player{
  // 变量单向绑定到全局
  @StorageProp("selectIndex") selectIndex: number = 0;
  @StorageLink("isPlay") @Watch('animationFun') isPlay: boolean = false;
  @StorageLink("songList") songList: SongItem[] = [];
  @StorageLink("topArea") topArea: number = 0;
  @StorageLink("bottomArea") bottomArea: number = 0;
  @StorageLink("isShowPlay") isShowPlay: boolean = false;
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
  MusicPlayerBuilder(){
    Column(){
      Column(){
        MusicControl({isShowPlay: this.isShowPlay})
      }
      .height((100 - this.componentHeight)+'%') //此处控制弹窗高度
    }
    .height(StyleConstant.FULL_HEIGHT)
    .width(StyleConstant.FULL_WIDTH)
    .justifyContent(FlexAlign.End)
    .transition(TransitionEffect.translate({y: 1000}).animation({curve: curves.springMotion(0.6, 0.8)}))
    .gesture(
      PanGesture(this.panOption)
        .onActionUpdate((event: GestureEvent)=>{
          // 手势移动
          if(event){
            let height = (event.offsetY / this.deviceHeight) * 100;
            this.componentHeight = height;

            if(this.componentHeight < 0){
              this.componentHeight = 0;
            }
          }
        })
        .onActionEnd(()=>{
          // 手势抬起，即手势结束后
          if(this.componentHeight > 40){
            this.isShowPlay = false;
          }
          else{
            this.componentHeight = 0;
          }
        })) // PanGesture 拖动手势
    .onAppear(()=>{
      // 获取当前应用内最上层的子窗口, getContext(this)获取当前应用context
      window.getLastWindow(getContext(this)).then(async (win: window.Window)=>{
        // 返回当前应用内最后显示的窗口对象win
        // 获取当前窗口内容规避的区域, 如系统栏、刘海屏、手势区、软键盘区等需要避让的区域
        // 此处获取的避让类型是系统默认区域
        let topArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM); // 得到的都是以px为单位
        this.topArea = px2vp(topArea.topRect.height);
        console.log('topArea: '+this.topArea);
        // 此处获取的避让类型是底部导航条区域
        let bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        this.bottomArea = px2vp(bottomArea.bottomRect.height);
        console.log('bottomArea: '+this.bottomArea);

        // 设置沉浸式布局
        if(this.topArea > 0){
          await win.setWindowLayoutFullScreen(true);
        }

        // 设置状态栏文字颜色
        let sysBarProps: window.SystemBarProperties = {
          statusBarColor: '#fff'
        };

        await win.setWindowSystemBarProperties(sysBarProps);
      }).catch((err: BusinessError)=>{
        Logger.error(`${err.code} + ${err.message}`)
      });
    })
    .onDisAppear(()=>{
      this.componentHeight = 0;
      this.isShowPlay = false;
      window.getLastWindow(getContext(this)).then(async (win: window.Window)=>{
        let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let topHeight = px2vp(area.topRect.height);

        if(topHeight > 0){
          await win.setWindowLayoutFullScreen(false);
        }

        // 设置状态栏文字颜色
        let sysBarProps: window.SystemBarProperties = {
          statusBarColor: '#000'
        };

        await win.setWindowSystemBarProperties(sysBarProps);
      }).catch((error: BusinessError)=>{
        Logger.error(`${error.code} + ${error.message}`)
      })
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
    .bindContentCover($$this.isShowPlay, this.MusicPlayerBuilder(), ModalTransition.DEFAULT) // 显示弹窗
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