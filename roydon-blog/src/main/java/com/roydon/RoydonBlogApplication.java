package com.roydon;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/6
 * Time: 18:31
 **/
@SpringBootApplication
@MapperScan("com.roydon.mapper")
public class RoydonBlogApplication {
    public static void main(String[] args) {
        SpringApplication.run(RoydonBlogApplication.class, args);
    }
}
