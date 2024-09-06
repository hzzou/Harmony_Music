
export const enum LyricScrollEffect{
  Line,
  LetterGradient,
  LetterScaleGradient,
  LetterStar
}

export const enum LyricTopPosition{
  Top,
  Middle
}

export class LyricFile{
  static readonly KRC: string = '.krc';
  static readonly LRC: string = '.lrc';
}

export class Rectangle{
  left: number;
  right: number;
  top: number;
  bottom: number;

  constructor(left: number, right: number, top: number, bottom: number) {
    this.left = left;
    this.right = right;
    this.top = top;
    this.bottom = bottom;
  }

  public isIn(x: number, y: number){
    return x >= this.left && x <= this.right && y >= this.top && y <= this.bottom;
  }

  toString(){
    return `[Rectang] = ${this.left}, ${this.right}, ${this.top}, ${this.bottom}`;
  }
}