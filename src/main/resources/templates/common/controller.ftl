package ${entity.basePackage}.web;

import com.fasterxml.jackson.databind.JsonNode;
import ${entity.basePackage}.web.*;
import ${entity.basePackage}.model.*;
import ${entity.basePackage}.service.*;
import ${entity.basePackage}.exception.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
public class ${entity.modelName}Controller extends BaseController{
    @Autowired
    private ${entity.modelName}Service ${entity.modelName?uncap_first}Service;
    @RequestMapping(value = "/${entity.modelName?uncap_first}")
    public @ResponseBody CommonResponse ${entity.modelName?uncap_first}list(String token, String data){
        if(StringUtils.isEmpty(data)){
            throw new CommonException("客户端提交的data参数为空，请校验,正确的格式为data={\"page\":1,\"size\":10,\"data\":{}}！");
        }
        JsonNode json = parseStringToJson(data);
        if(StringUtils.isEmpty(json)){
            throw new CommonException("客户端提交的data参数为空，请校验,正确的格式为data={\"page\":1,\"size\":10,\"data\":{}}！");
        }
        if(!checkJson(json)){
            return null;
        }
        Pageable page = new PageRequest(json.get("page").asInt()-1,json.get("size").asInt());
        Map<String, Object> params = parseJsonToMap(json);
        params.put("start",page.getPageNumber()*page.getPageSize());
        JsonNode columns = json.get("data").get("columns");
        List<${entity.modelName}> result = ${entity.modelName?uncap_first}Service.findByCond(params, columns==null?null:columns.asText());
        long total = ${entity.modelName?uncap_first}Service.findNumsByCond(params);
        return buildResponse(new PageImpl<${entity.modelName}>(result,page,total));
    }
}
