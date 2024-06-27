import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Window from '@ohos.window';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';
import { initialize } from '@hw-agconnect/hmcore';
import buffer from '@ohos.buffer';
import { Constants } from '../common';
import { UserSetting } from '../utils/setting';

export default class EntryAbility extends UIAbility {
  onCreate() {
    let AtManager = abilityAccessCtrl.createAtManager();
    AtManager.requestPermissionsFromUser(this.context, ['ohos.permission.READ_MEDIA', 'ohos.permission.MEDIA_LOCATION'])
      .then((data) => {
        // this.initAgc()
        hilog.info(0x0000, 'testTag', '%{public}s', 'request permissions from user success' + data);
      })
      .catch((error: BusinessError) => {
        hilog.error(0x0000, 'testTag', 'Failed to request permissions from user. Cause: %{public}s', JSON.stringify(error) ?? '');
      });
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  async initAgc() {
    let input = await this.context.resourceManager.getRawFileContent('agconnect-services.json')
    let json: string = buffer.from(input as ArrayBufferLike).toString("utf8");
    initialize(this.context, JSON.parse(json));
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    let toPath = Constants.PAGE_LOGIN
    await this.initAgc()
    const win = windowStage.getMainWindowSync()
    win.setWindowLayoutFullScreen(true) // 设置全屏
     const topHeight = win.getWindowAvoidArea(Window.AvoidAreaType.TYPE_SYSTEM).topRect.height
     const bottomHeight = win.getWindowAvoidArea(Window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height
    AppStorage.setOrCreate("topHeight", px2vp(topHeight))
    AppStorage.setOrCreate("bottomHeight", px2vp(bottomHeight))
    UserSetting.context = this.context // 赋值上下文
    if(UserSetting.getUserAuth()) {
      // 已经登录过了
      toPath = Constants.PAGE_INDEX // 换成主页
    }
    windowStage.loadContent(toPath, (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
