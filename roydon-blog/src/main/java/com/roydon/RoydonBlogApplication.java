package com.roydon;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/6
 * Time: 18:31
 **/
@SpringBootApplication
@MapperScan("com.roydon.mapper")
@EnableScheduling
@EnableSwagger2
public class RoydonBlogApplication {
    public static void main(String[] args) {
        SpringApplication.run(RoydonBlogApplication.class, args);
    }
}
