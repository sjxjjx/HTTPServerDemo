## 使用CocoaHTTPServer框架实现wifi局域网传输文件到iPhone的功能

CocoaHTTPServer在这里就不多做介绍，如果没有的话，可以的GitHub上去下载：[https://github.com/robbiehanson/CocoaHTTPServer](https://github.com/robbiehanson/CocoaHTTPServer)。
下面开始简单介绍一下CocoaHTTPServer的使用。

### 步骤1：

CocoaHTTPServer框架中的文件导入项目中，需要的文件有：

1. Core文件夹下所有文件
2. Vendor文件夹下所有文件
3. Samples -> SimpleFileUploadServer -> SimpleFileUploadServer -> MyHTTPConnection.h + MyHTTPConnection.m + web文件夹下所有文件   

文件参考以下图片：
![](http://upload-images.jianshu.io/upload_images/4908799-8bd0f1c8b0b61804.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/150)
![](http://upload-images.jianshu.io/upload_images/4908799-5843eef0d02e5787.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/500)

### 步骤2：

在 MyHTTPConnection.m 文件的 processStartOfPartWithHeader: 方法中，找到对应的地方，修改文件存储位置（这里以Document为例），如下图所示：
![](http://upload-images.jianshu.io/upload_images/4908799-5088f8a0afe9e94b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/500)

### 步骤3：

配置 httpServer。代码中有一个获取ip地址的方法，可以在网上搜，只要能获取到手机设备的ip地址就可以了，然后封装成一个工具类（SJXCSMIPHelper）。

现在就可以运行一下代码，如下图：
![](http://upload-images.jianshu.io/upload_images/4908799-35286bf1672312d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/500)

在网页输入ip地址和端口，就可以使用了。
![](http://upload-images.jianshu.io/upload_images/4908799-944b64a48f139ace.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)
