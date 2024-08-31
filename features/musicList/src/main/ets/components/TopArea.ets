import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon';
import { BreakpointType } from '@ohos/mediaCommon';

@Component
export struct TopArea{
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'; //受storage单向变化通知，可在本地修改
  @Link isShowPlay: boolean; // @Link只能从父组件初始化

  build() {
    Row(){
      Image($r('app.media.ic_back_down'))
        .width(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_LG ?
        $r('app.float.back_width_lg') : $r('app.float.common_image'))
        .height(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_LG ?
        $r('app.float.back_width_lg') : $r('app.float.common_image'))
        .onClick(()=>{
          this.isShowPlay = false;
        })

      Image($r('app.media.ic_music_share'))
        .width(new BreakpointType({
          sm: $r('app.float.common_image'),
          md: $r('app.float.common_image'),
          lg: $r('app.float.control_image_lg')
        }).getValue(this.currentBreakpoint))
        .height(new BreakpointType({
          sm: $r('app.float.common_image'),
          md: $r('app.float.common_image'),
          lg: $r('app.float.control_image_lg')
        }).getValue(this.currentBreakpoint))
        .objectFit(ImageFit.Contain)

    }
    .height($r('app.float.info_margin_top_sm'))
    .width(StyleConstant.FULL_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}