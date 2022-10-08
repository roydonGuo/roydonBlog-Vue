package com.roydon.handler.exception;

import com.roydon.domain.ResponseResult;
import com.roydon.exception.SystemException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/8
 * Time: 17:13
 **/
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(SystemException.class)
    public ResponseResult handle(SystemException se) {
        log.info("您的异常请注意查收：{}",se);
        return ResponseResult.errorResult(se.getCode(), se.getMessage());
    }

}
