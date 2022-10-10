package com.roydon.job;

import com.roydon.domain.entity.Article;
import com.roydon.service.ArticleService;
import com.roydon.utils.RedisCache;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.roydon.constants.RedisConstants.ARTICLE_VIEWCOUNT;

/**
 * Author: roydon - 2022/10/10
 **/
@Component
public class UpdateViewCountJob {

    @Resource
    private RedisCache redisCache;

    @Resource
    private ArticleService articleService;

    @Scheduled(cron = "0/55 * * * * ?")//55秒执行一次
    public void updateViewCountJob() {
        //获取redis中的浏览量更新到数据库
        Map<String, Integer> viewCount = redisCache.getCacheMap(ARTICLE_VIEWCOUNT);

        List<Article> articleList = viewCount
                .entrySet()
                .stream()
                .map(e -> new Article(Long.valueOf(e.getKey()), e.getValue().longValue()))
                .collect(Collectors.toList());

        articleService.updateBatchById(articleList);

    }

}
