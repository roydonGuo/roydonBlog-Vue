package com.roydon.controller;

import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.User;
import com.roydon.service.BlogLoginService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
public class BlogLoginController {

    @Resource
    private BlogLoginService blogLoginService;

    @PostMapping("/login")
    public ResponseResult login(@RequestBody User user){
        return blogLoginService.login(user);
    }
}
