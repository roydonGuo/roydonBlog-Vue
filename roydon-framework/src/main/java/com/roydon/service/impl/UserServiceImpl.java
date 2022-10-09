package com.roydon.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.User;
import com.roydon.domain.vo.UserInfoVo;
import com.roydon.mapper.UserMapper;
import com.roydon.service.UserService;
import com.roydon.utils.BeanCopyUtils;
import com.roydon.utils.SecurityUtils;
import org.springframework.stereotype.Service;

/**
 * 用户表(User)表服务实现类
 *
 * @author makejava
 * @since 2022-10-07 19:25:39
 */
@Service("userService")
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Override
    public ResponseResult userInfo() {
        //根据用户id查询用户信息
        User user = getById(SecurityUtils.getUserId());
        //封装成UserInfoVo
        UserInfoVo vo = BeanCopyUtils.copyBean(user,UserInfoVo.class);
        return ResponseResult.okResult(vo);
    }
}

