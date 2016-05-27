# omega-app

###  主要包含应用管理， 持续集成， 灰度发布， 应用编排

#### 1. 应用管理 （marathon）

##### 1.1  token 认证， 

 使用redis保存userid 和token的对应关系
 
##### 1.2  统一管理客户集群上marathon上的应用

* 应用部署
* 应用更新
* 应用扩缩
* 应用停止，启动
* 应用删除
* 应用列表
* 应用状态（同步）
* 应用事件

##### 1.2.1  平台和客户集群交互设计：
 
 用一个请求过程举例来说： 
 
 app ---> mq ---> cluster -->[websocket]-->agent --[request]--> marathon
 
 app <--- mq <--- cluster <--[websocket]<--agent <--[response]--marathon

##### 1.2.2 重点说下应用状态： 部署中，运行中，删除中，扩展中，停止中，启动中，撤销中，已停止，失联，异常


为了给用户更好的体验，加了很多中间状态， 这块做了较多的工作。

讨论过程中的几个方案： 

（1） 通过marathon事件

缺点：marathon事件只上报一次，受网络环境影响，容易丢失
优点：事件的数据量很少，网络压力很小，计算压力小

（2）agent获取marathon数据计算后上报

缺点：会给agent增加计算负担，不断上报也会有网络负担，占用客户机器资源
有点：状态准确， 计算后上报数据量小

（3）由app主动请求，获取数据

缺点：请求全量数据
优点：状态准确，只在使用的时候请求数据，由服务端来计算。

综合考虑，选择了方案3


##### 1.2.3 可能会遇到的问题及优化

 应用列表： 列表中可以显示多个集群的应用， 需要app去请求所有集群的数据，如果用户集群多，一次请求的数据量会很大，且在不同的网络环境下，可能会造成请求超时。
 
 解决办法： 静态数据和动态数据分开请求
 
 * 静态数据：应用的基本信息会保存到平台数据库，我们可以很快的请求到这些静态数据：如应用名称，所属集群，更新时间，容器个数等基本配置，
 
 * 动态数据：应用变化的数据，我们会实时的从客户的marathon上请求，如应用状态，正在运行的实例，
即使集群有问题，应用列表可以正常使用。


##### 1.3 用户组 

去cluster请求用户角色，根据用户角色显示用户的应用列表，管理员显示所有，非管理员显示个人的。
 

#### 2. 持续集成 （drone，harbor）

##### 2.1 创建项目


##### 2.2 像harbor注册用户并创建同名的project

	生成登陆的用户名和密码

##### 2.3 pull代码，编译，build imaga， 推镜像 等（由drone来完成）

	详细介绍drone
	
 1.  构建一个项目的过程（www.shurenyun.com） .sryci.yaml 文件 dockerfile文件
 
 2.  .env.sample 配置文件
 
 3. drone api 接口  
     * post /api/repo
     * post /api/hook
     * get /api/log
     * delete 
 
 4. sryun driver 
     * 解析 .sryci.yaml
     * 初始化用户repo，检查是否需要build (git fetch --depth=1 origin)
     
 
 5. poller   定时检查是否需要更新
 
 6. drone-exec drone-git drone-cache

##### 2.4 用户通过构建好的镜像部署应用。

	1. 通过marathon uri 下载 docker 登陆文件
	
	cat ./docker/config.json
	
	{
          "auths": {
                  "http://catalog.shurenyun.com": {
                          "auth": "ZG1fZGV2OkRtX2RldjEyMzQ1", 
                          "email": "zhguo@dataman-inc.com"
                  }
           } 	   
    }
    
    ZG1fZGV2OkRtX2RldjEyMzQ1 解码后   dm_dev:Dm_dev12345
	


#### 3. 灰度发布 （haproxy, bamboo）

	原理： 1. haproxy 权重
	      2. haproxy 后面放多个应用  对外暴露同一个端口。 
