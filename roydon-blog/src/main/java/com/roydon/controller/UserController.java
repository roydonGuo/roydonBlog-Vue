package com.roydon.controller;

import com.roydon.annotation.SystemLog;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.User;
import com.roydon.service.UserService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    @GetMapping("/userInfo")
    public ResponseResult userInfo(){
        return userService.userInfo();

    }
    @PutMapping("/userInfo")
    @SystemLog(businessName = "更新用户")
    public ResponseResult updateUserInfo(@RequestBody User user){
        return userService.updateUserInfo(user);
    }

    @PostMapping("/register")
    public ResponseResult register(@RequestBody User user){
        return userService.register(user);
    }
}
