import { common, wantAgent } from '@kit.AbilityKit';
import { Logger } from './Logger';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class BackgroundUtil{

  /**
   * Start background task
   *
   * @param context
   */
  public static startContinuousTask(context?: common.UIAbilityContext): void{
    if(!context){
      Logger.error('this Player', 'context  undefined');
      return;
    }
    // want是组件模块间传递信息的载体，当UIAbilityA需要启动UIAbilityB并传入一些数据时，可使用Want作为载体
    // WantAgent供了封装Want的能力，以及一些相关的操作方法
    // 鸿蒙系统中，可以通过WantAgent来创建、触发、取消Want等操作
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: context.abilityInfo.bundleName,
          abilityName: context.abilityInfo.name
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    // 获取wantAgent
    wantAgent.getWantAgent(wantAgentInfo)
      .then((wantAgentObj: Object)=>{
        try{
          // 背后运行播放
          backgroundTaskManager.startBackgroundRunning(context,
            backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj)
            .then(()=>{
              Logger.info('this Player', 'start Background running succeeded');
            })
            .catch((error: BusinessError)=>{
              Logger.error('this Player', `start Background running failed, code ${error.code}`)
            })
        } catch (error) {
          Logger.error('this Player: ', `start Background running failed. code ${(error as BusinessError).code}
         message ${(error as BusinessError).message}`);
        }
      })
  }
}