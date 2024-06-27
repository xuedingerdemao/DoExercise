
@Preview
@Component
struct PaperItem {
  build() {
    Column({ space: 20 }) {
      Text("<HarmonyOS第一课>运行Hello World")
        .alignSelf(ItemAlign.Start)
      Row() {
        this.tagBuilder("简单")
        Blank()
        Row() {
          Text('暂未做题').fontSize(13)
            .fontColor($r("app.color.gray_color"))
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 20, left: 15, right: 15, bottom: 20 })
  }

  @Builder
  tagBuilder(title: string) {
    Text(title)
      .fontColor($r("app.color.right_full_color"))
      .backgroundColor($r("app.color.right_half_color"))
      .fontSize(12)
      .padding({ top: 3, left: 8, right: 8, bottom: 3 })
  }
}

export default PaperItem