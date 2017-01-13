package com.zhm.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.zhm.model.TableInfo;
import com.zhm.service.TableUtilService;
import com.zhm.utils.Constants;
import com.zhm.utils.ZipUtils;
import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipOutputStream;

/**
 * Created by zhm on 17-1-10.
 */
@Controller
public class HomeController {

    @Autowired
    private TableUtilService tableUtilService;
    @Value("${spring.datasource.name}")
    private String datasourceName;
    @Value("${spring.datasource.driver-class-name}")
    private String driverClassname;
    @Value("${spring.datasource.username}")
    private String datasourceUsername;
    @Value("${spring.datasource.password}")
    private String datasourcePassword;
    @Value("${spring.datasource.url}")
    private String datasourceUrl;

    private final Configuration cfg = new Configuration(Configuration.VERSION_2_3_25);
    private final File outDirFile = new File(Constants.output+Constants.ApplicationName+"/");

    @RequestMapping("/")
    public void root(ModelMap model, HttpServletResponse response) throws IOException {
        //根据数据源反向生成表信息
        List<TableInfo> results = Lists.newArrayList();
        tableUtilService.listAllTables().stream().forEach(tableName->{
            results.add(tableUtilService.getModelFromTable(tableName));
        });
        generateProjectFile(results);
        //下载压缩包
        String zipName = Constants.ApplicationName+".zip";
        response.setContentType("APPLICATION/OCTET-STREAM");
        response.setHeader("Content-Disposition","attachment; filename="+zipName);
        ZipOutputStream out = new ZipOutputStream(response.getOutputStream());
        try {
            ZipUtils.zipFiles(Constants.output+Constants.ApplicationName+"/", out);
            response.flushBuffer();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.close();
        }
    }

    /**
     * 生成SpringBoot 项目代码
     * @param results
     */
    private void generateProjectFile(List<TableInfo> results) {
        if(!outDirFile.exists()){
            outDirFile.mkdir();
        }
        try {
            cfg.setDirectoryForTemplateLoading(new ClassPathResource("/templates/").getFile());
        } catch (IOException e) {
            e.printStackTrace();
        }
        cfg.setObjectWrapper(new DefaultObjectWrapper(Configuration.VERSION_2_3_25));
        Map<String, Object> params = Maps.newHashMap();

        Map<String,Object> appConfig = createAppConfig();
        Map<String,Object> pomConfig = createPomConfig();
        results.stream().forEach(tableInfo->{
            params.put("entity",tableInfo);
            //生成通用类
            //SpringBoot启动类
            createSource("static/Application.ftl",Constants.javaBasePackage,"Application.java",params);
            //swagger配置文件
            createSource("static/SwaggerConfig.ftl",Constants.javaBasePackage+".config","SwaggerConfig.java",params);
            //logback配置
            createSource("static/logback.ftl",Constants.resourcesBasePackage,"logback.xml",params);
            //Controller基类
            createSource("static/BaseController.ftl",Constants.javaBasePackage+".web","BaseController.java",params);
            //通用返回bean
            createSource("static/CommonResponse.ftl",Constants.javaBasePackage+".model","CommonResponse.java",params);
            //通用异常
            createSource("static/BaseException.ftl",Constants.javaBasePackage+".exception","BaseException.java",params);
            createSource("static/CommonException.ftl",Constants.javaBasePackage+".exception","CommonException.java",params);
            createSource("static/CommonErrorCode.ftl",Constants.javaBasePackage+".errorcode","CommonErrorCode.java",params);
            createSource("static/ErrorCode.ftl",Constants.javaBasePackage+".errorcode","ErrorCode.java",params);
            //通用异常捕获
            createSource("static/AppExceptionHandlerController.ftl",Constants.javaBasePackage+".web","AppExceptionHandlerController.java",params);

            //生成bean
            createSource("common/model.ftl",Constants.javaBasePackage+".model",tableInfo.getModelName()+".java",params);
            //生成service
            createSource("common/service.ftl",Constants.javaBasePackage+".service",tableInfo.getModelName()+"Service.java",params);
            //生成controller
            createSource("common/controller.ftl",Constants.javaBasePackage+".web",tableInfo.getModelName()+"Controller.java",params);
            //生成pom
            createSource("static/pom.ftl","","pom.xml",pomConfig);
            //生成spring boot  配置文件
            createSource("static/applicationProperties.ftl",Constants.resourcesBasePackage,"application.properties",appConfig);
        });
    }

    private Map<String,Object> createPomConfig() {
        Map<String,Object> results = Maps.newHashMap();
        results.put("groupid",Constants.ApplicationGroupId);
        results.put("appname",Constants.ApplicationName);
        results.put("appversion",Constants.ApplicationVersion);
        return results;
    }

    private Map<String,Object> createAppConfig() {
        Map<String,Object> results = Maps.newHashMap();
        results.put("datasourceName",datasourceName);
        results.put("datasourceUsername",datasourceUsername);
        results.put("driverClassname",driverClassname);
        results.put("datasourcePassword",datasourcePassword);
        results.put("datasourceUrl",datasourceUrl);
        return results;
    }

    private void createSource(String modelName, String packageName, String fileName,Map<String,Object> params) {
        Writer modelWriter = null;
        try {
            Template modelTemplate = cfg.getTemplate(modelName);
            File modelFile = toFilename( packageName,fileName);
            modelWriter = new FileWriter(modelFile);
            modelTemplate.process(params, modelWriter);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (TemplateException e) {
            e.printStackTrace();
        }finally{
            if(modelWriter != null){
                try {
                    modelWriter.flush();
                    modelWriter.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private File toFilename(String filePackage, String filename) {
        String packageSubPath = filePackage.replace('.', '/');
        File packagePath = new File(outDirFile,  packageSubPath);
        File file = new File(packagePath,filename);
        if(!packagePath.exists()){
            packagePath.mkdirs();
        }
        return file;
    }
}
