package com.roydon.controller;

import com.roydon.domain.ResponseResult;
import com.roydon.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;

    @GetMapping("/commentList")
    public ResponseResult commentList(@RequestParam(defaultValue = "") Long articleId,
                                      @RequestParam Integer pageNum,
                                      @RequestParam Integer pageSize){
        return commentService.commentList(articleId,pageNum,pageSize);
    }
}
