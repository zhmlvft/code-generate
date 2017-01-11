package com.zhm.model;

import com.zhm.utils.Constants;

import java.io.Serializable;
import java.util.List;

/**
 * Created by zhm on 17-1-10.
 */
public class TableInfo implements Serializable{
    private String basePackage;
    private String tableName;
    private String modelName;
    private List<TableFields> fields;

    public TableInfo() {
        this.basePackage = Constants.basePackage;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public List<TableFields> getFields() {
        return fields;
    }

    public void setFields(List<TableFields> fields) {
        this.fields = fields;
    }

    public String getBasePackage() {
        return basePackage;
    }

    public void setBasePackage(String basePackage) {
        this.basePackage = basePackage;
    }
}
