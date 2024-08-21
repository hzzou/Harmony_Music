import { preferences } from '@kit.ArkData';

class PreferenceUtil{
  prefMap: Map<string, preferences.Preferences> = new Map();

  async createPreference(context: Context, name: string){
    try{
      let prefer = await preferences.getPreferences(context, name); // get方式它不存在就会创建
      this.prefMap.set(name, prefer);
      console.log(`加载preference ${name}成功`);
    } catch (e) {
      console.log(`加载preference ${name}失败`, JSON.stringify(e));
    }
  }

  async setPreference(name: string, key:  string, value: preferences.ValueType){
    if(!this.prefMap.has(name)){
      console.log(`preference ${name}尚未初始化`);
      return;
    }

    try{
      let prefer = this.prefMap.get(name);
      await prefer?.put(key, value);
      await prefer?.flush();
      console.log(`保存preference ${name}的${key}=${value} 成功`)
    } catch (e) {
      console.log(`保存preference ${name}的${key}=${value} 失败`, JSON.stringify(e))
    }
  }

  async getPreference(name: string, key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType>{
    let result: preferences.ValueType = defaultValue;
    if(!this.prefMap.has(name)){
      console.log(`preference ${name}尚未初始化`);
      return result;
    }

    try{
      let prefer = this.prefMap.get(name);
      if(prefer){
        result = await prefer.get(key, defaultValue);
        console.log(`读取preference ${name}的${key} = ${result} 成功`);
        // 若放到此处，函数末尾会有个undefined返回
      }
    } catch (e) {
      console.log(`读取preference ${name}的${key}失败`, JSON.stringify(e));
    }
    // 若不放到这里return的话，函数末尾会有个undefined
    return result;
  }

  // 只从缓存中删除，不会删除持久化
  async removePreferenceFromCache(context: Context, name: string){
    if(!this.prefMap.has(name)){
      console.log(`preference ${name}尚未初始化`);
      return;
    }

    try{
      await preferences.removePreferencesFromCache(context, name);
      console.log(`从缓存移除preference ${name}成功`);
    } catch (e) {
      console.log(`从缓存移除preference ${name}失败`, JSON.stringify(e));
    }
  }

  // 删除preference, 不仅删除缓存中的，持久化的也删除
  async deletePreference(context: Context, name: string){
    if(!this.prefMap.has(name)){
      console.log(`preference ${name}尚未初始化`);
      return;
    }

    try{
      await preferences.deletePreferences(context, name);
      this.prefMap.delete(name);
    } catch (e) {
      console.log(`删除preference ${name}失败`, JSON.stringify(e));
    }
  }
}

export default new PreferenceUtil();