// 此组件作用：用来单独呈现答题排行榜

@Extend(Text)
function setTextStyle() {
  .fontSize(13)
  .fontWeight(400)
  .fontColor('#6F7579')
}

@Component
export struct Top {
  // 排名：1,2,3调用

  @Builder
  TopListItem(index: number) {
    Stack({ alignContent: Alignment.Start }) {
      if (index === 0) {
        Image($r("app.media.ic_1"))
          .height(48)
      } else if (index == 1) {
        Image($r("app.media.ic_2"))
          .height(48)
      } else if(index === 2) {
        Image($r("app.media.ic_3"))
          .height(48)
      }else {
        Text((index + 1).toString())
          .margin({
            left: 18
          })
      }
      Row({ space: 8 }) {
        Image($r("app.media.waiter"))
          .height(40)
          .aspectRatio(1)
        Text("张小包")
          .fontSize(13)
          .fontWeight(400)
        Blank()
        Text('50')
      }
      .padding({ left: 65 })
      .width('100%')
    }
    .clip(false)
  }

  build() {
    Row() {
      Column() {
        Text('答题排行榜')
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontSize(16)
          .fontWeight(500)
          .padding({ top: 10, bottom: 12 })
        // 排行榜
        Column() {
          // 表头
          Row() {
            Text('排名')
              .setTextStyle()
              .width(60)
            Text('昵称')
              .setTextStyle()
              .layoutWeight(2)
            Text('答题成绩')
              .textAlign(TextAlign.End)
              .setTextStyle()
          }
          .padding({ bottom: 12, left: 9 })

          // 内容
          Scroll() {
            Column({ space: 10 }) {
              ForEach([1,2,3,4,5], (item: number, index: number) => {
                this.TopListItem(index)
              })
            }
          }
          .width('100%')
          .scrollBar(BarState.Off)
          .scrollable(ScrollDirection.Vertical)
        }
        .clip(true)
        .width('100%')
        .height(395)
        .borderRadius(10)
        .backgroundColor(Color.White)
        .padding({ top: 10, left: 7, right: 15, bottom: 50 })
        .shadow({ radius: 10, color: '#CAD4E8', offsetX: 10, offsetY: 10 })
      }
      .width('100%')
      .height('100%')
      .padding(16)

    }
    .width('100%')
    .height('100%')
  }
}