package ${entity.basePackage}.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.io.Serializable;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ${entity.modelName} implements Serializable{

    private static final long serialVersionUID = 1L;

    <#list entity.fields as property>
    <#if property.columnClassName == 'java.sql.Timestamp'>
    @io.swagger.annotations.ApiModelProperty(dataType="string",example = "2017-01-01 00:00:01")
    </#if>
    private ${property.columnClassName} ${property.modelName};
    </#list>
    public ${entity.modelName}() {
    }
    public ${entity.modelName}(<#list entity.fields as property>${property.columnClassName} ${property.modelName}<#if property_has_next>, </#if></#list>) {
        <#list entity.fields as property>
        this.${property.modelName} = ${property.modelName};
        </#list>
    }
    <#list entity.fields as property>
    public ${property.columnClassName} get${property.modelName?cap_first}() {
        return ${property.modelName};
    }

    public void set${property.modelName?cap_first}(${property.columnClassName} ${property.modelName}) {
        this.${property.modelName} = ${property.modelName};
    }

    </#list>
}