package com.roydon.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.User;


/**
 * 用户表(User)表服务接口
 *
 * @author makejava
 * @since 2022-10-07 19:25:38
 */
public interface UserService extends IService<User> {

    ResponseResult userInfo();
}

