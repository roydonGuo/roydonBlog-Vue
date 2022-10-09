package com.roydon.controller;

import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Comment;
import com.roydon.service.CommentService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

import static com.roydon.constants.SystemConstants.ARTICLE_COMMENT;
import static com.roydon.constants.SystemConstants.LINK_COMMENT;

@RestController
@RequestMapping("/comment")
public class CommentController {

    @Resource
    private CommentService commentService;

    @GetMapping("/commentList")
    public ResponseResult commentList(@RequestParam Integer pageNum,
                                      @RequestParam Integer pageSize,
                                      @RequestParam(defaultValue = "") Long articleId) {
        return commentService.commentList(ARTICLE_COMMENT,pageNum, pageSize,articleId);
    }

    @GetMapping("/linkCommentList")
    public ResponseResult linkCommentList(@RequestParam Integer pageNum,
                                          @RequestParam Integer pageSize){
        return commentService.commentList(LINK_COMMENT,pageNum,pageSize,1L);
    }

    @PostMapping
    public ResponseResult addComment(@RequestBody Comment comment){
        return commentService.addComment(comment);
    }
}
