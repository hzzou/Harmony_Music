import { BreakpointConstant } from '@ohos/constantCommon';
import { BreakpointSystem } from '@ohos/mediaCommon';

@Entry
@Component
struct Index {
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @State currentBreakpoint: string = BreakpointConstant.BREAKPOINT_SM;
  // 把遍历双向绑定到全局AppStorage
  // @LocalStorageLink 是双向绑定到当前页面级别
  @StorageLink('deviceHeight') deviceHeight: number = 0;

  @State message: string = 'Music List';
  // @Component组件创建时执行一次
  aboutToAppear(): void {
    console.log(AppStorage.get("deviceHeight"));
  }

  aboutToDisappear(): void {

  }

  // 页面之间转场
  pageTransition() {
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}