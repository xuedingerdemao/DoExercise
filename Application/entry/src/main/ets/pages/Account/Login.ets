import { Constants } from '../../common/index';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import cloud, { AuthUser, VerifyCodeAction } from '@hw-agconnect/cloud'
import { UserSetting } from '../../utils/setting';

@Extend(TextInput)
function commonStyle() {
  .width(280)
  .height(40)
  .backgroundColor('#F9F9F9')
  .placeholderColor($r("app.color.gray_color"))
  .fontColor($r("app.color.gray_color"))
}

@Extend(Button)
function commonButtonStyle() {
  .width(280)
  .height(48)
}

@Entry
@Component
struct Login {
  @State
  timeCount: number = 60 // 秒
  timer: number = -1 // 计时器的标记
  @State
  mobile: string = "15707507292"
  @State
  code: string = ""

  // 检查手机号合法
  checkMobile() {
    return !!(this.mobile && new RegExp('^1[3-9]\\d{9}$').test(this.mobile))
  }

  // 检查验证码合法性
  checkCode() {
    return !!(this.code && new RegExp('^\\d{6}$').test(this.code))
  }

  async login() {
    try {
      // 实现云登录
      const result = await cloud.auth().signIn({
        credentialInfo: {
          kind: "phone",
          countryCode: '86',
          phoneNumber: this.mobile,
          verifyCode: this.code
        }
      })
      // 说明此时登录成功
      // AlertDialog.show({ message: JSON.stringify(result) })
      // 拿到用户的信息
      const currentUser = result.getUser()
      UserSetting.setUserAuth(JSON.stringify(currentUser)) // 写入首选项
      // 写入全局状态
      AppStorage.setOrCreate<AuthUser>(Constants.USER_AUTH_KEY, currentUser)
      promptAction.showToast({ message: '登录成功' })
      router.pushUrl({
        url: Constants.PAGE_INDEX
      })
    } catch (error) {
      promptAction.showToast({ message: error.message })
    }
  }

  // 发送验证码
  async sendCode() {
    if (this.checkMobile()) {
      if (this.timeCount < 60) {
        return
      } // 因为此时倒计时正在进行中 已经发过了 还在继续
      // 此时可以发验证码
      await cloud.auth()
        .requestVerifyCode({
          action: VerifyCodeAction.REGISTER_LOGIN, // 注册登录
          lang: 'zh_CN', // 国家
          sendInterval: 60, // 时间间隔
          verifyCodeType: {
            phoneNumber: this.mobile, // 手机号
            countryCode: '86',
            kind: 'phone'
          }
        })
      // 开始计时器
      this.beginRunCount()
    } else {
      promptAction.showToast({ message: '手机号格式不符合要求' })
    }
  }

  beginRunCount() {
    this.timer = setInterval(() => {
      if (this.timeCount === 0) {
        clearInterval(this.timer) // 清理定时器
        this.timeCount = 60 // 恢复60 回到当初
        return
      }
      this.timeCount--
    }, 1000)
  }

  aboutToDisappear(): void {
    clearInterval(this.timer) // 销毁定时器
  }

  build() {
    Row() {
      Column({ space: 24 }) {
        Image($r('app.media.ic_logo'))
          .margin({ top: 108 })
          .width(90)
          .aspectRatio(1)

        Text('欢迎使用鸿盟刷题')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入手机号', text: $$this.mobile })
          .commonStyle()
          .height(48)


        Stack({ alignContent: Alignment.End }) {
          TextInput({ placeholder: '请输入验证码', text: $$this.code })
            .commonStyle()
            .height(48)

          Text(this.timeCount < 60 ? `还剩${this.timeCount}秒` : '获取验证码')
            .fontSize(13)
            .fontColor(this.timeCount < 60 ? $r("app.color.send_disable_color") : $r("app.color.send_code_color"))
            .margin({
              right: 10
            })
            .enabled(this.checkMobile() && this.timeCount === 60)
            .onClick(() => {
              this.sendCode()
            })
        }

        Button('登录')
          .enabled(true)
          .commonButtonStyle()
          .enabled(this.checkMobile() && this.checkCode())
          .onClick(() => {
            this.login()
          })

      }
      .width('100%')
      .height('100%')
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