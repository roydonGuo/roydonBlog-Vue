package com.roydon.runner;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class TestRunner implements CommandLineRunner {
    @Override
    public void run(String... args) throws Exception {
        //程序初始化执行任务
        System.out.println("程序初始化");
    }
}
