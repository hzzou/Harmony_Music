

export default class ViewItem{

  title: ResourceStr;

  description: ResourceStr;

  button: ResourceStr;

  icon: Resource;

  url: string;

  constructor(title: ResourceStr, description: ResourceStr, button: ResourceStr, icon: Resource, url: string) {
    this.title = title;
    this.description = description;
    this.button = button;
    this.icon = icon;
    this.url = url;
  }
}