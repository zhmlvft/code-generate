package ${entity.basePackage}.service;

import ${entity.basePackage}.model.*;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Mapper
@Service("${entity.modelName?uncap_first}Service")
public interface ${entity.modelName}Service {

    @Delete("delete from ${entity.tableName}")
    void delAll();

    @Insert("insert into ${entity.tableName}(<#list entity.fields as property>${property.columnName}<#if property_has_next>, </#if></#list>) values(<#list entity.fields as property>${r"#"}{data.${property.modelName}}<#if property_has_next>, </#if></#list>)")
    void saveInfo(@Param("data") ${entity.modelName} ${entity.modelName?uncap_first});

    @Select("<script>" +
        "select " +
            "<choose>" +
                "<when test=\"columns!=null\">" +
                    "${r"$"}{columns}" +
                "</when>" +
                "<otherwise>" +
                    "*"  +
                "</otherwise>" +
            "</choose>" +
        " from ${entity.tableName} where 1=1 " +
            <#list entity.fields as property>
            "<if test=\"data.data.filters.${property.modelName} != null\">" +
                "AND ${property.columnName} = ${r"#"}{data.data.filters.${property.modelName}} " +
            "</if>" +
            </#list>
        " limit ${r"#"}{data.start},${r"#"}{data.size}" +
    "</script>")
    List<${entity.modelName}> findByCond(@Param("data") Map params,@Param("columns") String columns);


    @Select("<script>" +
        "select count(id) from ${entity.tableName} where 1=1 " +
            <#list entity.fields as property>
            "<if test=\"data.data.filters.${property.modelName} != null\">" +
                "AND ${property.columnName} = ${r"#"}{data.data.filters.${property.modelName}} " +
            "</if>" +
            </#list>
    "</script>")
    long findNumsByCond(@Param("data") Map params);

}