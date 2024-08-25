import { BreakpointConstant, GridConstant, StyleConstant } from '@ohos/constantCommon';
import { BreakpointType } from '@ohos/mediaCommon';
import { ContentConstant } from '../constants/ContentConstant';
import { OptionItem, optionList } from '../viewmodel/SongData';

@Component
export struct AlbumComponent{
  @State imgHeight: Length = 0; // Length类型属于长度单位
  @Link currentBreakpoint: string;

  @Builder
  CoverImage(){
    Stack({alignContent: Alignment.BottomStart}){
      Image($r('app.media.ic_album'))
        .width(StyleConstant.FULL_WIDTH)
        .aspectRatio(ContentConstant.ASPECT_RATIO_ALBUM_COVER)
        .borderRadius($r('app.float.album_cover_border_radius'))
        .onAreaChange((oldArea: Area, newArea: Area)=>{
          this.imgHeight = newArea.height;
        })

      Text($r('app.string.collection_num'))
        .letterSpacing(ContentConstant.LETTER_SPACING)
        .fontColor(Color.White)
        .fontSize(new BreakpointType({
          sm: $r('app.float.collection_font_sm'),
          md: $r('app.float.collection_font_md'),
          lg: $r('app.float.collection_font_lg'),
        }).getValue(this.currentBreakpoint))
        .translate({
          x: StyleConstant.TRANSLATE_X,
          y: StyleConstant.TRANSLATE_Y
        })
    }
    .width(StyleConstant.FULL_WIDTH)
    .height(StyleConstant.FULL_HEIGHT)
    .aspectRatio(ContentConstant.ASPECT_RATIO_ALBUM_COVER)
  }

  @Builder
  CoverIntroduction(){
    Column(){
      Text($r('app.string.list_name'))
        .opacity($r('app.float.album_name_opacity'))
        .fontWeight(ContentConstant.ALBUM_FONT_WEIGHT)
        .fontColor($r('app.color.album_name_introduction'))
        .fontSize(new BreakpointType({
          sm: $r('app.float.list_font_sm'),
          md: $r('app.float.list_font_md'),
          lg: $r('app.float.list_font_lg'),
        }).getValue(this.currentBreakpoint))
        .margin({bottom: $r('app.float.album_name_margin')})

      Text($r('app.string.playlist_Introduction'))
        .opacity($r('app.float.introduction_opacity'))
        .width(StyleConstant.FULL_WIDTH)
        .fontWeight(ContentConstant.INTRODUCTION_FONT_WEIGHT)
        .fontColor($r('app.color.album_name_introduction'))
        .fontSize(new BreakpointType({
          sm: $r('app.float.introduction_font_sm'),
          md: $r('app.float.introduction_font_md'),
          lg: $r('app.float.introduction_font_lg')
        }).getValue(this.currentBreakpoint))
    }
    .width(StyleConstant.FULL_WIDTH)
    .height(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ? this.imgHeight : $r('app.float.introduction_height'))
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .padding({
      left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ? $r('app.float.introduction_padding') : 0
    })
    .margin({
      top: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ? 0 : $r('app.float.introduction_margin_top'),
      bottom: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ? 0 : $r('app.float.introduction_margin_bottom')
    })
  }

  @Builder
  CoverOptions(){
    Row(){
      ForEach(optionList, (item: OptionItem)=>{
        Column({space: ContentConstant.COVER_OPTION_SPACE}){
          Image(item.image)
            .height($r('app.float.option_image_size'))
            .width($r('app.float.option_image_size'))

          Text(item.text)
            .fontColor($r('app.color.album_name_introduction'))
            .fontSize(new BreakpointType({
              sm: $r('app.float.option_font_sm'),
              md: $r('app.float.option_font_md'),
              lg: $r('app.float.option_font_lg'),
            }).getValue(this.currentBreakpoint))
        }
        .onClick(item.action)
      }, (item: OptionItem)=>JSON.stringify(item))
    }
    .height($r('app.float.option_area_height'))
    .width(StyleConstant.FULL_HEIGHT)
    .padding({left: $r('app.float.options_padding'), right: $r('app.float.options_padding')})
    .justifyContent(FlexAlign.SpaceBetween)

  }

  build() {
    // 先column一列包起来
    Column(){
      GridRow(){
        GridCol(
          {
            span: {sm: GridConstant.SPAN_FOUR, md: GridConstant.SPAN_TWELVE, lg: GridConstant.SPAN_TWELVE}
          }
        ){
          this.CoverImage()
        }

        GridCol(
          {
            span: {sm: GridConstant.SPAN_EIGHT, md: GridConstant.SPAN_TWELVE, lg: GridConstant.SPAN_TWELVE}
          }
        ){
          this.CoverIntroduction()
        }

        GridCol(
          {
            span: {sm: GridConstant.SPAN_TWELVE, md: GridConstant.SPAN_TWELVE, lg: GridConstant.SPAN_TWELVE}
          }
        ){
          this.CoverOptions()
        }
        .padding({
          top: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ? $r('app.float.option_margin') : 0,
          bottom: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ? $r('app.float.option_margin') : 0
        })
      }
      .width(StyleConstant.FULL_WIDTH)
      .padding({
        top: $r('app.float.list_item_padding'),
        left: new BreakpointType({
          sm: $r('app.float.album_padding_sm'),
          md: $r('app.float.album_padding_md'),
          lg: $r('app.float.album_padding_lg'),
        }).getValue(this.currentBreakpoint),
        right:  new BreakpointType({
          sm: $r('app.float.album_padding_sm'),
          md: $r('app.float.album_padding_md'),
          lg: $r('app.float.album_padding_lg'),
        }).getValue(this.currentBreakpoint)
      })
    }
    .margin({
      left: new BreakpointType({
        sm: $r('app.float.cover_margin_sm'),
        md: $r('app.float.cover_margin_md'),
        lg: $r('app.float.cover_margin_lg')
      }).getValue(this.currentBreakpoint),
      right: new BreakpointType({
        sm: $r('app.float.cover_margin_sm'),
        md: $r('app.float.cover_margin_md'),
        lg: $r('app.float.cover_margin_lg')
      }).getValue(this.currentBreakpoint)
    })
  }
}