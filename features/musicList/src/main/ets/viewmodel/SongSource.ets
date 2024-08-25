import { SongItem } from '@ohos/mediaCommon';

export class SongSource implements IDataSource{
  private dataArray: SongItem[] = [];
  private listeners: DataChangeListener[] = []; // 数据变动事件listener，DataChangeListener接口上已经定义了类型

  constructor(element: SongItem[]) {
    this.dataArray = element;
  }

  totalCount(): number {
    return this.dataArray.length;
  }

  getData(index: number): SongItem {
    return this.dataArray[index];
  }

  addData(index: number, data: SongItem): void{
    this.dataArray.splice(index, 0, data); // 在当前位置删除0个元素，插入data
    // 通知数据listener上的添加事件
    this.notifyDataAdd(index);
  }

  pushData(data: SongItem): void{
    this.dataArray.push(data);
    // 通知数据listener上的添加事件
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  // 通知数据添加
  notifyDataAdd(index: number): void{
    this.listeners.map(listener=>{
      // listener上的onDataAdd事件
      listener.onDataAdd(index);
    })
  }

  // 通知数据reload
  notifyDataReload(): void{
    this.listeners.map(listener=>{
      listener.onDataReloaded();
    })
  }

  // 通知数据改变
  notifyDataChange(index: number): void{
    this.listeners.map(listener=>{
      listener.onDataChange(index);
    })
  }

  // 数据删除
  notifyDataDelete(index: number): void{
    this.listeners.map(listener=>{
      listener.onDataDelete(index);
    })
  }

  // 数据移动
  notifyDataMove(from: number, to: number): void{
    this.listeners.map(listener=>{
      listener.onDataMove(from, to);
    })
  }

  // 把事件添加进事件listener数组
  registerDataChangeListener(listener: DataChangeListener): void {
    if(!this.listeners.includes(listener)){
      this.listeners.push(listener);
    }
  }

  // 把事件从事件listener数组移除
  unregisterDataChangeListener(listener: DataChangeListener): void {
    if(this.listeners.includes(listener)){
      let idx = this.listeners.findIndex(ele=>ele === listener);
      this.listeners.splice(idx, 1);
    }
  }
  
}

