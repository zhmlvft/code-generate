package ${entity.basePackage}.model;


import com.fasterxml.jackson.annotation.JsonInclude;

import java.io.Serializable;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class CommonResponse implements Serializable{
    private static final long serialVersionUID = 1L;
    private int status;
    private String errmsg;
    private String code;
    private Object data;

    public CommonResponse(int status, Object data) {
        this.status = status;
        this.data = data;
    }

    public CommonResponse(int status, Object data, String code) {
        this.status = status;
        this.code = code;
        this.data = data;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getErrmsg() {
        return errmsg;
    }

    public void setErrmsg(String errmsg) {
        this.errmsg = errmsg;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
