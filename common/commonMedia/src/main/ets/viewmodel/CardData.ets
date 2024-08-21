import { resourceManager } from '@kit.LocalizationKit';
import { SongItem } from './SongData';

export class CardData{

  isPlay?: boolean;

  musicName?: string;

  musicCover?: resourceManager.Resource;

  musicSinger?: string;

  cardSongList?: SongItem[]
}