package roydonBlog;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.roydon.RoydonBlogApplication;
import com.roydon.domain.entity.User;
import com.roydon.mapper.UserMapper;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by Intellij IDEA
 * Author: yi cheng
 * Date: 2022/10/8
 * Time: 10:40
 **/
@SpringBootTest(classes = RoydonBlogApplication.class)
public class RoydonBlogApplicationTests {

    @Resource
    private UserMapper userMapper;

    @Resource
    private PasswordEncoder passwordEncoder;


    @Test
    void pwdTest() {
        String pwd = passwordEncoder.encode("123456");
        System.out.println(pwd);
    }

    @Test
    void userMapperTest() {
        LambdaQueryWrapper<User> userLambdaQueryWrapper = new LambdaQueryWrapper<>();
        userLambdaQueryWrapper.orderByAsc(User ::getCreateTime);

        List<User> userList = userMapper.selectList(userLambdaQueryWrapper);

        userList.forEach(System.out::println);
    }


}
