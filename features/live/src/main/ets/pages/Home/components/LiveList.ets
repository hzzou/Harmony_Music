import { BreakpointConstant } from '@ohos/commonConstant';
import { LiveStream } from '../../../viewmodel/LiveStream';
import StreamModel from '../../../viewmodel/StreamModel';

@Component
export struct LiveList{

  private scroller: Scroller = new Scroller();
  @State currentBreakpoint: string = 'sm';
  @State liveList: LiveStream[] = StreamModel.getStreamList();

  @Builder
  LiveItem(item: LiveStream){
    Stack({alignContent: Alignment.Center}){
      Image(item.liveBackground)
        .size({width: '100%', height: 200})
        .borderRadius(24)

      Column(){
        Row(){
          Image($r('app.media.ic_video'))
            .size({width: 24, height: 24})
            .margin({top: this.currentBreakpoint === 'sm' ? 12 : 24})
        }
        .height(112)
        .width('100%')
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.End)

        Column(){
          Row(){
            Text(item.title)
              .fontColor('#fff')
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .fontSize('22fp')
          }
          .height(28)
          .width('100%')
          .margin({top: this.currentBreakpoint === 'sm' ? 21 : 14})

          Row(){
            Text(item.liveIntroduction)
              .fontFamily('HarmonyHeiTi')
              .fontSize('12fp')
              .fontColor('#99ffffff')
          }
          .width('100%')
          .height(18)
          .margin({top: 2})
        }
        .height(88)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
      }
      .height(200)
      .padding({
        left: this.currentBreakpoint === 'sm' ? 16 : 24,
        right: this.currentBreakpoint === 'sm' ? 16 : 24
      })
    }
    .width('100%')
    .margin({bottom: 12})
  }

  build() {
    GridRow({
      breakpoints:{
        value: BreakpointConstant.BREAKPOINT_VALUE,
        reference: BreakpointsReference.WindowSize
      },
      columns: {
        sm: BreakpointConstant.COLUMN_SM,
        md: BreakpointConstant.COLUMN_MD,
        lg: BreakpointConstant.COLUMN_LG,
      },
      gutter: {x: BreakpointConstant.GUTTER_X}
    }){
      GridCol({
        span:{
          sm: BreakpointConstant.SPAN_SM,
          md: BreakpointConstant.SPAN_MD,
          lg: BreakpointConstant.SPAN_LG
        },
        offset: {
          md: BreakpointConstant.OFFSET_MD,
          lg: BreakpointConstant.OFFSET_LG
        }
      }){
        Scroll(this.scroller){
          Column(){
            ForEach(this.liveList, (item: LiveStream)=>{
              this.LiveItem(item)
            }, (item: LiveStream)=>JSON.stringify(item))
          }
          .width('100%')
        }
        .align(Alignment.Top)
        .scrollBar(BarState.Off)
        .margin({bottom: 56})
      }
      .margin({left: 12, right: 12})
    }
    .onBreakpointChange((breakPoints)=>{
      console.log('breakpoint: ', breakPoints);
      this.currentBreakpoint = breakPoints;
    })
  }
}