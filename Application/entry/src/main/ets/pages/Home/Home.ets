import router from '@ohos.router'
import { Constants } from '../../common/index'
import { Top } from './Top'

@Entry
@Component
export struct Home {

  build() {
    Row() {
      Column() {
        // 图片
        Image($r("app.media.banner"))
          .width('90%')
        // 导航区
        Row({ space: 20 }) {
          Row({ space: 40 }) {
            Column({ space: 3 }) {
              Text('在线答题')
                .fontSize(13)
              Text('100人参与')
                .width(74)
                .textAlign(TextAlign.Center)
                .fontSize(11)
                .fontColor('#979797')
            }
            .height(38)

            Image($r('app.media.ic_tests'))
              .height(38)
              .aspectRatio(1)
          }
          .height(68)
          .width('45%')
          .backgroundColor(Color.White)
          .borderRadius(8)
          .onClick(() => {
            router.pushUrl({ url: Constants.PAGE_CLASSIFY_LIST })
          })

          Row() {
            Row({ space: 40 }) {
              Column({ space: 3 }) {
                Text('错题集合')
                  .fontSize(13)
                Text('10道错题')
                  .width(64)
                  .textAlign(TextAlign.Center)
                  .fontSize(11)
                  .fontColor('#979797')
              }
              .height(38)
              Image($r('app.media.ic_problems'))
                .width(38)
                .aspectRatio(1)
            }
          }
          .height(68)
          .width('45%')
          .backgroundColor(Color.White)
          .borderRadius(8)
        }
        .height(58)
        .margin({ top: 0, bottom: 10, left: 16, right: 16 })

        // 答题排行榜
        Top()
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}