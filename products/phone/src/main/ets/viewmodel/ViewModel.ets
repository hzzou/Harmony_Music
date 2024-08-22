import ViewItem from './ViewItem';

class ViewModel{

  getViewList(): ViewItem[]{
    let list: ViewItem[] = [
      new ViewItem($r('app.string.music_title'), $r('app.string.music_description'), $r('app.string.button_music'), $r('app.media.ic_music'), '@bundle:com.hzlzh.music/musicList/ets/pages/Index'),
      new ViewItem($r('app.string.live_title'), $r('app.string.live_description'), $r('app.string.button_live'), $r('app.media.ic_live'), '@bundle:com.hzlzh.music/live/ets/pages/Home/Index')
    ];

    return list;
  }
}

export default new ViewModel();