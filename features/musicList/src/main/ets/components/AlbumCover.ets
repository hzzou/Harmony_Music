import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon';
import { AlbumComponent } from './AlbumComponent';

@Component
export struct AlbumCover{
  @Link currentBreakpoint: string;

  build() {
    if(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM){
      AlbumComponent({currentBreakpoint: this.currentBreakpoint})
    }
    else{
      AlbumComponent({currentBreakpoint: this.currentBreakpoint})
        .height(StyleConstant.FULL_HEIGHT)
    }
  }
}