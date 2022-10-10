package com.roydon.runner;

import com.roydon.domain.entity.Article;
import com.roydon.mapper.ArticleMapper;
import com.roydon.utils.RedisCache;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.roydon.constants.RedisConstants.ARTICLE_VIEWCOUNT;

/**
 * Author: roydon - 2022/10/10
 * 程序初始化执行任务
 **/
@Component
public class ViewCountRunner implements CommandLineRunner {

    @Resource
    private ArticleMapper articleMapper;

    @Resource
    private RedisCache redisCache;

    @Override
    public void run(String... args) throws Exception {
        //查询博客
        List<Article> articleList = articleMapper.selectList(null);
        //文章id：浏览量，以map键值对形式存储
        Map<String, Integer> viewCountMap = articleList
                .stream()
                .collect(Collectors.toMap(article -> article.getId().toString(), article -> article.getViewCount().intValue()));
        redisCache.setCacheMap(ARTICLE_VIEWCOUNT, viewCountMap);

    }
}
