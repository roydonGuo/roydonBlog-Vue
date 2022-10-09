package com.roydon.controller;

import com.roydon.domain.ResponseResult;
import com.roydon.service.FileService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/9
 * Time: 16:13
 **/
@RestController
public class FileController {

    @Resource
    private FileService fileService;


    @PostMapping("/upload")
    public ResponseResult uploadFile(@RequestParam("img") MultipartFile file) {

        //头像上传
        return fileService.uploadImg(file);

    }


}
