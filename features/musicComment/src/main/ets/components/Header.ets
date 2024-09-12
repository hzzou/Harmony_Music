import { StyleConstant } from '@ohos/constantCommon'
import { router } from '@kit.ArkUI'

@Component
export struct Header{

  build() {
    Row(){
      Image($r('app.media.ic_public_back'))
        .width($r('app.float.header_image_width'))
        .height($r('app.float.header_image_height'))
        .margin({
          left: $r('app.float.header_margin_left'),
          right: $r('app.float.header_margin_right')
        })

      Text($r('app.string.comment_title'))
        .fontSize($r('app.float.header_font_size'))
        .fontColor($r('app.color.header_font_color'))
        .lineHeight($r('app.float.header_line_height'))
        .fontWeight(FontWeight.Medium)
    }
    .width(StyleConstant.FULL_WIDTH)
    .height($r('app.float.header_height'))
    .onClick(()=>{
      router.back()
    })
  }
}