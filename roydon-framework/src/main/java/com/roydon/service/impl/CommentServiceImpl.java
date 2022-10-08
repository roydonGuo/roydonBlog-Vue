package com.roydon.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Comment;
import com.roydon.mapper.CommentMapper;
import com.roydon.service.CommentService;
import org.springframework.stereotype.Service;

/**
 * 评论表(Comment)表服务实现类
 *
 * @author makejava
 * @since 2022-10-08 17:42:51
 */
@Service("commentService")
public class CommentServiceImpl extends ServiceImpl<CommentMapper, Comment> implements CommentService {


    @Override
    public ResponseResult commentList(Long articleId, Integer pageNum, Integer pageSize) {
        return null;
    }
}

