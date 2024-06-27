import router from '@ohos.router'
import { Constants } from '../../common/index';
import PaperItem from './PaperItem';

@Entry
@Component
struct PaperList {
  build() {
    Navigation() {
      Column() {
        Stack({ alignContent: Alignment.End }) {
          Image($r("app.media.ic_read"))
            .width(20)
            .aspectRatio(1)
        }
        .width('100%')
        .padding({ top: 20, bottom: 20, left: 15, right: 15 })

        List() {
          ForEach([1, 2, 3, 4, 5], () => {
            ListItem() {
              PaperItem()
                .onClick(async () => {
                  router.pushUrl({
                    url: Constants.PAGE_ANSWER_DETAIL
                  })
                })
            }
          })
        }
        .divider({ strokeWidth: 1, startMargin: 15, endMargin: 15, color: $r("app.color.gray_full_color") })
        .layoutWeight(1)
        .width('100%')
        .borderRadius(30)
        .backgroundColor($r("app.color.white"))
      }
      .height('100%')
    }.titleMode(NavigationTitleMode.Mini)
    .title("习题列表")
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
}