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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import static org.springframework.http.MediaType.APPLICATION_JSON_UTF8_VALUE;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.util.List;
import java.util.Map;

@Controller
public class ${entity.modelName}Controller extends BaseController<PageImpl<${entity.modelName}>>{
    @Autowired
    private ${entity.modelName}Service ${entity.modelName?uncap_first}Service;
    @RequestMapping(value = "/${entity.modelName?uncap_first}",method = POST,consumes = APPLICATION_JSON_UTF8_VALUE,produces = APPLICATION_JSON_UTF8_VALUE)
    public @ResponseBody CommonResponse<PageImpl<${entity.modelName}>> ${entity.modelName?uncap_first}list(String token, @RequestBody JsonNode data){
        if(data==null){
            throw new CommonException("客户端提交的data参数为空，请校验,正确的格式为data={\"page\":1,\"size\":10,\"data\":{\"filters\":{},\"columns\":\"\"}！");
        }
        if(!checkJson(data)){
            return null;
        }
        Pageable page = new PageRequest(data.get("page").asInt()-1,data.get("size").asInt());
        Map<String, Object> params = parseJsonToMap(data);
        params.put("start",page.getPageNumber()*page.getPageSize());
        JsonNode columns = data.get("data").get("columns");
        if(columns!=null&&StringUtils.isEmpty(columns.asText())){
            columns=null;
        }
        List<${entity.modelName}> result = ${entity.modelName?uncap_first}Service.findByCond(params, columns==null?null:columns.asText());
        long total = ${entity.modelName?uncap_first}Service.findNumsByCond(params);
        return buildResponse(new PageImpl<${entity.modelName}>(result,page,total));
    }
}
