package com.roydon.controller;


import com.roydon.domain.ResponseResult;
import com.roydon.service.TagService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 标签(Tag)表控制层
 *
 * @author makejava
 * @since 2022-10-10 18:10:42
 */
@RestController
@RequestMapping("/content/tag")
public class TagController {
    /**
     * 服务对象
     */
    @Resource
    private TagService tagService;

    @GetMapping("/list")
    public ResponseResult list() {
        return ResponseResult.okResult(tagService.list());
    }


}

