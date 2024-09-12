import { BreakpointConstant, StyleConstant } from '@ohos/constantCommon';
import { Header } from '../components/Header';
import { ItemComponent } from '../components/ItemComponent';
import { MusicInfo } from '../components/MusicInfo';
import { CommonConstant } from '../constants/CommonConstant';
import { Comment } from '../viewmodel/Comment';
import CommentData from '../viewmodel/CommentData';

@Entry
@Component
struct Index {
  @State message: string = '这是评论';
  @State currentBreakpoint: string = BreakpointConstant.CURRENT_BREAKPOINT;
  @State wonderfulComment: Comment[] = CommentData.getWonderfulData();  // 精彩评论
  @State newComment: Comment[] = CommentData.getNewComment(); // 最新评论

  @Builder
  CommentTitle(title: ResourceStr){
    Row(){
      Text(title)
        .fontSize($r('app.float.comment_title_size'))
        .fontColor($r('app.color.comment_title_color'))
        .lineHeight($r('app.float.title_line_height'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.title_margin_top'),
          bottom: $r('app.float.title_margin_bottom'),
          left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
          $r('app.float.margin_left_sm') : $r('app.float.margin_left'),
          right: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
          $r('app.float.margin_right_sm') : $r('app.float.margin_right')
        })
    }
    .justifyContent(FlexAlign.Start)
    .width(StyleConstant.FULL_WIDTH)
  }

  build() {
    GridRow({
      breakpoints: {value: BreakpointConstant.BREAKPOINT_VALUE, reference: BreakpointsReference.WindowSize},
      columns: {
        sm: BreakpointConstant.COLUMN_SM,
        md: BreakpointConstant.COLUMN_MD,
        lg: BreakpointConstant.COLUMN_LG,
      },
      // GridCol组件水平方向的间距
      gutter: {x: BreakpointConstant.GUTTER_X}
    }){
      GridCol({
        span:{
          sm: BreakpointConstant.COLUMN_SM,
          md: BreakpointConstant.COLUMN_MD,
          lg: BreakpointConstant.COLUMN_LG,
        }
      }){
        Column(){
          Header()
            .margin({
              left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
                $r('app.float.margin_left_sm') : $r('app.float.margin_left'),
              right: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
                $r('app.float.margin_right_sm') : $r('app.float.margin_right')
            })

          Row(){
            MusicInfo()
          }
          .backgroundColor($r('app.color.music_info_color'))
          .width(StyleConstant.FULL_WIDTH)
          .padding({
            left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
            $r('app.float.margin_left_sm') : $r('app.float.margin_left'),
            right: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
            $r('app.float.margin_right_sm') : $r('app.float.margin_right')
          })

          Column(){
            // 精彩评论
            this.CommentTitle($r('app.string.wonderful_comment'))

            List(){
              ForEach(this.wonderfulComment, (comment: Comment, index?: number)=>{
                if(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ||
                this.currentBreakpoint === BreakpointConstant.BREAKPOINT_MD){
                  if(index && index < CommonConstant.LIST_COUNT){
                    ListItem(){
                      ItemComponent({item: comment})
                        .margin({
                          left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
                            0 : $r('app.float.margin_left_list'),
                          right: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
                            0 : $r('app.float.margin_right_list')
                        })
                    }
                    .width(StyleConstant.FULL_WIDTH)
                    .padding({bottom: $r('app.float.padding_bottom')})
                  }
                }
                else{
                  ListItem(){
                    ItemComponent({item: comment})
                      .margin({
                        left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
                          0 : $r('app.float.margin_left_list'),
                        right: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
                          0 : $r('app.float.margin_right_list')
                      })
                  }
                  .width(StyleConstant.FULL_WIDTH)
                  .padding({bottom: $r('app.float.padding_bottom')})
                }
              }, (item: Comment)=>JSON.stringify(item))
            }
            .lanes(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_LG ? 2 : 1) // 列数 大屏时两列
            .scrollBar(BarState.Off)
            .divider({
              color: $r('app.color.list_divider'),
              strokeWidth: $r('app.float.stroke_width'),
              startMargin: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
              $r('app.float.start_margin') : $r('app.float.start_margin_lg'),
              endMargin: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ? 0 :
              $r('app.float.divider_margin_left')
            })
            .margin({
              left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
              $r('app.float.margin_left_sm') : $r('app.float.margin_left_list'),
              right: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
              $r('app.float.margin_right_sm') : $r('app.float.margin_right_list')
            })

            // 最新评论
            this.CommentTitle($r('app.string.new_comment'))

            List(){
              ForEach(this.newComment, (comment: Comment)=>{
                ListItem(){
                  ItemComponent({item: comment})
                    .margin({
                      left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
                        0 : $r('app.float.margin_left_list'),
                      right: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
                        0 : $r('app.float.margin_right_list')
                    })
                }
                .width(StyleConstant.FULL_WIDTH)
                .padding({bottom: $r('app.float.padding_bottom')})
              }, (item: Comment)=>JSON.stringify(item))
            }
            .layoutWeight(1)
            .lanes(this.currentBreakpoint === BreakpointConstant.BREAKPOINT_LG ? 2 : 1) // 列数
            .scrollBar(BarState.Off)
            .divider({
              color: $r('app.color.list_divider'),
              strokeWidth: $r('app.float.stroke_width'),
              startMargin: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
              $r('app.float.start_margin') : $r('app.float.start_margin_lg'),
              endMargin: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ? 0 :
              $r('app.float.divider_margin_left')
            })
            .margin({
              left: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
              $r('app.float.margin_left_sm') : $r('app.float.margin_left_list'),
              right: this.currentBreakpoint === BreakpointConstant.BREAKPOINT_SM ?
              $r('app.float.margin_right_sm') : $r('app.float.margin_right_list')
            })
          }
        }
        .height(StyleConstant.FULL_HEIGHT)
      }
    }
      .backgroundColor(Color.White)
      .onBreakpointChange((breakpoint)=>{
        this.currentBreakpoint = breakpoint;
      })
  }
}