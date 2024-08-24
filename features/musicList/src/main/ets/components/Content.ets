import { GridConstant, StyleConstant } from '@ohos/constantCommon';
import { AlbumCover } from './AlbumCover';
import { PlayList } from './PlayList';

@Component
export struct Content{
  @Link currentBreakpoint: string;

  build() {
    // 一行Row
    GridRow(){
      // 两列Col, 根据在不同设备上设置所占宽度
      GridCol(
        {
          span: {sm: GridConstant.SPAN_TWELVE, md: GridConstant.SPAN_SIX, lg: GridConstant.SPAN_EIGHT}
        }
      ){
        AlbumCover({currentBreakpoint: this.currentBreakpoint})
      }
      .backgroundColor($r('app.color.album_background'))

      GridCol(
        {
          span: {sm: GridConstant.SPAN_TWELVE, md: GridConstant.SPAN_SIX, lg: GridConstant.SPAN_EIGHT}
        }
      ){
        PlayList({currentBreakpoint: this.currentBreakpoint})
      }
      .borderRadius($r('app.float.playlist_border_radius'))
    }
    .height(StyleConstant.FULL_HEIGHT)
    .width(StyleConstant.FULL_WIDTH)
    .onBreakpointChange((breakpoints: string)=>{
      this.currentBreakpoint = breakpoints;
    })
  }
}