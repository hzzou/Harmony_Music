

export enum MusicPlayMode{
  SINGLE_CYCLE = 0,
  ORDER = 1,
  RANDOM = 2
}

export enum AudioPlayerState{
  IDLE,
  INITIALIZED,
  LOAD,
  PREPARED,
  PLAY,
  PAUSE,
  STOP,
  ERROR,
  COMPLETED,
  RELEASED,
  PROGRESS_SPEED,
  TIME_UPDATE,
  VOLUME_CHANGE,
  UNKNOWN
}