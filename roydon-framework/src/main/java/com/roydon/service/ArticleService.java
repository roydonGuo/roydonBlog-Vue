package com.roydon.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Article;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/7
 * Time: 16:02
 **/
public interface ArticleService extends IService<Article> {
    ResponseResult hotArticleList();

    ResponseResult articleList(Integer pageNum, Integer pageSize, Long categoryId);

    ResponseResult getArticleDetail(Long id);
}
