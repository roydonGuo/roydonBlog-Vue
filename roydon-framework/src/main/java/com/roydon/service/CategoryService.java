package com.roydon.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Category;


/**
 * 分类表(Category)表服务接口
 *
 * @author makejava
 * @since 2022-10-07 17:24:53
 */
public interface CategoryService extends IService<Category> {

    ResponseResult getCategoryList();
}

