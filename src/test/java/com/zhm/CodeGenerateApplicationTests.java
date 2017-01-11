package com.zhm;

import com.google.common.base.CaseFormat;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.HashMap;
import java.util.Map;

@RunWith(SpringRunner.class)
@SpringBootTest
public class CodeGenerateApplicationTests {
	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Test
	public void contextLoads() {
		String tableName = "user_info";
		String modelName = CaseFormat.UPPER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL,tableName);
		SqlRowSet rowSet = jdbcTemplate.queryForRowSet("select * from "+tableName+" limit 0");
		SqlRowSetMetaData metaData = rowSet.getMetaData();
		int columnCount = metaData.getColumnCount();
		for (int i = 1; i <= columnCount; i++) {
			Map<String,String> fieldMap = new HashMap<String,String>();
			fieldMap.put("ColumnName", metaData.getColumnName(i));
			fieldMap.put("ColumnType", String.valueOf(metaData.getColumnType(i)));
			fieldMap.put("ColumnTypeName", metaData.getColumnTypeName(i));
			fieldMap.put("CatalogName", metaData.getCatalogName(i));
			fieldMap.put("ColumnClassName", metaData.getColumnClassName(i));
			fieldMap.put("ColumnLabel", metaData.getColumnLabel(i));
			fieldMap.put("Precision", String.valueOf(metaData.getPrecision(i)));
			fieldMap.put("Scale", String.valueOf(metaData.getScale(i)));
			fieldMap.put("SchemaName", metaData.getSchemaName(i));
			fieldMap.put("TableName", metaData.getTableName(i));
			fieldMap.put("SchemaName", metaData.getSchemaName(i));
			System.out.println(fieldMap);
		}
	}

}
