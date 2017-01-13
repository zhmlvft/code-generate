#本项目是使用数据库表，自动创建Spring-boot的Rest接口工程，1分钟就可生成可运行的rest接口。
##配置说明

###1.修改/src/main/java/com/zhm/utils/Constants.java文件。
###2.修改/src/main/resources/application.properties中的数据库配置。
###3.启动工程，访问 [http://localhost:8090/](http://localhost:8090/)  就可以把配置的数据库中的所有表生成Rest接口工程了。把zip包下载好了解压直接运行Application.java。

##Rest接口请求说明
###[swagger地址](http://localhost:8080/swagger-ui.html)

###以http://localhost:8080/user为例，接口只接收一个data参数。参数格式如下：

    {
	    "page":1,    //第几页
	    "size":10,    //每页的条数
	    "data":{
            "filters":{
                "username":"张三"，   //查询条件,目前只有精确匹配。
            }
            "columns":"id,username,mobile"    //需要返回的字段，不填就是全部返回。
	    }
    }




