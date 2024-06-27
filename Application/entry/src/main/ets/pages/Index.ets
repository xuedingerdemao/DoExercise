import { Home } from './Home/Home';
import { UserCenter } from './Account/UserCenter';
import { ClassifyList } from './Classify/ClassifyList';
import { TabBarClass } from '../models';

@Entry
@Component
struct Index {
  // Tab设置相关的变量
  @State
  currentIndex: number = 0

  @State
  tabList: TabBarClass[] = [
    {
      name: 'home',
      title: '首页',
      icon: $r('app.media.ic_home'),
      activeIcon: $r("app.media.ic_home_active")
    },
    {
      name: 'practice',
      title: '练习',
      icon: $r('app.media.ic_practice'),
      activeIcon: $r("app.media.ic_practice_active")
    },
    {
      name: 'mine',
      title: '我的',
      icon: $r('app.media.ic_mine'),
      activeIcon: $r("app.media.ic_mine_active")
    }
  ]
  @Builder
  getTabBuilder(item: TabBarClass, index: number) {
    Column() {
      Image(this.currentIndex === index ? item.activeIcon : item.icon )
        .size({ width: 32, height: 36 })
      Text(item.title)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? $r("app.color.text_active_color") : $r("app.color.text_main_color"))
    }
    .width('100%')
    .height(56)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: $$this.currentIndex  }) {
        ForEach(this.tabList, (item: TabBarClass, index: number) => {
          TabContent() {
            if(item.name === 'home') {
              Home()
            }
            else if(item.name === 'practice') {
              ClassifyList()
            }
            else if(item.name === "mine") {
              UserCenter()
            }
          }.tabBar(this.getTabBuilder(item, index))
        })

      }
      .animationDuration(300)
    }
    .padding({
      top: JSON.parse(AppStorage.get("topHeight")),
      bottom:  JSON.parse(AppStorage.get("bottomHeight"))
    })
    .linearGradient({
      colors: [
        ['#ccdffc', 0],
        [$r("app.color.gray_light_color"), 1]
      ]
    })

  }
}