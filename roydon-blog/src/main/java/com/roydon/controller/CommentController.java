package com.roydon.controller;

import com.roydon.domain.ResponseResult;
import com.roydon.domain.dto.AddCommentDto;
import com.roydon.domain.entity.Comment;
import com.roydon.service.CommentService;
import com.roydon.utils.BeanCopyUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

import static com.roydon.constants.SystemConstants.ARTICLE_COMMENT;
import static com.roydon.constants.SystemConstants.LINK_COMMENT;

@RestController
@RequestMapping("/comment")
@Api(tags = "评论", description = "评论相关接口")
public class CommentController {

    @Resource
    private CommentService commentService;

    @GetMapping("/commentList")
    public ResponseResult commentList(@RequestParam Integer pageNum,
                                      @RequestParam Integer pageSize,
                                      @RequestParam(defaultValue = "") Long articleId) {
        return commentService.commentList(ARTICLE_COMMENT, pageNum, pageSize, articleId);
    }

    @GetMapping("/linkCommentList")
    @ApiOperation(value = "友链评论接口", notes = "获取一页评论")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "pageNum", value = "当前页码"),
            @ApiImplicitParam(name = "pageSize", value = "分页大小")
    })
    public ResponseResult linkCommentList(@RequestParam Integer pageNum,
                                          @RequestParam Integer pageSize) {
        return commentService.commentList(LINK_COMMENT, pageNum, pageSize, 1L);
    }

    @PostMapping
    public ResponseResult addComment(@RequestBody AddCommentDto addCommentDto) {
        Comment comment = BeanCopyUtils.copyBean(addCommentDto, Comment.class);
        return commentService.addComment(comment);
    }
}
