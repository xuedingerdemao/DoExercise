import AnswerItem from './AnswerItem'
import router from '@ohos.router'
import { Constants } from '../../common'

@Entry
@Component
struct AnswerDetail {
  @State
  showSubmit: boolean = true // 控制交卷按钮
  @State
  currentIndex: number = 0 // 当前在做题目
  @State
  isReadOnly: boolean = false // 是否只读状态

  // 交卷
  async submitPaper() {
    router.replaceUrl({
      url: Constants.PAGE_ANSWER_RESULT,
    })
  }


  build() {
    Navigation() {
      Column() {
        Column() {
          // 进度条
          Row() {
            Progress({ value: (this.currentIndex + 1), total: 10 })
              .margin({ right: 10 })
              .layoutWeight(1)
            Text() {
              Span((this.currentIndex + 1).toString())
                .fontWeight(900)
                .fontColor(Color.Gray)
              Span(`/5`)
                .fontWeight(900)
                .fontColor('#c4c4c4')
            }
          }
          .height(50)
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)

            // 题目类型
            Row() {
              Text("简单")
                .fontSize(12)
                .fontColor(Color.Gray)
                .padding({ top: 2, bottom: 2, left: 10, right: 10 })
                .backgroundColor(Color.White)
            }
            .width('100%')

            // 题目内容
            Column({ space: 16 }) {
              Text(`${this.currentIndex + 1}. ArkUI组件中的Column的作用是什么`)
                .width('100%')
              Column({ space: 8 }) {
                ForEach([1,2,3,4], (item: number) => {
                  AnswerItem()
                })
              }
            }
            .width('100%')
            .margin({ top: 10 })


          if (this.isReadOnly) {
            Column({ space: 10 }) {
              // 显示答案
              Text("答案")
                .fontColor($r("app.color.text_main_color"))
                .width('100%')

              Row({ space: 20 }) {
                Row({ space: 2 }) {
                  Text("正确答案: ")
                    .fontColor($r("app.color.text_main_color"))
                  Text("A")
                    .fontColor($r("app.color.right_full_color"))
                }

                Row({ space: 2 }) {
                  Text("您的答案: ")
                    .fontColor($r("app.color.text_main_color"))
                  Text("B")
                    .fontColor($r("app.color.error_full_color"))
                }
              }
              .width('100%')

              Text("解析: ")
                .fontColor($r("app.color.text_main_color"))
                .width('100%')
              Row({ space: 2 }) {
                Text("B")
                  .fontColor($r("app.color.right_full_color"))
              }
              .width('100%')
            }
            .width('100%')
            .padding(10)
            .margin({
              top: 50
            })
          }

          Blank()
          // 交卷按钮
          Row() {
            Row() {
              Image($r('app.media.ic_left'))
                .fillColor($r("app.color.text_main_color"))
                .width(18)
                .aspectRatio(1)
                .margin({ right: 15 })
              Text('上一题')
                .fontColor($r("app.color.text_main_color"))

            }
            .layoutWeight(1)



            Row() {
              Text('下一题')
                .fontColor($r("app.color.text_main_color"))
                .margin({ right: 15 })
              Image($r('app.media.ic_right'))
                .fillColor($r("app.color.text_main_color"))
                .width(18)
                .aspectRatio(1)
            }
            .justifyContent(FlexAlign.End)
            .layoutWeight(1)


          }
          .height(50)
          .width('100%')

          if (this.showSubmit && !this.isReadOnly) {
            Row() {
              Button("交卷查看结果", {
                type: ButtonType.Normal
              })
                .borderRadius(48)
                .width(200)
                .height(48)
                .backgroundColor($r("app.color.send_code_color"))
                .onClick(() => {
                  this.submitPaper()
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({
              top: 20
            })
          }
        }
        .padding({ left: 15, right: 15 })
        .backgroundColor($r("app.color.white"))
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r("app.color.white"))
    }
    .titleMode(NavigationTitleMode.Mini)
    .title("在线模拟")
    .padding({
      top: JSON.parse(AppStorage.get("topHeight") ),
      bottom: JSON.parse(AppStorage.get("bottomHeight"))
    })
    .linearGradient({
      colors: [
        ['#ccdffc', 0],
        [$r("app.color.gray_light_color"), 1]
      ]
    })
  }
}