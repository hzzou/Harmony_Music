import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import { image } from '@kit.ImageKit';
import { Logger } from './Logger';

export class MediaTool{

  static async getPixelMapFromResource(context: common.UIAbilityContext, name: resourceManager.Resource): Promise<PixelMap>{
    let resourceMgr = context.resourceManager;
    let fileData: Uint8Array = await resourceMgr.getMediaContent(name);

    return await image.createImageSource(fileData.buffer).createPixelMap();
  }

  static async getPixelMapFromFile(id: string, path: string): Promise<image.PixelMap>{
    Logger.info('MediaTool', 'getPixelMapFromFile id:'+id+', path:'+path);

    return await image.createImageSource(path).createPixelMap();
  }

  /**
   * 日期不足两位补 0
   * @param value
   * @returns
   * padStart的第一位参数是目标字符串长度，第二个参数是长度补足则以它补位
   */
  private static fill(value: number): string{
    return value.toString().padStart(2, '0');
  }

  static msToCountdownTime(ms: number): string{
    if(!ms){
      return '00:00';
    }

    const day = Math.floor(ms / (1000 * 60 * 60 * 24)); // 除
    const hour = Math.floor((ms % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)); //先对天取余, 再除小时
    const minute = Math.floor((ms % (1000 * 60 * 60)) / (1000 * 60)); // 先对小时取余，再除分
    const second = Math.floor((ms % (1000 * 60)) / 1000); // 先对分取余，再除秒

    // day和hour有为0的情况. trim()方法是除去首尾空格
    return `${(day ? MediaTool.fill(day)+':' : '')}${(hour ? MediaTool.fill(hour)+':' : '')}${MediaTool.fill(minute)}:${MediaTool.fill(second)}`.trim();
  }
}