import { BreakpointConstant } from '@ohos/commonConstant';
import ViewItem from '../viewmodel/ViewItem';
import ViewModel from '../viewmodel/ViewModel';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State viewList: ViewItem[]= ViewModel.getViewList();

  build() {
    // 一行
    GridRow({
      breakpoints: {
        value: BreakpointConstant.BREAKPOINT_VALUE,
        reference: BreakpointsReference.WindowSize // 参照物
      },
      columns: {
        sm: BreakpointConstant.COLUMN_SM,
        md: BreakpointConstant.COLUMN_MD,
        lg: BreakpointConstant.COLUMN_LG
      },
      gutter: { x: BreakpointConstant.GUTTER_X}, //栅格水平方向间距
      direction: GridRowDirection.Row
    }){
      // 行里面的是多列
      GridCol({
        // 列占多少span
        span: {
          sm: BreakpointConstant.SPAN_SM,
          md: BreakpointConstant.SPAN_MD,
          lg: BreakpointConstant.SPAN_LG
        },
        offset: { // 栅格子组件相对原来位置的偏移列数
          md: BreakpointConstant.OFFSET_MD,
          lg: BreakpointConstant.OFFSET_LG
        }
      }){
        Column({space: 12}){
          ForEach(this.viewList, (item: ViewItem)=>{
            Column(){
              Text(item.title)
                .fontSize('28fp')
                .fontColor('#fff')

              Text(item.description)
                .fontSize('18fp')
                .opacity(0.6)
                .fontColor('#fff')
                .margin({top: 8})

              Blank()

              Column(){
                Button(){
                  Text(item.button)
                    .fontSize('16fp')
                    .fontColor('#fff')
                }
                .backgroundColor('#ff1949')
                .borderRadius(20)
                .width(120)
                .height(40)
                .onClick(()=>{
                  // 路由模式为单实例模式
                  // 如果目标页面的url已经存在于页面栈中，则该url页面移动到栈顶
                  console.log('123')
                  router.pushUrl({ url: item.url}, router.RouterMode.Single)
                })
              }
              .alignItems(HorizontalAlign.End)
              .width('100%')
            }
            .width('100%')
            .height(200)
            .backgroundImage(item.icon)
            .backgroundImageSize({width: '100%', height: 200})
            .borderRadius(24)
            .padding(24)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
          }, (item: ViewItem)=>JSON.stringify(item))
        }
      }
    }
    .padding({top: 64, left: 12, right: 12})
  }
}