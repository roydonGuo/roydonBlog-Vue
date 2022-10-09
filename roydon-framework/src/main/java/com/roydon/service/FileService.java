package com.roydon.service;

import com.roydon.domain.ResponseResult;
import org.springframework.web.multipart.MultipartFile;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/9
 * Time: 16:17
 **/
public interface FileService {

    ResponseResult uploadImg(MultipartFile file);

}
