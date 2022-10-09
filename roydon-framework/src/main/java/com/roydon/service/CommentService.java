package com.roydon.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Comment;


/**
 * 评论表(Comment)表服务接口
 *
 * @author makejava
 * @since 2022-10-08 17:39:25
 */
public interface CommentService extends IService<Comment> {

    ResponseResult commentList(String commentType, Integer pageNum, Integer pageSize, Long articleId);

    ResponseResult addComment(Comment comment);
}

