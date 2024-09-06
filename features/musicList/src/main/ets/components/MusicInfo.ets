import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon';
import { SongItem } from '@ohos/mediaCommon';
import { PlayerConstant } from '../constants/PlayerConstant';
import { ControlArea } from './ControlArea';

@Component
export struct MusicInfo{
  @State currentTabIndex: number = 0;
  @State isShowControl: boolean = false;

  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstant.BREAKPOINT_SM;
  @StorageProp('selectIndex') selectIndex: number = 0;

  @StorageLink('isFoldFull') isFoldFull: boolean = false;
  @StorageLink('songList') songList: SongItem[] = [];


  @Builder
  CoverInfo(){
    Row(){
      Image(this.songList[this.selectIndex].label)
        .width(StyleConstant.FULL_WIDTH)
        .aspectRatio(1)
        .borderRadius($r('app.float.cover_radius_label'))
        .shadow({
          radius: $r('app.float.shadow_radius'),
          color: $r('app.color.shadow_color'),
          offsetX: 0,
          offsetY: 8
        })
        .margin($r('app.float.lyric_margin_right_sm'))
    }
  }

  @Builder
  MusicDetail(){
    Column(){
      // direction默认FlexDirection.Row
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }){
        Text(this.songList[this.selectIndex].title)
          .fontSize(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_MD && !this.isFoldFull ?
          $r('app.float.title_font_play_md') : $r('app.float.title_font_play'))
          .fontColor(Color.White)
          .opacity(0.86)
          .fontWeight(FontWeight.Bold)
          .fontFamily(PlayerConstant.FONT_FAMILY_BOLD)

        Image($r('app.media.ic_public_likes'))
          .width($r('app.float.likes_image'))
          .height($r('app.float.likes_image'))
          .objectFit(ImageFit.Contain)
          .fillColor(Color.White)
          .opacity(0.86)
      }

      Text(this.songList[this.selectIndex].singer)
        .textAlign(TextAlign.Start)
        .fontSize(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM && !this.isFoldFull ?
        $r('app.float.title_font_play') : $r('app.float.font_fourteen'))
        .fontColor($r('app.color.play_text_color'))
        .fontFamily(PlayerConstant.FONT_FAMILY_BLACK)
        .margin({top: $r('app.float.music_text_margin_top')})
        .width(StyleConstant.FULL_WIDTH)
        .fontWeight(FontWeight.Regular)
    }
    .margin({top: $r('app.float.music_info_margin_top')})
  }


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
          this.CoverInfo()
          this.MusicDetail()

          Blank()

          ControlArea()
        }
        .height(StyleConstant.FULL_HEIGHT)
        .width(StyleConstant.FULL_WIDTH)
        .clip(false)
      }
    }
  }
}