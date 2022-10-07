package com.roydon.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Article;
import com.roydon.domain.entity.Category;
import com.roydon.domain.vo.CategoryVo;
import com.roydon.mapper.CategoryMapper;
import com.roydon.service.CategoryService;
import com.roydon.utils.BeanCopyUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.roydon.constants.SystemConstants.ARTICLE_STATUS_NORMAL;
import static com.roydon.constants.SystemConstants.STATUS_NORMAL;

/**
 * 分类表(Category)表服务实现类
 *
 * @author makejava
 * @since 2022-10-07 17:24:54
 */
@Slf4j
@Service("categoryService")
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {

    @Resource
    private ArticleServiceImpl articleService;

    /**
     * 获取分类list
     *
     * @return
     */
    @Override
    public ResponseResult getCategoryList() {

        LambdaQueryWrapper<Article> articleQueryWrapper = new LambdaQueryWrapper<>();
        articleQueryWrapper.eq(Article::getStatus, ARTICLE_STATUS_NORMAL);
        List<Article> articleList = articleService.list(articleQueryWrapper);

        //获取文章的分类id
        Set<Long> categoryList = articleList.stream().map(i -> i.getCategoryId()).collect(Collectors.toSet());

        List<Category> categories = listByIds(categoryList);
        categories = categories.stream().filter(c -> STATUS_NORMAL.equals(c.getStatus())).collect(Collectors.toList());

        List<CategoryVo> categoryVos = BeanCopyUtils.copyBeanList(categories, CategoryVo.class);
        log.info("分类的vo集合：{}", categoryVos);

        return ResponseResult.okResult(categoryVos);
    }
}

