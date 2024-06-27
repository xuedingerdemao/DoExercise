import router from '@ohos.router';
import { Constants } from '../../common';

@Entry
@Component
struct UserAnswerResult {
  getOptionColor(isRight: boolean): ResourceColor {
    if (isRight) {
      return $r("app.color.right_full_color")
    }  else {
      return $r("app.color.error_full_color")
    }
  }
  build() {
    Navigation() {
      Column() {
        Scroll() {
          Column() {
            // 得分
            Column() {
              Stack({ alignContent: Alignment.Bottom }) {
                Gauge({ value: 50, min: 0, max: 100 })
                  .startAngle(-90)
                  .endAngle(90)
                  .colors([[$r("app.color.blue_light_color"), 30], [$r("app.color.gray_full_color"), 70]])
                  .strokeWidth(20)
                  .width(200)
                Column() {
                  this.smallText('得分')
                  Text("50")
                    .fontSize(35)
                    .fontWeight(900)
                  this.smallText('/100')
                  Row() {
                    this.smallText('练习类型:')
                    Text("HarmonyOS习题")
                      .fontSize(12)
                      .fontColor(Color.Gray)
                  }
                  .width('100%')
                  .padding({ top: 50, bottom: 10 })
                  .justifyContent(FlexAlign.SpaceBetween)

                  Row() {
                    this.smallText('交卷时间:')
                    Text(new Date().toLocaleString())
                      .fontSize(12)
                      .fontColor(Color.Gray)
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                }
              }
            }
            .padding(20)
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(10)
            .margin({
              top: 20
            })

            // 考试情况
            Column() {
              Text('考试情况')
                .width('100%')
                .fontWeight(600)
                .padding({ top: 20, bottom: 10 })
              Row() {
                this.examItem({ title: '总题数', num: "20", unit: "题" ,fontColor: $r("app.color.blue_light_color")})
                this.examItem({ title: '答对', num: "10", unit: '题', fontColor: $r("app.color.right_full_color")  }  )
                this.examItem({ title: '答错', num: "10", unit: '题', fontColor: $r("app.color.error_full_color") })
                this.examItem({ title: '总用时', num: "40", unit: 'min', fontColor: $r("app.color.error_full_color") } )
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .backgroundColor(Color.White)
              .padding(20)
              .borderRadius(10)
            }


            // 答题卡
            Column() {
              Text('答题卡')
                .width('100%')
                .fontWeight(600)
                .padding({ top: 30, bottom: 10 })
              Column() {
                Row({ space: 15 }) {
                  Text('题目')
                    .layoutWeight(1)
                    .fontSize(14)
                  Row({ space: 8 }) {
                    Text()
                      .size({ width: 12, height: 12 })
                      .borderRadius(8)
                      .backgroundColor($r("app.color.gray_full_color"))
                    Text('未答')
                      .fontSize(12)
                  }

                  Row({ space: 8 }) {
                    Text()
                      .size({ width: 12, height: 12 })
                      .borderRadius(8)
                      .backgroundColor($r("app.color.right_full_color"))
                    Text('答对')
                      .fontSize(12)
                  }

                  Row({ space: 8 }) {
                    Text()
                      .size({ width: 12, height: 12 })
                      .borderRadius(8)
                      .backgroundColor($r("app.color.error_full_color"))
                    Text('答错')
                      .fontSize(12)
                  }
                }
                .width('100%')
                .padding(15)

                // 答题卡选项
                Flex({ wrap: FlexWrap.Wrap }) {
                  ForEach([1,2,3,4,5], (item: number, index: number) => {
                    Row() {
                      Text((index + 1).toString())
                        .textAlign(TextAlign.Center)
                        .fontColor(Color.White)
                        .size({ width: 40, height: 40 })
                        .borderRadius(20)
                        .backgroundColor(this.getOptionColor(true))
                    }
                    .justifyContent(FlexAlign.Center)
                    .width('20%')
                    .aspectRatio(1)
                    .onClick(() => {
                      router.pushUrl({
                        url: Constants.PAGE_ANSWER_DETAIL
                      })
                    })
                  })
                }
              }
              .backgroundColor(Color.White)
              .borderRadius(10)
            }
          }
          .padding({ left: 15, right: 15, bottom: 50 })
          .width('100%')

        }
        .layoutWeight(1)
        Row() {
          Button("重新刷题")
            .width('60%')
            .onClick(async () => {
              router.replaceUrl({
                url: Constants.PAGE_ANSWER_DETAIL
              })
            })
            .backgroundColor($r("app.color.send_code_color"))
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height(70)
        .backgroundColor($r("app.color.white"))
      }
      .height('100%')
    }
    .titleMode(NavigationTitleMode.Mini)
    .title("答题结果")
    .padding({
      top: JSON.parse(AppStorage.get("topHeight")),
      bottom: JSON.parse(AppStorage.get("bottomHeight"))
    })
    .linearGradient({
      colors: [
        ['#ccdffc', 0],
        [$r("app.color.gray_light_color"), 1]
      ]
    })
  }
  @Builder
  examItem(item: AnswerResult) {
    Column({ space: 15 }) {
      Text(item.title)
        .fontSize(13)
      Text() {
        Span(item.num.toString())
          .fontSize(16)
          .fontColor(item.fontColor)
        Span(item.unit)
          .fontColor(item.fontColor)
          .fontSize(12)
      }
    }
  }

  @Builder
  smallText(text: string, fontSize: number = 12) {
    Text(text)
      .fontSize(fontSize)
      .fontColor(Color.Gray)
  }
}

interface AnswerResult {
  title: string
  num: string
  unit: string
  fontColor: ResourceColor
}