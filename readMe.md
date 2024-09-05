
## 记录

* module.json5中type的类型区别，entry: 应用的主模块(入口), feature: 应用的动态特性模块, har: 静态共享包模块, shared: 动态共享包模块
* 安装本地模块，先写 {"@ohos/library": "file:../library"}, 名字: 本地路径, 然后再再对应的oh-package.json5目录下执行 ohpm install, 添加@ohos前缀标识是标明这些包是鸿蒙系统相关的依赖
* 从项目的entry主模块进入本地feature模块，先把feature安装到设备上，再运行主模块使用router.pushUrl方法跳转，路径为'@bundle:包名（bundlename）/模块名（modulename）/路径/页面所在的文件名(不加.ets 后缀)', 此处路径从etc文件夹起步。
* 多语言版本支持问题,在resources目录下建立和base同级的文件夹名称和语言简称一样的文件夹对应，如在编程语言中语言国际化简写为zh_HK则文件夹为zh_HK
* 手动生成签名文件Build > Generate Key and CSR
* 配置申请签名文件在File > Project Structure > Project > Signing Configs窗口中
* 本地安装到模拟器只能使用hdc install 分别安装.hap和.hsp
* 打包的时候，选择H图形符号右侧那个类似摄像头的build Mode切换打包模式，
* control+option+o去除无效引用，或者Code -> Optimize Imports
