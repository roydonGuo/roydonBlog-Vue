package com.roydon.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.roydon.domain.entity.User;
import com.roydon.mapper.UserMapper;
import com.roydon.service.UserService;
import org.springframework.stereotype.Service;

/**
 * 用户表(User)表服务实现类
 *
 * @author makejava
 * @since 2022-10-07 19:25:39
 */
@Service("userService")
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

}

