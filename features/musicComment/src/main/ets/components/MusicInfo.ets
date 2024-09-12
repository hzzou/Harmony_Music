import { StyleConstant } from '@ohos/constantCommon';
import { SongItem } from '@ohos/mediaCommon';

@Component
export struct MusicInfo{
  @StorageProp('selectIndex') selectIndex: number = 0;
  @StorageLink('songList') songList: SongItem[] = [];

  build() {
    Row(){
      Image(this.songList[this.selectIndex].label)
        .width($r('app.float.info_image_width'))
        .height($r('app.float.info_image_height'))
        .margin({
          right: $r('app.float.info_image_margin_right')
        })
        .borderRadius($r('app.float.info_image_border'))

      Column(){
        Text(this.songList[this.selectIndex].title)
          .fontSize($r('app.float.info_title_size'))
          .fontColor($r('app.color.info_title_color'))

        Text(this.songList[this.selectIndex].singer)
          .fontSize($r('app.float.info_singer_size'))
          .fontColor($r('app.color.info_singer_color'))
          .lineHeight($r('app.float.info_singer_line_height'))
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      Image($r('app.media.ic_arrow_right'))
        .width($r('app.float.arrow_right_width'))
        .height($r('app.float.arrow_right_height'))
    }
    .width(StyleConstant.FULL_WIDTH)
    .height($r('app.float.info_height'))
    .padding({
      top: $r('app.float.info_padding_top'),
      bottom: $r('app.float.info_padding_bottom')
    })
  }
}