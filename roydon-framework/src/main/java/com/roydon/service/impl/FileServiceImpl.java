package com.roydon.service.impl;

import com.google.gson.Gson;
import com.qiniu.common.QiniuException;
import com.qiniu.http.Response;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.Region;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.DefaultPutRet;
import com.qiniu.util.Auth;
import com.roydon.domain.ResponseResult;
import com.roydon.service.FileService;
import com.roydon.utils.PathUtils;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/9
 * Time: 16:18
 **/
@Service
@Data
@Slf4j
//@ConfigurationProperties(prefix = "oss")
public class FileServiceImpl implements FileService {

    @Override
    public ResponseResult uploadImg(MultipartFile file) {

        String originalFilename = file.getOriginalFilename();
        //对原始文件名进行判断
//        if(!originalFilename.endsWith(".png")){
//            throw new SystemException(AppHttpCodeEnum.FILE_TYPE_ERROR);
//        }

        //上传文件到OSS
        assert originalFilename != null;
        String filePath = PathUtils.generateFilePath(originalFilename);
        String url = uploadOss(file, filePath);

        log.info("图片上传地址：{}",url);

        return ResponseResult.okResult(url);
    }

    @Value("${oss.accessKey}")
    private String accessKey;

    @Value("${oss.secretKey}")
    private String secretKey;

    @Value("${oss.bucket}")
    private String bucket;

    private String uploadOss(MultipartFile imgFile, String filePath) {
        //构造一个带指定 Region 对象的配置类
        Configuration cfg = new Configuration(Region.autoRegion());
        //...其他参数参考类注释
        UploadManager uploadManager = new UploadManager(cfg);
        //默认不指定key的情况下，以文件内容的hash值作为文件名
        String key = filePath;
        try {
            InputStream inputStream = imgFile.getInputStream();
            Auth auth = Auth.create(accessKey, secretKey);
            String upToken = auth.uploadToken(bucket);
            try {
                Response response = uploadManager.put(inputStream, key, upToken, null, null);
                //解析上传成功的结果
                DefaultPutRet putRet = new Gson().fromJson(response.bodyString(), DefaultPutRet.class);
                System.out.println(putRet.key);
                System.out.println(putRet.hash);
                return "http://rjh778l49.bkt.clouddn.com/" + key;
            } catch (QiniuException ex) {
                Response r = ex.response;
                System.err.println(r.toString());
                try {
                    System.err.println(r.bodyString());
                } catch (QiniuException ex2) {
                    //ignore
                }
            }
        } catch (Exception ex) {
            //ignore
        }
        return "www";
    }

}
