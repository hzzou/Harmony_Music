import { LiveStream } from './LiveStream';

class StreamModel{

  getStreamList(): LiveStream[]{
    let streamList: LiveStream[] = [
      new LiveStream($r('app.string.live_one'), $r('app.string.live_one_introduction'), $r('app.media.ic_snow_mountain')),
      new LiveStream($r('app.string.live_two'), $r('app.string.live_two_introduction'), $r('app.media.ic_meal')),
      new LiveStream($r('app.string.live_three'), $r('app.string.live_three_introduction'), $r('app.media.ic_insects_world'))
    ];

    return streamList;
  }
}

export default new StreamModel();