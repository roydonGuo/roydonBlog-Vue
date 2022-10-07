package com.roydon.controller;

import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Article;
import com.roydon.service.ArticleService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/6
 * Time: 19:27
 **/
@RestController
@RequestMapping("/article")
public class ArticleController {

    @Resource
    private ArticleService articleService;

    /**
     * 测试
     *
     * @return
     */
    @GetMapping("/list")
    public List<Article> getArticleList() {

        return articleService.list();
    }

    /**
     * 热门文章
     *
     * @return
     */
    @GetMapping("/hotArticleList")
    public ResponseResult hResponseResult() {

        ResponseResult result = articleService.hotArticleList();

        return result;
    }

    /**
     * 分页文章list
     *
     * @param pageNum
     * @param pageSize
     * @param categoryId
     * @return
     */
    @GetMapping("/articleList")
    public ResponseResult articleList(@RequestParam Integer pageNum,
                                      @RequestParam Integer pageSize,
                                      @RequestParam(defaultValue = "") Long categoryId) {

        return articleService.articleList(pageNum, pageSize, categoryId);

    }

    @GetMapping("/{id}")
    public ResponseResult articleDetail(@PathVariable("id") Long id){
        return articleService.getArticleDetail(id);
    }


}
