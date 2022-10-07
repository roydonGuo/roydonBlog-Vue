package com.roydon.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Link;


/**
 * 友链(Link)表服务接口
 *
 * @author makejava
 * @since 2022-10-07 19:03:49
 */
public interface LinkService extends IService<Link> {

    ResponseResult getAllLink();
}

