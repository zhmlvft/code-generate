package ${entity.basePackage}.exception;


import ${entity.basePackage}.errorcode.CommonErrorCode;
import ${entity.basePackage}.errorcode.ErrorCode;

public class CommonException extends com.zhm.exception.BaseException {
    private static final ErrorCode DEFAULT_CODE = CommonErrorCode.DEFAULT_ERROR;

    private String code = DEFAULT_CODE.getCode();

    private int status = DEFAULT_CODE.getStatus();

    public CommonException(String code, int status, String message) {
        super(message);
        this.code = code;
        this.status = status;
    }

    public CommonException(String message) {
        super(message);
    }

    /**
     * @param errorCode 状态码, 这个字段会在错误信息里返回给客户端.
     * @param message
     */
    public CommonException(ErrorCode errorCode, String message) {
        this(errorCode.getCode(), errorCode.getStatus(), message);
    }

    public CommonException(ErrorCode errorCode) {
        this(errorCode, errorCode.getMessage());
    }

    public String getCode() {
        return code;
    }

    public int getStatus() {
        return status;
    }
}
