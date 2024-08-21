import { common } from '@kit.AbilityKit'
import { resourceManager } from '@kit.LocalizationKit';
import { SongItem } from '../viewmodel/SongData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Logger';

export default class SongItemBuilder{
  private context?: common.UIAbilityContext = AppStorage.get('context');
  private realUrl?: resourceManager.RawFileDescriptor;
  private songItem: SongItem | null = null;

  public async build(songItem: SongItem): Promise<SongItem>{
    this.songItem = songItem;
    if(!this.context){
      return this.songItem;
    }

    let rawfileFd = await this.context.createModuleContext('musicList')
      .resourceManager
      .getRawFd(songItem.src)
      .catch((error: BusinessError)=>{
        Logger.error(`resourceManager error code ${error.code} message ${error.message}`)
      });

    if(rawfileFd){
      this.realUrl = rawfileFd;
    }
    else{
      Logger.error('get rawfileFd failed')
    }
    Logger.info('MediaAssetBuilder build realUrl:' + this.realUrl);
    return this.songItem;
  }

  public getRealUrl(): resourceManager.RawFileDescriptor | undefined{
    Logger.info(`url ${this.realUrl}`);

    return this.realUrl;
  }

  public async release(): Promise<void>{
    if(this.context  && this.context !== null && this.songItem !== null){
      this.context.resourceManager.closeRawFd(this.songItem.src);
    }
    this.songItem = null;
    
  }
}