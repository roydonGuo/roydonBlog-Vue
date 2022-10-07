package com.roydon.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.roydon.domain.ResponseResult;
import com.roydon.domain.entity.Link;
import com.roydon.domain.vo.LinkVo;
import com.roydon.mapper.LinkMapper;
import com.roydon.service.LinkService;
import com.roydon.utils.BeanCopyUtils;
import org.springframework.stereotype.Service;

import java.util.List;

import static com.roydon.constants.SystemConstants.LINK_STATUS_NORMAL;

/**
 * 友链(Link)表服务实现类
 *
 * @author makejava
 * @since 2022-10-07 19:03:49
 */
@Service("linkService")
public class LinkServiceImpl extends ServiceImpl<LinkMapper, Link> implements LinkService {

    /**
     * 获取全部友链
     *
     * @return
     */
    @Override
    public ResponseResult getAllLink() {

        LambdaQueryWrapper<Link> linkLambdaQueryWrapper = new LambdaQueryWrapper<>();
        linkLambdaQueryWrapper.orderByAsc(Link::getCreateTime);
        linkLambdaQueryWrapper.eq(Link::getStatus, LINK_STATUS_NORMAL);
        List<Link> linkList = list(linkLambdaQueryWrapper);

        List<LinkVo> linkVoList = BeanCopyUtils.copyBeanList(linkList, LinkVo.class);

        return ResponseResult.okResult(linkVoList);
    }
}

