import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon';
import { SongItem } from '@ohos/mediaCommon';

@Component
export struct MusicInfo{
  @State currentTabIndex: number = 0;
  @State isShowControl: boolean = false;

  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstant.BREAKPOINT_SM;
  @StorageProp('selectIndex') selectIndex: number = 0;

  @StorageLink('isFoldFull') isFoldFull: boolean = false;
  @StorageLink('songList') songList: SongItem[] = [];

  build() {
    GridRow({
      columns: {
        xs: BreakpointConstant.COLUMN_SM,
        sm: BreakpointConstant.COLUMN_SM,
        md: BreakpointConstant.COLUMN_MD
      },
      gutter: BreakpointConstant.GUTTER_MUSIC_X,
      breakpoints: {reference: BreakpointsReference.ComponentSize}
    }){
      GridCol({
        span: {
          xs: BreakpointConstant.SPAN_SM,
          sm: BreakpointConstant.SPAN_SM,
          md: BreakpointConstant.SPAN_MD
        },
        offset: {
          md: BreakpointConstant.OFFSET_MD
        }
      }){
        Column(){

        }
        .height(StyleConstant.FULL_HEIGHT)
        .width(StyleConstant.FULL_WIDTH)
        .clip(false)
      }
    }
  }
}