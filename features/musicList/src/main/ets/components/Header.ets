import { StyleConstant } from '@ohos/constantCommon/';
import { HeaderConstant } from '../constants/HeaderConstant';
import { promptAction, router } from '@kit.ArkUI';
import { BreakpointType, MenuData } from '@ohos/mediaCommon';


@Component
export struct Header{
  @Link currentBreakpoint: string;

  getMenu(): MenuData[]{
    let menuItem: MenuData = new MenuData();
    let menuData: MenuData[] = [];

    if(canIUse(HeaderConstant.SYSCAP_ETHERNET)){
      menuItem.value = HeaderConstant.AUDIO_DEVICE_SERVICE;
      menuItem.action = (): void => {
        promptAction.showToast({
          message: HeaderConstant.AUDIO_DEVICE_SERVICE,
          duration: HeaderConstant.TOAST_DURATION
        })
      };
      menuData.push(menuItem);
    }
    return menuData;
  }

  build() {
    Row(){
      Image($r('app.media.ic_back'))
        .width($r('app.float.icon_width'))
        .height($r('app.float.icon_height'))
        .margin({left: $r('app.float.icon_margin')})
        .onClick(()=>{
          router.back();
        })

      Text($r('app.string.play_list'))
        .fontSize(
          new BreakpointType({
            sm: $r('app.float.header_font_sm'),
            md: $r('app.float.header_font_md'),
            lg: $r('app.float.header_font_lg')
          }).getValue(this.currentBreakpoint)
        )
        .fontWeight(HeaderConstant.TITLE_FONT_WEIGHT)
        .fontColor($r('app.color.title_color'))
        .opacity($r('app.float.title_opacity'))
        .letterSpacing(HeaderConstant.LETTER_SPACING)
        .padding({left: $r('app.float.title_padding_left')})

      Blank()

      Image($r('app.media.ic_more'))
        .fillColor('#000')
        .width($r('app.float.icon_width'))
        .height($r('app.float.icon_height'))
        .margin({right: $r('app.float.icon_margin')})
        .bindMenu(this.getMenu())
    }
    .backgroundColor(Color.White)
    .width(StyleConstant.FULL_WIDTH)
    .height($r('app.float.title_bar_height'))
    .zIndex(HeaderConstant.Z_INDEX)
  }
}