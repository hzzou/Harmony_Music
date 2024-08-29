import { router } from '@kit.ArkUI';
import { RouterUrlConstant } from '@ohos/constantCommon';
import { SongItem } from '@ohos/mediaCommon';

export const songList: SongItem[] = [
  {id: 1, title: '大海', singer: '张雨生', mark: $r('app.media.ic_sq'), label: $r('app.media.ic_avatar1'), src: 'song/大海.mp3', index: 0, lyric: ''},
  {id: 2, title: '等一分钟', singer: '徐誉滕', mark: $r('app.media.ic_sq'), label: $r('app.media.ic_avatar2'), src: 'song/等一分钟.mp3', index: 1, lyric: ''},
  {id: 3, title: 'Dream Ite Possible', singer: 'Hzlzh', mark: $r('app.media.ic_vip'), label: $r('app.media.ic_dream'), src: 'song/Dream It Possible.flac', index: 2, lyric: 'lrcfiles/DreamItPossible.lrc'}
];

export class OptionItem{
  image: Resource = $r('app.media.ic_collect');
  text?: Resource;
  action?: () => void;
}

export const optionList: OptionItem[] = [
  // 不用new OptionItem是因为OptionItem没有构造函数
  {image: $r('app.media.ic_collect'), text: $r('app.string.collect'), action: ()=>{ console.log('收藏')}},
  {image: $r('app.media.ic_download'), text: $r('app.string.download'), action: ()=> {console.log('下载')}},
  {image: $r('app.media.ic_comments'), text: $r('app.string.comment'), action: ()=>{
    console.log('评论')
    router.pushUrl({
      url: RouterUrlConstant.MUSIC_COMMENT
    }, router.RouterMode.Single)
  }},
  {image: $r('app.media.ic_share'), text: $r('app.string.share'), action: ()=>{ console.log('分享')}}
]