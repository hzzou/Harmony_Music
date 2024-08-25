import { StyleConstant } from '@ohos/constantCommon'
import { SongItem } from '@ohos/mediaCommon';
import { displaySync } from '@kit.ArkGraphics2D';
import { PlayerConstant } from '../constants/PlayerConstant';


@Component
export struct Player{
  // 变量单向绑定到全局
  @StorageProp("selectIndex") selectIndex: number = 0;
  @StorageLink("isPlay") @Watch('animationFun') isPlay: boolean = false;
  @StorageLink("songList") songList: SongItem[] = [];
  @StorageLink("topArea") topArea: number = 0;
  @StorageLink("bottomArea") bottomArea: number = 0;
  @StorageLink("isShowPlay") isShowPlay: boolean = false;
  @StorageLink("deviceHeight") deviceHeight: number = 0;

  @Link currentBreakpoint: string; // 从父组件初始化
  @State imageRotate: number = 0; // 图片旋转变量
  @State componentHeight: number = 0;

  private panOption: PanGestureOptions = new PanGestureOptions({direction: PanDirection.Vertical});
  private backDisplaySyncSlow: displaySync.DisplaySync | undefined = undefined; // 可变帧自绘制UI
  // 动画旋转，改变imageRotate, 让图片旋转
  private drawFrame: (value: displaySync.IntervalInfo)=>void = (value: displaySync.IntervalInfo)=>{
    if(this.imageRotate >= 360){
      this.imageRotate = 0;
    }
    this.imageRotate += 1;
  }

  // label图片开始动画
  animationFun(){
    if(this.isPlay){
      this.backDisplaySyncSlow?.start();
    }
    else{
      this.backDisplaySyncSlow?.stop();
    }
  }

  aboutToAppear(): void {
    let range : ExpectedFrameRateRange = {
      expected: 30,
      min: 0,
      max: 30
    };

    this.backDisplaySyncSlow = displaySync.create();
    this.backDisplaySyncSlow.setExpectedFrameRateRange(range); // 设置期望的帧率范围
    this.backDisplaySyncSlow.on('frame', this.drawFrame); // 订阅每一帧变化
  }

  aboutToDisappear(): void {
    this.backDisplaySyncSlow?.off('frame', this.drawFrame);
  }

  build() {
    Row(){
      Row(){
        Image(this.songList[this.selectIndex]?.label)
          .height($r('app.float.cover_height'))
          .width($r('app.float.cover_width'))
          .borderRadius($r('app.float.label_border_radius'))
          .margin({right: $r('app.float.cover_width')})
          .rotate({angle: this.imageRotate})
      }
      .layoutWeight(PlayerConstant.LAYOUT_WEIGHT_PLAYER_CONTROL)
      .onClick(()=>{
        this.isShowPlay = true;
      })

      Blank()
        .onClick(()=>{
          this.isShowPlay = true;
        })
    }
    .width(StyleConstant.FULL_WIDTH)
    .height($r('app.float.player_area_height'))
    .backgroundColor($r('app.color.player_background'))
    .padding({left: $r('app.float.player_padding'), right: $r('app.float.player_padding')})
    .gesture(
      PanGesture(this.panOption)
        .onActionEnd((event?: GestureEvent)=>{
          if(event && event.offsetY < -10){
            this.isShowPlay = true;
          }
        })
    )
  }
}