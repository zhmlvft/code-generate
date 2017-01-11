package ${entity.basePackage}.errorcode;

public enum CommonErrorCode implements ErrorCode {

    DEFAULT_ERROR(17000,"服务器内部出错");

    private int status;
    private String message;
    CommonErrorCode(int status, String message) {
        this.status = status;
        this.message = message;
    }
    @Override
    public String getCode() {
        return this.name();
    }

    @Override
    public int getStatus() {
        return status;
    }

    @Override
    public String getMessage() {
        return message;
    }
}
