@Preview
@Component
export default struct AnswerItem {
  build() {
    Stack() {
      if(false) {
        Row()
          .width('100%')
          .height('100%')
          .linearGradient({ colors: [['#00bffa', 0], ['#0074f4', 1]] })
          .borderRadius(10)

      }
      Row() {
        Text() {
          Span("A.")
          Span("ArkTS组件中的属性可以使用主轴对齐方式")
        }
        .fontColor($r('app.color.black'))
      }
      .width('100%')
      .height('100%')
      .padding(15)
    }
    .width('100%')
    .height(50)
    .backgroundColor($r('app.color.option_item_color'))
    .borderRadius(10)
  }
}