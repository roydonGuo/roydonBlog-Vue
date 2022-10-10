package com.roydon.service.impl;

import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.LoginUser;
import com.roydon.domain.entity.User;
import com.roydon.domain.vo.BlogUserLoginVo;
import com.roydon.domain.vo.UserInfoVo;
import com.roydon.enums.AppHttpCodeEnum;
import com.roydon.exception.SystemException;
import com.roydon.service.AdminLoginService;
import com.roydon.utils.BeanCopyUtils;
import com.roydon.utils.JwtUtil;
import com.roydon.utils.RedisCache;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Objects;

import static com.roydon.constants.RedisConstants.LOGIN_ADMIN_KEY;

/**
 * Author: roydon - 2022/10/10
 **/
@Slf4j
@Service
public class AdminLoginServiceImpl implements AdminLoginService {

    @Resource
    private AuthenticationManager authenticationManager;

    @Resource
    private RedisCache redisCache;


    /**
     * 登录
     *
     * @param user
     * @return ResponseResult.okResult(blogUserLoginVo)
     */
    @Override
    public ResponseResult login(User user) {

        if (StringUtils.isEmpty(user.getUserName())) {
            throw new SystemException(AppHttpCodeEnum.REQUIRE_USERNAME);
        }
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(user.getUserName(), user.getPassword());
        Authentication authentication = authenticationManager.authenticate(authenticationToken);
        //判断是否认证通过
        if (Objects.isNull(authentication)) {
            throw new RuntimeException("用户名或密码错误");
        }
        // 认证成功，从Authentication获取LoginUser
        LoginUser loginUser = (LoginUser) authentication.getPrincipal();

        log.info("loginUser:{}", loginUser);

        String userId = loginUser.getUser().getId().toString();
        // 生成token
        String jwt = JwtUtil.createJWT(userId);
        // 存入redis
        redisCache.setCacheObject(LOGIN_ADMIN_KEY + userId, loginUser);

        UserInfoVo userInfoVo = BeanCopyUtils.copyBean(loginUser.getUser(), UserInfoVo.class);
        BlogUserLoginVo blogUserLoginVo = new BlogUserLoginVo(jwt, userInfoVo);

        log.info("当前登录用户：{}", blogUserLoginVo);

        return ResponseResult.okResult(blogUserLoginVo);
    }


}
