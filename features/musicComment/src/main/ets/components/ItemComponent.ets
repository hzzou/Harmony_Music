import { StyleConstant } from '@ohos/constantCommon';
import { Comment } from '../viewmodel/Comment'

@Component
export struct ItemComponent{
  private item: Comment = new Comment('', '', '', $r('app.media.ic_avatar12'));

  build() {
    Row(){
      Image(this.item.icon)
        .width($r('app.float.list_image_width'))
        .height($r('app.float.list_image_height'))
        .borderRadius($r('app.float.list_border_radius'))
        .margin({right: $r('app.float.list_image_margin_right')})

      Column(){
        Row(){
          Column(){
            Text(this.item.nickname)
              .fontSize($r('app.float.nickname_font_size'))
              .fontColor($r('app.color.nickname_color'))

            Text(this.item.time)
              .fontSize($r('app.float.time_font_size'))
              .fontColor($r('app.color.time_color'))
              .margin({top: $r('app.float.time_margin_top')})

            Text(this.item.content)
              .fontSize($r('app.float.content_font_size'))
              .fontColor($r('app.color.content_color'))
              .margin({top: $r('app.float.content_margin_top')})
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Blank()

          Image($r('app.media.ic_good'))
            .width($r('app.float.good_width'))
            .height($r('app.float.good_height'))
            .margin({top: $r('app.float.good_margin_top')})
        }
        .width(StyleConstant.FULL_WIDTH)
        .alignItems(VerticalAlign.Top)

        if(this.item.commentList && this.item.commentList.length > 0){

        }
      }
      .layoutWeight(1)
    }
    .width(StyleConstant.FULL_WIDTH)
    .alignItems(VerticalAlign.Top)
    .padding({top: $r('app.float.list_padding_top')})
  }
}