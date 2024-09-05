import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon/';
import { BreakpointSystem } from '@ohos/mediaCommon/';
import { Content } from '../components/Content';
import { Header } from '../components/Header';
import { Player } from '../components/Player';
import { songList } from '../viewmodel/SongData';

@Entry
@Component
struct Index {
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @State currentBreakpoint: string = BreakpointConstant.BREAKPOINT_SM;
  // 把变量双向绑定到全局AppStorage
  // @LocalStorageLink 是双向绑定到当前页面级别
  @StorageLink('deviceHeight') deviceHeight: number = 0;

  @State message: string = 'Music List';
  // @Component组件创建时执行一次
  aboutToAppear(): void {
    AppStorage.setOrCreate('songList', songList); //存音乐列表
    // 此处注册后会激发BreakpointSystem里面的AppStorage.setOrCreate存currentBreakpoint变量到AppStorage
    this.breakpointSystem.register();
  }

  aboutToDisappear(): void {
    this.breakpointSystem.unregister();
  }

  // 页面之间转场
  pageTransition() {
    //PageTransitionEnter({duration: SongConstant.TRANSITION_DURATION, curve: Curve.Smooth, type: RouteType.Pop})
    //PageTransitionExit({duration: SongConstant.TRANSITION_DURATION, curve: Curve.Smooth, type: RouteType.Push})
  }

  build() {
    Column(){
      Header({currentBreakpoint: this.currentBreakpoint})
      Content({currentBreakpoint: this.currentBreakpoint})
      Player({currentBreakpoint: this.currentBreakpoint})
    }
    .width(StyleConstant.FULL_WIDTH)
    .backgroundColor(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
    $r('app.color.page_background_sm') : $r('app.color.page_background_other'))
    .onAreaChange((oldArea: Area, newArea: Area)=>{
      if(typeof newArea.height === 'number'){
        this.deviceHeight = newArea.height;
      }
    })
  }
}