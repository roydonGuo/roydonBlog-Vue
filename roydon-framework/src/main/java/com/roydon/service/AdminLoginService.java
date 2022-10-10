package com.roydon.service;

import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.User;

public interface AdminLoginService {
    ResponseResult login(User user);

}
