
// 评论类型
export class Comment{

  nickname: string;

  content: string;

  time: string;

  icon: ResourceStr;

  commentList?: Comment[];

  constructor(nickname: string, content: string, time: string, icon: ResourceStr, commentList?: Comment[]) {
    this.nickname = nickname;
    this.content = content;
    this.time = time;
    this.icon = icon;
    this.commentList = this.commentList;
  }
}