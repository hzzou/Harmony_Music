import { BreakpointConstant } from '@ohos/commonConstant';
import { mediaquery } from '@kit.ArkUI';


declare interface BreakPointTypeOption<T>{
  sm?: T;
  md?: T;
  lg?: T;
}


export class BreakpointType<T>{

  options: BreakPointTypeOption<T>;

  constructor(option: BreakPointTypeOption<T>) {
    this.options = option;
  }

  getValue(currentPoint: string): T {
    if(currentPoint === 'sm'){
      return this.options.sm as T;
    }
    else if(currentPoint === 'md'){
      return this.options.md as T;
    }
    else{
      return this.options.lg as T;
    }
  }
}

export class BreakpointSystem{
  private currentBreakpoint: string = BreakpointConstant.BREAKPOINT_SM;

  private smListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(BreakpointConstant.RANGE_SM);
  private mdListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(BreakpointConstant.RANGE_MD);
  private lgListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(BreakpointConstant.RANGE_LG);

  // 更新breakpoint
  private updateCurrentBreakpoint(breakpoint: string): void{
    if(this.currentBreakpoint !== breakpoint){
      this.currentBreakpoint = breakpoint;
      //
      AppStorage.setOrCreate<string>(BreakpointConstant.CURRENT_BREAKPOINT, this.currentBreakpoint);
    }
  }

  private isBreakpointSM = (mediaQueryResult: mediaquery.MediaQueryResult): void=>{
    if(mediaQueryResult.matches){
      this.updateCurrentBreakpoint(BreakpointConstant.BREAKPOINT_SM);
    }
  }

  private isBreakpointMD = (mediaQueryResult: mediaquery.MediaQueryResult): void=>{
    if(mediaQueryResult.matches){
      this.updateCurrentBreakpoint(BreakpointConstant.BREAKPOINT_MD);
    }
  }

  private isBreakpointLG = (mediaQueryResult: mediaquery.MediaQueryResult): void=>{
    if(mediaQueryResult.matches){
      this.updateCurrentBreakpoint(BreakpointConstant.BREAKPOINT_LG);
    }
  }

  public register(): void{
    this.smListener = mediaquery.matchMediaSync(BreakpointConstant.RANGE_SM);
    this.smListener.on('change', this.isBreakpointSM);

    this.mdListener = mediaquery.matchMediaSync(BreakpointConstant.RANGE_MD);
    this.mdListener.on('change', this.isBreakpointMD);

    this.lgListener = mediaquery.matchMediaSync(BreakpointConstant.RANGE_LG);
    this.lgListener.on('change', this.isBreakpointLG);
  }

  public unregister(): void{
    this.smListener.off('change', this.isBreakpointSM);
    this.mdListener.off('change', this.isBreakpointMD);
    this.lgListener.off('change', this.isBreakpointLG);
  }
}