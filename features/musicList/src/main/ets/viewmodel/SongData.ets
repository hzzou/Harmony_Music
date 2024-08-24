import { router } from '@kit.ArkUI';
import { RouterUrlConstant } from '@ohos/constantCommon';

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