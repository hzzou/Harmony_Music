
export class BreakpointConstant{

  static readonly BREAKPOINT_SM: string = 'sm';

  static readonly BREAKPOINT_MD: string = 'md';

  static readonly BREAKPOINT_LG: string = 'lg';

  static readonly BREAKPOINT_VALUE: Array<string> = ['320vp', '600vp', '840vp'];

  static readonly COLUMN_SM: number = 4;

  static readonly COLUMN_MD: number = 8;

  static readonly COLUMN_LG: number = 12;

  static readonly COLUMN_LYRIC_LG: number = 7;

  static readonly GUTTER_X: number = 12;

  static readonly GUTTER_MUSIC_X: number = 24;

  static readonly SPAN_SM: number = 4;

  static readonly SPAN_MD: number = 6;

  static readonly SPAN_LG: number = 8;

  static readonly SPAN_LYRIC_LG: number = 5;

  static readonly OFFSET_MD: number = 1;

  static readonly OFFSET_LG: number = 2;

  static readonly CURRENT_BREAKPOINT: string = 'currentBreakpoint';

  static readonly FONT_SIZE_SM: number = 14;

  static readonly FONT_SIZE_MD: number = 16;

  static readonly FONT_SIZE_LG: number = 18;

  static readonly COVER_MARGIN_SM: number = 10;

  static readonly COVER_MARGIN_MD: number = 30;

  static readonly COVER_MARGIN_LG: number = 40;

  static readonly RANGE_SM: string = '(320vp <= width < 600vp)';

  static readonly RANGE_MD: string = '(600vp <= width < 840vp)';

  static readonly RANGE_LG: string = '(840vp <= width)';
}