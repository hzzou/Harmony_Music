import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon'
import { SongItem } from '@ohos/mediaCommon';
import { LyricScrollEffect } from '../constants/LyricConstant';
import { PlayerConstant } from '../constants/PlayerConstant';

@Component
export struct LyricsComponent{

  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstant.BREAKPOINT_SM;
  @StorageProp('selectIndex') @Watch('getLyricEntryList') selectIndex: number = 0;

  @StorageLink('progress') time: number = 0;
  @StorageLink('isFoldFull') isFoldFull: boolean = false;
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageLink('isPlay') isPlay: boolean = false;

  @State progress: number = 0.01;
  @State progressText: string = '';
  @State lyricScrollEffect: LyricScrollEffect = LyricScrollEffect.Line;

  @State msg: string = "当前歌曲没有歌词";

  aboutToAppear(): void {
    this.getLyricEntryList();
  }

  getLyricEntryList(){

  }

  build() {
    Column(){
      Text(this.msg)
        .fontColor(Color.White)
        .fontSize($r('app.float.title_font_lg'))
        .fontFamily(PlayerConstant.FONT_FAMILY_BOLD)
    }
    .justifyContent(FlexAlign.Center)
    .height(StyleConstant.FULL_HEIGHT)
    .width(StyleConstant.FULL_WIDTH)
  }
}