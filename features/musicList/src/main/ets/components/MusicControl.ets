import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon'
import { ColorConversion, Logger, SongItem } from '@ohos/mediaCommon';
import { common } from '@kit.AbilityKit';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { PlayerConstant } from '../constants/PlayerConstant';
import { TopArea } from './TopArea';
import { MusicInfo } from './MusicInfo';
import { ControlArea } from './ControlArea';
import { LyricsComponent } from './LyricsComponent';


// Player组件的Row上的bindContentCover触发弹出全屏模态页面
@Component
export struct MusicControl{
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstant.BREAKPOINT_SM;
  @StorageProp('selectIndex') @Watch('getImageColor') selectIndex: number = 0;

  getImageColor(){
    if(!this.context) return;

    this.context.createModuleContext('musicList')
      .resourceManager
      .getMediaContent(this.songList[this.selectIndex].label)
      .then((value: Uint8Array)=>{
        let buffer = value.buffer as ArrayBuffer;
        image.createImageSource(buffer)
          .createPixelMap()
          .then((pixelMap)=>{
            effectKit.createColorPicker(pixelMap, (error, colorPicker)=>{
              if(error){
                Logger.error('Failed to create color picker.')
              }
              else{
                let color = colorPicker.getLargestProportionColor();
                let colorArr = ColorConversion.dealColor(color.red, color.green, color.blue);
                this.imageColor = `rgba(${colorArr[0]}, ${colorArr[1]}, ${colorArr[2]}, 1)`;
              }
            })
          })
          .catch((error: BusinessError)=>{
            Logger.error(`${error.code} + ${error.message}`)
          })
      })
  }

  @StorageLink('songList') songList: SongItem[] = [];
  @StorageLink('imageColor') imageColor: string = 'rgba(0, 0, 0, 1)';
  @StorageLink('topArea') topArea: number = 0; //来自player，决定弹窗的padding
  @StorageLink('bottomArea') bottomArea: number = 0; //来自player
  @StorageLink('pageShowTime') pageShowTime: number = 0;
  @StorageLink('isFoldFull') isFoldFull: boolean = false;


  @State isShowControl: boolean = true;
  @State isShowControlLg: boolean = true;
  @State isTablet: boolean = true;
  @State intervalID: number = 0; // 定时器ID

  @Link isShowPlay: boolean;

  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  private callback: Callback<display.FoldDisplayMode> = (data: display.FoldDisplayMode)=>{
    // 在应用程序中使用画中画功能
    if(canIUse('SystemCapability.Window.SessionManager')){
      if(data === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL){
        this.isFoldFull = true;
      }
      else{
        this.isFoldFull = false;
      }
    }
  }

  aboutToAppear(): void {
    this.getImageColor();
    try{
      // 在应用程序中使用画中画功能
      if(canIUse('SystemCapability.Window.SessionManager')){
        let mode = display.getFoldDisplayMode();
        if(mode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL){
          this.isFoldFull = true;
        }

        display.on('foldDisplayModeChange', this.callback);
      }
    } catch (exception) {
      Logger.error("Failed to register callback. Code: "+ JSON.stringify(exception));
    }
    console.log(this.isFoldFull+' :isFold');
    console.log(this.isShowPlay+' :isShowPlay');
  }

  aboutToDisappear(): void {
    if(canIUse('SystemCapability.Window.SessionManager')){
      display.off('foldDisplayModeChange', this.callback);
    }
  }

  build() {
    Stack(){
      // 在全局底部 蒙层
      Image(this.songList[this.selectIndex].label)
        .size(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_LG ? {width: PlayerConstant.BACK_IMAGE} : {height: PlayerConstant.BACK_IMAGE})
        .aspectRatio(1)
        .objectFit(ImageFit.Cover)
        .opacity(0.5) // 组件的透明度
        .blur(PlayerConstant.IMAGE_BLUR) // 内容模糊效果

      Row(){
        // 单屏设备
        if(this.isFoldFull){
          Column(){
            TopArea({isShowPlay: this.isShowPlay})
              .margin({
                bottom: $r('app.float.music_info_margin_top'),
                left: $r('app.float.top_margin_left')
              })

            GridRow({
              columns: {md: BreakpointConstant.COLUMN_MD},
              gutter: BreakpointConstant.GUTTER_MUSIC_X
            }){
              GridCol({
                span: {md: BreakpointConstant.SPAN_SM}
              }){
                // 音乐时间信息组件
                MusicInfo()
              }
              .margin({
                left: $r('app.float.margin_small'),
                right: $r('app.float.margin_small')
              })

              GridCol({
                span: {md: BreakpointConstant.SPAN_SM}
              }){
                // 歌词组件
                LyricsComponent()
              }
              .padding({left: $r('app.float.twenty_four')})
            }
            .layoutWeight(1)
            .margin({bottom: $r('app.float.fold_margin_bottom')})
          }
          .layoutWeight(1)
          .padding({
            left: $r('app.float.common_padding'),
            right: $r('app.float.common_padding')
          })
        }
        else if(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_LG){
          Column(){
            TopArea({isShowPlay: this.isShowPlay})
              .padding({
                left: $r('app.float.common_padding'),
                right: $r('app.float.common_padding')
              })

            GridRow({
              columns: {md: BreakpointConstant.COLUMN_MD, lg: BreakpointConstant.COLUMN_LG},
              gutter: BreakpointConstant.GUTTER_MUSIC_X
            }){
              GridCol({
                span: {md: BreakpointConstant.SPAN_SM, lg: BreakpointConstant.SPAN_SM},
                offset: {lg: BreakpointConstant.OFFSET_MD}
              }){
                Column(){
                  Image(this.songList[this.selectIndex].label)
                    .width(StyleConstant.FULL_WIDTH)
                    .aspectRatio(1)
                    .borderRadius($r('app.float.cover_radius'))

                  ControlArea()
                }
                .height(StyleConstant.FULL_HEIGHT)
                .justifyContent(FlexAlign.SpaceBetween)
                .margin({bottom: $r('app.float.common_margin')})
              }

              GridCol({
                span: {md: BreakpointConstant.SPAN_SM, lg: BreakpointConstant.SPAN_MD}
              }){
                // 歌词组件
                LyricsComponent()
              }
            }
            .layoutWeight(1)
            .padding({
              left: $r('app.float.common_padding'),
              right: $r('app.float.common_padding'),
              top: $r('app.float.lg_music_top'),
              bottom: $r('app.float.lg_music_margin_bottom')
            })
          }
        }
        else{
          // 对齐方式：顶部起始端
          Stack({alignContent: Alignment.TopStart}){
            Swiper(){
              MusicInfo()
                .margin({
                  top: $r('app.float.music_component_top'),
                  bottom: $r('app.float.music_component_bottom')
                })
                .padding({
                  left: $r('app.float.common_padding'),
                  right: $r('app.float.common_padding')
                })
              // 歌词组件
              LyricsComponent()
            }
            .height(StyleConstant.FULL_HEIGHT)
            .indicator( // 导航指示器样式
              new DotIndicator()
                .top($r('app.float.options_padding'))
                .color($r('app.color.slider_track'))
                .selectedColor($r('app.color.select_swiper'))
            )
            .clip(false) // 是否裁剪子组件
            .loop(false)
            .onChange((index: number)=>{
              if(index === 1){
                this.isShowControl = true;
                this.intervalID = setInterval(()=>{
                  this.pageShowTime += 1;

                  if(this.pageShowTime > 5){
                    this.isShowControl = false;
                    clearInterval(this.intervalID);
                  }
                }, 1000);
              }
              else{
                this.pageShowTime = 0;
                clearInterval(this.intervalID)
              }
            })

            TopArea({isShowPlay: this.isShowPlay})
              .padding({
                left: $r('app.float.common_padding'),
                right: $r('app.float.common_padding'),
              })
          }
          .height(StyleConstant.FULL_HEIGHT)
        }
      }
      .padding({
        top: this.topArea,
        bottom: this.bottomArea
      })

    }
    .width(StyleConstant.FULL_WIDTH)
    .height(StyleConstant.FULL_HEIGHT)
    .backgroundColor(this.imageColor)
  }
}