package ${entity.basePackage}.web;

import ${entity.basePackage}.errorcode.CommonErrorCode;
import ${entity.basePackage}.errorcode.ErrorCode;
import ${entity.basePackage}.model.CommonResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import javax.servlet.http.HttpServletRequest;

/**
 * 统一异常处理
 */
@ControllerAdvice
public class AppExceptionHandlerController extends ResponseEntityExceptionHandler {

    protected Logger logger = LoggerFactory.getLogger(this.getClass());


    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<CommonResponse> handleException(HttpServletRequest request, Exception e) {
        logger.error("服务器发生错误: " + e.getMessage(), e);
        ErrorCode errorCode = CommonErrorCode.DEFAULT_ERROR;
        return createResponseEntity(errorCode, request.getRequestURI(), errorCode.getMessage());
    }


    private ResponseEntity<CommonResponse> createResponseEntity(ErrorCode errorCode, String requestUri, String message) {
        return createResponseEntity(errorCode.getCode(), errorCode.getStatus(), requestUri, message);
    }

    private ResponseEntity<CommonResponse> createResponseEntity(String code, int status, String requestUri, String message) {
        CommonResponse error = new CommonResponse(status, message, code);
        return ResponseEntity.status(HttpStatus.OK).
                header("Content-Type","application/json; charset=UTF-8").
                body(error);
    }

}