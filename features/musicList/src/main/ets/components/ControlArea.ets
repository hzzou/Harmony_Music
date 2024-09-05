import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon';
import { BreakpointType, MediaService } from '@ohos/mediaCommon';
import { PlayerConstant } from '../constants/PlayerConstant';

@Component
export struct ControlArea{
  // 受到AppStorage更改的单向通知变化，即是AppStorage中的currentBreakpoint变化会更新到它，反之不会
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstant.BREAKPOINT_SM;

  // 和AppStorage中的更改双向影响
  @StorageLink('isPlay') isPlay: boolean = false;
  @StorageLink('currentTime') currentTime: string = '00:00';
  @StorageLink('totalTime') totalTime: string = '00:00';
  @StorageLink('progress') value: number = 0;
  @StorageLink('progressMax') max: number = 0;
  @StorageLink('imageColor') imageColor: string = '';
  @StorageLink('pageShowTime') pageShowTime: number = 0;

  @State mediaService: MediaService = MediaService.getInstance();

  build() {
    Column(){
      Row(){
        Image($r('app.media.ic_public_list_cycled'))
          .controlImage(this.currentBreakpoint)

        Image($r('app.media.ic_sequence'))
          .controlImage(this.currentBreakpoint)

        Image($r('app.media.ic_ring'))
          .controlImage(this.currentBreakpoint)

        Image($r('app.media.ic_more'))
          .controlImage(this.currentBreakpoint)
      }
      .width(StyleConstant.FULL_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)

      // 音乐进度条
      Column(){
        Slider({min: 0, max: this.max, step: 1, value: this.value})
          .blockColor($r('app.color.slider_block')) // 滑块颜色
          .selectedColor($r('app.color.slider_select')) // 已滑动部分的颜色
          .trackColor($r('app.color.slider_track')) // 滑轨背景色
          .blockSize({width: $r('app.float.slider_block'), height: $r('app.float.slider_block')}) // 滑块大小
          .height($r('app.float.slider_height'))
          .margin({
            left: new BreakpointType({
              sm: $r('app.float.slider_margin_sm'),
              md: $r('app.float.slider_margin_md'),
              lg: $r('app.float.slider_margin_lg'),
            }).getValue(this.currentBreakpoint),
            right: new BreakpointType({
              sm: $r('app.float.slider_margin_sm'),
              md: $r('app.float.slider_margin_md'),
              lg: $r('app.float.slider_margin_lg'),
            }).getValue(this.currentBreakpoint)
          })
          .hitTestBehavior(HitTestMode.Block) // 触摸测试类型。自身响应触摸测试，阻塞子节点和兄弟节点的触摸测试

        Row(){
          Text(this.currentTime)
            .fontColor($r('app.color.play_text_color'))
            .fontSize($r('app.float.singer_title_sm'))
            .fontFamily(PlayerConstant.FONT_FAMILY_BLACK)
            .lineHeight('14vp')

          Text(this.totalTime)
            .fontColor($r('app.color.play_text_color'))
            .fontSize($r('app.float.singer_title_sm'))
            .fontFamily(PlayerConstant.FONT_FAMILY_BLACK)
            .lineHeight('14vp')
        }
        .width(StyleConstant.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .margin({
        top: $r('app.float.slider_margin_top'),
        bottom: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_LG ? $r('app.float.slider_margin_bottom_lg') : $r('app.float.slider_margin_bottom')
      })

      Row(){
        Image($r('app.media.ic_public_forward'))
          .imgSet()
          .width(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_LG ? $r('app.float.control_width_lg') : $r('app.float.control_width'))
          .onClick(()=>{
            this.mediaService.playPrevious();
            this.pageShowTime = 0;
          })

      }
      .width(StyleConstant.FULL_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left: $r('app.float.control_padding'), right: $r('app.float.control_padding')})
    }
  }
}

@Extend(Image)
function imgSet() {
  .aspectRatio(1)
  .opacity(0.86)
  .objectFit(ImageFit.Contain)
}

// 代码重构 快捷键是Refactor -> Extract Method
@Extend(Image)
function controlImage(currentBreakpoint: string) {
  .width(new BreakpointType({
    sm: $r('app.float.twenty_four'),
    md: $r('app.float.twenty_four'),
    lg: $r('app.float.control_image_lg')
  }).getValue(currentBreakpoint))
  .aspectRatio(1)
  .opacity(0.86)
  .objectFit(ImageFit.Contain)
}
