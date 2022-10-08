package com.roydon.service;

import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.User;

public interface BlogLoginService {
    ResponseResult login(User user);

    ResponseResult logout();
}
