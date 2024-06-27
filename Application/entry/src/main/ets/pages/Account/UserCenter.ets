import { Constants } from '../../common'
import router from '@ohos.router';
import picker from '@ohos.file.picker'
import cloud, { AuthUser } from '@hw-agconnect/cloud';
import { AuthDefaultUser } from '@hw-agconnect/cloud/src/main/ets/auth/user/AuthDefaultUser';
import { UserSetting } from '../../utils/setting';
import { promptAction } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import { UserInfo } from '../../models';
import { UserService } from '../../services';

interface ICardItem {
  leftTitle: string
  rightValue: string,
  showArrow?: boolean,
  onClick?: () => void
}

@Entry
@Component
export struct UserCenter {
  @State
  avatar: string = ""
  @State
  displayName: string = "" // 真实昵称
  @State
  copyDisplayName: string = "" // 双向绑定弹层的字段
  @State
  showSheet: boolean = false
  @StorageProp(Constants.USER_AUTH_KEY)
  currentUser: AuthUser = new AuthDefaultUser()
  @State
  lastLoginTime: string = ""
  @State
  user: UserInfo = new UserInfo()

  aboutToAppear(): void {
    this.getLastLoginTime()
    this.getUserProfile()
    this.getOwnUserInfo()
  }

  async getOwnUserInfo() {
    const result = await UserService.getUserInfoUserId(this.currentUser.getUid())
    if (result && result.length) {
      this.user = result[0]
    }
  }

  async getUserProfile() {
    this.displayName = this.currentUser.getDisplayName() // 获取昵称
    this.avatar = this.currentUser.getPhotoUrl() // 获取头像
  }

  async getLastLoginTime() {
    this.lastLoginTime = this.transDate(parseInt((await this.currentUser.getUserExtra()).getLastSignInTime()))
  }

  transDate(timeStamp: number) {
    const date = new Date(timeStamp)
    return date.toLocaleDateString() + " " + date.toLocaleTimeString()
  }

  async updateDisplayName() {
    if (this.copyDisplayName) {
      try {
        // 云认证更新
        await this.currentUser.updateProfile({
          displayName: this.copyDisplayName,
          photoUrl: this.avatar.trim() ||
            "https://q1.itc.cn/q_70/images03/20240304/b00ebfdfb3ba40b989185a5ae90496e7.jpeg" // 头像如果为空是更新不上去的
        })
        this.user.avatar = this.avatar
        this.user.nick_name = this.copyDisplayName
        this.user.user_id = this.currentUser.getUid()
        // 更新云数据库
        await UserService.updateUserInfo(this.user) // 有id就是更新没有id就是新增
        this.getOwnUserInfo() // 重新拉一下
        // 重新拉取一下数据库的用户信息
        this.copyDisplayName = "" // 清空输入的值
        this.getUserProfile() // 重新获取用户的资料
        promptAction.showToast({ message: '更新成功' })
        this.showSheet = false // 关闭弹层
      } catch (error) {
        promptAction.showToast({ message: error.message })
      }
    }

  }

  @Builder
  getCardItem(item: ICardItem) {
    Row() {
      Text(item.leftTitle)
        .fontSize(14)
        .fontColor($r("app.color.text_second_color"))
        .height(44)

      Row({ space: 6 }) {
        if (item.showArrow) {
          Image($r('app.media.ic_right'))
            .width(16)
            .height(16)
            .fillColor($r("app.color.gray_color"))
        }
        if (item.rightValue) {
          Text(item.rightValue)
            .fontSize(14)
            .fontColor($r("app.color.text_second_color"))
        }
      }.height(44)
    }
    .onClick(() => {
      item.onClick && item.onClick()
    })
    .padding({
      left: 20,
      right: 20
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .backgroundColor($r("app.color.white"))
  }

  @Builder
  getShowResult(item: ICardItem) {
    Column() {
      Text(item.leftTitle)
        .fontSize(10)
        .fontColor($r("app.color.gray_color"))
        .margin({ top: 10 })
      Text(item.rightValue)
        .fontWeight(400)
        .padding({ top: 5 })
    }
  }

  @Builder
  getSheetContent() {
    Column({ space: 20 }) {
      TextInput({
        text: $$this.copyDisplayName,
        placeholder: '请输入您的昵称'
      })
        .width('100%')
      Button("修改昵称")
        .backgroundColor($r("app.color.blue_light_color"))
        .width("100%")
        .onClick(() => {
          // 将填写的昵称更新到云端 再去更新当前的页面的昵称
          this.updateDisplayName()
        })

    }
    .height('100%')
    .padding(20)
  }

  async selectImg() {
    let selectPhoto = new picker.PhotoViewPicker()
    const result = await selectPhoto.select({
      maxSelectNumber: 1,
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE
    })
    if (result.photoUris.length) {
      // 上传图片到agc云存储- agc云存储当前免费用户 只能有一个项目使用开启云存储
      const fileName = util.generateRandomUUID() + ".jpg"
      await cloud.storage().upload({
        localPath: result.photoUris[0], // 本地的文件地址
        cloudPath: fileName
      })
      // 上传成功并不能拿到上传成功的地址
      this.avatar = await cloud.storage().getDownloadURL(fileName) // 拿到真实云地址 赋值头像
      this.copyDisplayName = this.displayName // 目的是通过下面的更新方法有检查用户名的逻辑
      this.updateDisplayName() // 更新用户资料
    }
  }

  // 登出方法
  async logout() {
    await cloud.auth().signOut()
    await UserSetting.setUserAuth("")
    AppStorage.set(Constants.USER_AUTH_KEY, new AuthDefaultUser())
    // 跳回login页面
    router.replaceUrl({
      url: Constants.PAGE_LOGIN
    })
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        // 用户昵称和头像部分
        Row() {
          Row() {
            // 头像+昵称
            Column() {
              Image(this.avatar || $r('app.media.user_dark'))
                .width(64)
                .aspectRatio(1)
                .borderRadius(32)
                .interpolation(ImageInterpolation.High)//减轻低清晰度图片在放大显示时出现的锯齿问题
                .onClick(() => {
                  this.selectImg()
                })
              Text(this.displayName || "未命名")
                .fontSize(16)
                .fontWeight(400)
                .fontColor($r("app.color.text_main_color"))
                .margin({ top: 12 })
                .onClick(() => {
                  this.showSheet = true
                })

            }
            .translate({
              y: -32
            })

            Row({ space: 35 }) {
              this.getShowResult({ leftTitle: '已刷题数(道)', rightValue: '40' })
              this.getShowResult({ leftTitle: '错题数量(道)', rightValue: '40' })
            }
            .justifyContent(FlexAlign.End)
            .layoutWeight(1)
          }.height(80)
          .backgroundColor($r("app.color.white"))
          .borderRadius(8)
          .padding({
            left: 20,
            right: 20
          })
        }
        .width('100%')
        .padding({
          left: 20,
          right: 20
        })
        .margin({
          top: 100
        })

        // 手机号码，上次登录时间部分
        Column() {
          Column() {
            this.getCardItem({ leftTitle: '手机号码', rightValue: this.currentUser.getPhone() })
            this.getCardItem({ leftTitle: '上次登录时间', rightValue: this.lastLoginTime })
          }
          .borderRadius(8)
          .clip(true)
        }
        .width("100%")
        .padding({
          left: 20,
          right: 20
        })

        // 手机号码，上次登录时间部分
        Column() {
          Column() {
            this.getCardItem({
              leftTitle: '登出',
              rightValue: '',
              showArrow: true,
              onClick: () => {
                this.logout()
              }
            })
          }
          .clip(true)
          .borderRadius(8)
        }
        .width("100%")
        .padding({
          left: 20,
          right: 20
        })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
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
    .bindSheet($$this.showSheet, this.getSheetContent, {
      height: '40%'
    })
  }
}