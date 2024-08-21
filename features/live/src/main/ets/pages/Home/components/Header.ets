import { router } from '@kit.ArkUI'

@Component
export struct Header{

  build() {
    Row(){
      Image($r('app.media.ic_back'))
        .width(24)
        .height(24)
        .margin({left: 24})
        .onClick(()=>{
          router.back();
        })

      Text($r('app.string.live_title'))
        .fontSize('20fp')
        .fontFamily('HarmonyHeiTi-Bold')
        .fontWeight(700)
        .fontColor('#ff182431')
        .margin({left: 16})
        .height(28)
    }
    .height(56)
    .width('100%')
  }
}
