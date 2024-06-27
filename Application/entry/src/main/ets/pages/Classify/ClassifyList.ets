import { ClassifyItem } from './ClassifyItem' //练习列表项组件
import router from '@ohos.router'
import { Constants } from '../../common'

@Entry
@Component
export struct ClassifyList {
  build() {
    Row() {
      List({ space: 15 }) {
        ForEach([1,2,3,4], () => {
          ClassifyItem()
            .onClick(() => {
              router.pushUrl({ url: Constants.PAGE_PAPER_LIST })
            })
        })
      }
      .width('100%')
      .height('100%')
      .padding(15)
    }
    .height('100%')
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