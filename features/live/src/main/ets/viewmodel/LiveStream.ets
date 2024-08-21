

export class LiveStream{

  title: Resource;

  liveIntroduction: Resource;

  liveBackground: Resource;

  constructor(title:Resource, liveIntroduction: Resource, liveBackground: Resource) {
    this.title = title;
    this.liveIntroduction = liveIntroduction;
    this.liveBackground = liveBackground;
  }
}