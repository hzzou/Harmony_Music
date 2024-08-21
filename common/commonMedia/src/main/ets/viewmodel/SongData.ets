
export class SongItem{

  // primary key
  id: number = 0;

  // Music name
  title: string = '';

  // author name
  singer:  string = '';

  // logo info
  mark: Resource = $r('app.string.page_show');

  // avatar info
  label: Resource = $r('app.string.page_show');

  // music file path info
  src: string = '';

  // index of the current music list
  index: number = 0;

  // lyric file path info
  lyric: string = ''
}