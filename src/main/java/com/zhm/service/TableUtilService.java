package com.zhm.service;

import com.google.common.base.CaseFormat;
import com.google.common.collect.Lists;
import com.zhm.model.TableFields;
import com.zhm.model.TableInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;
import org.springframework.stereotype.Service;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

/**
 * Created by zhm on 17-1-10.
 */
@Service("tableUtilService")
public class TableUtilService {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<String> listAllTables(){
        List<String> results = Lists.newArrayList();
        try {
            DatabaseMetaData md = jdbcTemplate.getDataSource().getConnection().getMetaData();
            ResultSet rs = md.getTables(null, null, "%", null);
            while (rs.next()) {
                results.add(rs.getString(3));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    public TableInfo getModelFromTable(String tableName){
        TableInfo tinfo = new TableInfo();
        tinfo.setTableName(tableName);
        tinfo.setModelName(CaseFormat.UPPER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL,tableName));
        List<TableFields> fieldsList = getTableFields(tableName);
        tinfo.setFields(fieldsList);
        return tinfo;
    }

    /**
     * 根据表名称获取表字段
     * @param tableName
     * @return
     */
    private List<TableFields> getTableFields(String tableName) {
        List<TableFields> results = Lists.newArrayList();
        SqlRowSet rowSet = jdbcTemplate.queryForRowSet("select * from "+tableName+" limit 0");
        SqlRowSetMetaData metaData = rowSet.getMetaData();
        int columnCount = metaData.getColumnCount();
        for (int i = 1; i <= columnCount; i++) {
            TableFields field = new TableFields();
            String columnName = metaData.getColumnName(i);
            field.setColumnName(columnName);
            field.setColumnClassName(metaData.getColumnClassName(i).replace("java.lang.",""));
            field.setColumnType(metaData.getColumnType(i));
            field.setModelName(CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, columnName));
            //tinyint自动转Byte,修改为转Integer
            checkColumnType(metaData.getColumnType(i),field);
            results.add(field);
        }
        return results;
    }

    private void checkColumnType(int columnType, TableFields field) {
        switch (columnType){
            case Types.TINYINT:
                field.setColumnClassName("Integer");
                field.setColumnType(Types.INTEGER);
                break;
            default:
        }
    }
}
