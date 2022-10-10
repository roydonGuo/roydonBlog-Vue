package com.roydon.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@Configuration
public class SwaggerConfig {

    @Bean
    public Docket customDocket() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.roydon.controller"))
                .build();
    }

    private ApiInfo apiInfo() {
        Contact contact = new Contact("roydon", "https://roydon.xyz", "3133010060@qq.com");
        return new ApiInfoBuilder()
                .title("roydon_blog")
                .description("个人博客")
                .contact(contact)   // 联系方式
                .version("1.0.0")  // 版本
                .build();
    }
}