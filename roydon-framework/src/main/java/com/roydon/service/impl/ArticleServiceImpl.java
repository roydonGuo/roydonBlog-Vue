package com.roydon.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Article;
import com.roydon.domain.entity.Category;
import com.roydon.domain.vo.ArticleDetailVo;
import com.roydon.domain.vo.ArticleListVo;
import com.roydon.domain.vo.HotArticleVo;
import com.roydon.domain.vo.PageVo;
import com.roydon.mapper.ArticleMapper;
import com.roydon.service.ArticleService;
import com.roydon.service.CategoryService;
import com.roydon.utils.BeanCopyUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static com.roydon.constants.SystemConstants.ARTICLE_STATUS_NORMAL;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/7
 * Time: 16:03
 **/
@Slf4j
@Service
public class ArticleServiceImpl extends ServiceImpl<ArticleMapper, Article> implements ArticleService {

    @Resource
    private CategoryService categoryService;

    /**
     * 热门文章list
     *
     * @return ResponseResult
     */
    @Override
    public ResponseResult hotArticleList() {

        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Article::getStatus, ARTICLE_STATUS_NORMAL);// 正式文章
        queryWrapper.orderByDesc(Article::getViewCount);// 排序规则，浏览量降序
        // 最多只能查十条
        Page<Article> articlePage = new Page(1, 10);
        this.page(articlePage, queryWrapper);

        List<Article> records = articlePage.getRecords();

//        List<HotArticleVo> hotArticleVos =records.stream().map(item->{
//            HotArticleVo hotArticleVo = new HotArticleVo();
//            BeanUtils.copyProperties(item, hotArticleVo);
//            return hotArticleVo;
//        }).collect(Collectors.toList());
        List<HotArticleVo> hotArticleVos = BeanCopyUtils.copyBeanList(records, HotArticleVo.class);

        log.info("热门文章vo集合：{}", hotArticleVos);

        return ResponseResult.okResult(hotArticleVos);
    }

    /**
     * 分页查询文章
     *
     * @param pageNum    pageNum
     * @param pageSize   pageSize
     * @param categoryId 分类id
     * @return ResponseResult
     */
    @Override
    public ResponseResult articleList(Integer pageNum, Integer pageSize, Long categoryId) {

        LambdaQueryWrapper<Article> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Article::getStatus, ARTICLE_STATUS_NORMAL);// 正式文章
        queryWrapper.eq(Objects.nonNull(categoryId) && categoryId > 0, Article::getCategoryId, categoryId);
        queryWrapper.orderByDesc(Article::getIsTop);//置顶文章
//        queryWrapper.orderByDesc(Article::getCreateTime);// 排序规则，时间降序
        //分页查询
        Page<Article> page = new Page<>(pageNum, pageSize);
        page(page, queryWrapper);
        List<Article> articles = page.getRecords();

        log.info("分页查询文章list：{}", articles);
        //查询categoryName
//        for (Article article : articles) {
//            Category category = categoryService.getById(article.getCategoryId());
//            article.setCategoryName(category.getName());
//        }
        // 执行这一步需要在实体类添加注解 @Accessors(chain = true)意思为set方法返回类型为Article
        articles.stream().map(a -> a.setCategoryName(categoryService.getById(a.getCategoryId()).getName())).collect(Collectors.toList());
        //封装查询结果
        List<ArticleListVo> articleListVos = BeanCopyUtils.copyBeanList(articles, ArticleListVo.class);
        PageVo pageVo = new PageVo(articleListVos, page.getTotal());
        return ResponseResult.okResult(pageVo);
    }


    /**
     * 文章详情
     * @param id id
     * @return ResponseResult
     */
    @Override
    public ResponseResult getArticleDetail(Long id) {

        Article article = getById(id);
        ArticleDetailVo articleDetailVo = BeanCopyUtils.copyBean(article, ArticleDetailVo.class);
        //获取分类名
        Category category = categoryService.getById(article.getCategoryId());
        if (Objects.nonNull(category)) {
            articleDetailVo.setCategoryName(category.getName());
        }

        return ResponseResult.okResult(articleDetailVo);
    }
}
