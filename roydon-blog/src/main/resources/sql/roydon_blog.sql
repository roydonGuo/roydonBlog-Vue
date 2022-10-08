/*
 Navicat Premium Data Transfer

 Source Server         : yicheng
 Source Server Type    : MySQL
 Source Server Version : 80023
 Source Host           : localhost:3306
 Source Schema         : roydon_blog

 Target Server Type    : MySQL
 Target Server Version : 80023
 File Encoding         : 65001

 Date: 08/10/2022 16:19:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for roydon_article
-- ----------------------------
DROP TABLE IF EXISTS `roydon_article`;
CREATE TABLE `roydon_article`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文章内容',
  `summary` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文章摘要',
  `category_id` bigint(0) NULL DEFAULT NULL COMMENT '所属分类id',
  `thumbnail` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缩略图',
  `is_top` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否置顶（0否，1是）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '状态（0已发布，1草稿）',
  `view_count` bigint(0) NULL DEFAULT 0 COMMENT '访问量',
  `is_comment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否允许评论 1是，0否',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` int(0) NULL DEFAULT 0 COMMENT '删除标志（0代表未删除，1代表已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roydon_article
-- ----------------------------
INSERT INTO `roydon_article` VALUES (1, 'SpringSecurity从入门到精通', '# SpringSecurity从入门到精通\n\n## 课程介绍\n\n![image-20211219121555979](img/image-20211219121555979.png)\n\n## 0. 简介\n\n​	**Spring Security** 是 Spring 家族中的一个安全管理框架。相比与另外一个安全框架**Shiro**，它提供了更丰富的功能，社区资源也比Shiro丰富。\n\n​	一般来说中大型的项目都是使用**SpringSecurity** 来做安全框架。小项目有Shiro的比较多，因为相比与SpringSecurity，Shiro的上手更加的简单。\n\n​	 一般Web应用的需要进行**认证**和**授权**。\n\n​		**认证：验证当前访问系统的是不是本系统的用户，并且要确认具体是哪个用户**\n\n​		**授权：经过认证后判断当前用户是否有权限进行某个操作**\n\n​	而认证和授权也是SpringSecurity作为安全框架的核心功能。\n\n\n\n## 1. 快速入门\n\n### 1.1 准备工作\n\n​	我们先要搭建一个简单的SpringBoot工程\n\n① 设置父工程 添加依赖\n\n~~~~xml\n    <parent>\n        <groupId>org.springframework.boot</groupId>\n        <artifactId>spring-boot-starter-parent</artifactId>\n        <version>2.5.0</version>\n    </parent>\n    <dependencies>\n        <dependency>\n            <groupId>org.springframework.boot</groupId>\n            <artifactId>spring-boot-starter-web</artifactId>\n        </dependency>\n        <dependency>\n            <groupId>org.projectlombok</groupId>\n            <artifactId>lombok</artifactId>\n            <optional>true</optional>\n        </dependency>\n    </dependencies>\n~~~~\n\n② 创建启动类\n\n~~~~java\n@SpringBootApplication\npublic class SecurityApplication {\n\n    public static void main(String[] args) {\n        SpringApplication.run(SecurityApplication.class,args);\n    }\n}\n\n~~~~\n\n③ 创建Controller\n\n~~~~java\nimport org.springframework.web.bind.annotation.RequestMapping;\nimport org.springframework.web.bind.annotation.RestController;\n\n@RestController\npublic class HelloController {\n\n    @RequestMapping(\"/hello\")\n    public String hello(){\n        return \"hello\";\n    }\n}\n\n~~~~\n\n\n\n### 1.2 引入SpringSecurity\n\n​	在SpringBoot项目中使用SpringSecurity我们只需要引入依赖即可实现入门案例。\n\n~~~~xml\n        <dependency>\n            <groupId>org.springframework.boot</groupId>\n            <artifactId>spring-boot-starter-security</artifactId>\n        </dependency>\n~~~~\n\n​	引入依赖后我们在尝试去访问之前的接口就会自动跳转到一个SpringSecurity的默认登陆页面，默认用户名是user,密码会输出在控制台。\n\n​	必须登陆之后才能对接口进行访问。\n\n\n\n## 2. 认证\n\n### 2.1 登陆校验流程\n\n![image-20211215094003288](img/image-20211215094003288.png)\n\n### 2.2 原理初探\n\n​	想要知道如何实现自己的登陆流程就必须要先知道入门案例中SpringSecurity的流程。\n\n\n\n#### 2.2.1 SpringSecurity完整流程\n\n​	SpringSecurity的原理其实就是一个过滤器链，内部包含了提供各种功能的过滤器。这里我们可以看看入门案例中的过滤器。\n\n![image-20211214144425527](img/image-20211214144425527.png)\n\n​	图中只展示了核心过滤器，其它的非核心过滤器并没有在图中展示。\n\n**UsernamePasswordAuthenticationFilter**:负责处理我们在登陆页面填写了用户名密码后的登陆请求。入门案例的认证工作主要有它负责。\n\n**ExceptionTranslationFilter：**处理过滤器链中抛出的任何AccessDeniedException和AuthenticationException 。\n\n**FilterSecurityInterceptor：**负责权限校验的过滤器。\n\n​	\n\n​	我们可以通过Debug查看当前系统中SpringSecurity过滤器链中有哪些过滤器及它们的顺序。\n\n![image-20211214145824903](img/image-20211214145824903.png)\n\n\n\n\n\n#### 2.2.2 认证流程详解\n\n![image-20211214151515385](img/image-20211214151515385.png)\n\n概念速查:\n\nAuthentication接口: 它的实现类，表示当前访问系统的用户，封装了用户相关信息。\n\nAuthenticationManager接口：定义了认证Authentication的方法 \n\nUserDetailsService接口：加载用户特定数据的核心接口。里面定义了一个根据用户名查询用户信息的方法。\n\nUserDetails接口：提供核心用户信息。通过UserDetailsService根据用户名获取处理的用户信息要封装成UserDetails对象返回。然后将这些信息封装到Authentication对象中。\n\n\n\n\n\n### 2.3 解决问题\n\n#### 2.3.1 思路分析\n\n登录\n\n​	①自定义登录接口  \n\n​				调用ProviderManager的方法进行认证 如果认证通过生成jwt\n\n​				把用户信息存入redis中\n\n​	②自定义UserDetailsService \n\n​				在这个实现类中去查询数据库\n\n校验：\n\n​	①定义Jwt认证过滤器\n\n​				获取token\n\n​				解析token获取其中的userid\n\n​				从redis中获取用户信息\n\n​				存入SecurityContextHolder\n\n#### 2.3.2 准备工作\n\n①添加依赖\n\n~~~~xml\n        <!--redis依赖-->\n        <dependency>\n            <groupId>org.springframework.boot</groupId>\n            <artifactId>spring-boot-starter-data-redis</artifactId>\n        </dependency>\n        <!--fastjson依赖-->\n        <dependency>\n            <groupId>com.alibaba</groupId>\n            <artifactId>fastjson</artifactId>\n            <version>1.2.33</version>\n        </dependency>\n        <!--jwt依赖-->\n        <dependency>\n            <groupId>io.jsonwebtoken</groupId>\n            <artifactId>jjwt</artifactId>\n            <version>0.9.0</version>\n        </dependency>\n~~~~\n\n② 添加Redis相关配置\n\n~~~~java\nimport com.alibaba.fastjson.JSON;\nimport com.alibaba.fastjson.serializer.SerializerFeature;\nimport com.fasterxml.jackson.databind.JavaType;\nimport com.fasterxml.jackson.databind.ObjectMapper;\nimport com.fasterxml.jackson.databind.type.TypeFactory;\nimport org.springframework.data.redis.serializer.RedisSerializer;\nimport org.springframework.data.redis.serializer.SerializationException;\nimport com.alibaba.fastjson.parser.ParserConfig;\nimport org.springframework.util.Assert;\nimport java.nio.charset.Charset;\n\n/**\n * Redis使用FastJson序列化\n * \n * @author sg\n */\npublic class FastJsonRedisSerializer<T> implements RedisSerializer<T>\n{\n\n    public static final Charset DEFAULT_CHARSET = Charset.forName(\"UTF-8\");\n\n    private Class<T> clazz;\n\n    static\n    {\n        ParserConfig.getGlobalInstance().setAutoTypeSupport(true);\n    }\n\n    public FastJsonRedisSerializer(Class<T> clazz)\n    {\n        super();\n        this.clazz = clazz;\n    }\n\n    @Override\n    public byte[] serialize(T t) throws SerializationException\n    {\n        if (t == null)\n        {\n            return new byte[0];\n        }\n        return JSON.toJSONString(t, SerializerFeature.WriteClassName).getBytes(DEFAULT_CHARSET);\n    }\n\n    @Override\n    public T deserialize(byte[] bytes) throws SerializationException\n    {\n        if (bytes == null || bytes.length <= 0)\n        {\n            return null;\n        }\n        String str = new String(bytes, DEFAULT_CHARSET);\n\n        return JSON.parseObject(str, clazz);\n    }\n\n\n    protected JavaType getJavaType(Class<?> clazz)\n    {\n        return TypeFactory.defaultInstance().constructType(clazz);\n    }\n}\n~~~~\n\n~~~~java\nimport org.springframework.context.annotation.Bean;\nimport org.springframework.context.annotation.Configuration;\nimport org.springframework.data.redis.connection.RedisConnectionFactory;\nimport org.springframework.data.redis.core.RedisTemplate;\nimport org.springframework.data.redis.serializer.StringRedisSerializer;\n\n@Configuration\npublic class RedisConfig {\n\n    @Bean\n    @SuppressWarnings(value = { \"unchecked\", \"rawtypes\" })\n    public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory connectionFactory)\n    {\n        RedisTemplate<Object, Object> template = new RedisTemplate<>();\n        template.setConnectionFactory(connectionFactory);\n\n        FastJsonRedisSerializer serializer = new FastJsonRedisSerializer(Object.class);\n\n        // 使用StringRedisSerializer来序列化和反序列化redis的key值\n        template.setKeySerializer(new StringRedisSerializer());\n        template.setValueSerializer(serializer);\n\n        // Hash的key也采用StringRedisSerializer的序列化方式\n        template.setHashKeySerializer(new StringRedisSerializer());\n        template.setHashValueSerializer(serializer);\n\n        template.afterPropertiesSet();\n        return template;\n    }\n    \n}\n~~~~\n\n③ 响应类\n\n~~~~java\nimport com.fasterxml.jackson.annotation.JsonInclude;\n\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@JsonInclude(JsonInclude.Include.NON_NULL)\npublic class ResponseResult<T> {\n    /**\n     * 状态码\n     */\n    private Integer code;\n    /**\n     * 提示信息，如果有错误时，前端可以获取该字段进行提示\n     */\n    private String msg;\n    /**\n     * 查询到的结果数据，\n     */\n    private T data;\n\n    public ResponseResult(Integer code, String msg) {\n        this.code = code;\n        this.msg = msg;\n    }\n\n    public ResponseResult(Integer code, T data) {\n        this.code = code;\n        this.data = data;\n    }\n\n    public Integer getCode() {\n        return code;\n    }\n\n    public void setCode(Integer code) {\n        this.code = code;\n    }\n\n    public String getMsg() {\n        return msg;\n    }\n\n    public void setMsg(String msg) {\n        this.msg = msg;\n    }\n\n    public T getData() {\n        return data;\n    }\n\n    public void setData(T data) {\n        this.data = data;\n    }\n\n    public ResponseResult(Integer code, String msg, T data) {\n        this.code = code;\n        this.msg = msg;\n        this.data = data;\n    }\n}\n~~~~\n\n④工具类\n\n~~~~java\nimport io.jsonwebtoken.Claims;\nimport io.jsonwebtoken.JwtBuilder;\nimport io.jsonwebtoken.Jwts;\nimport io.jsonwebtoken.SignatureAlgorithm;\nimport javax.crypto.SecretKey;\nimport javax.crypto.spec.SecretKeySpec;\nimport java.util.Base64;\nimport java.util.Date;\nimport java.util.UUID;\n\n/**\n * JWT工具类\n */\npublic class JwtUtil {\n\n    //有效期为\n    public static final Long JWT_TTL = 60 * 60 *1000L;// 60 * 60 *1000  一个小时\n    //设置秘钥明文\n    public static final String JWT_KEY = \"sangeng\";\n\n    public static String getUUID(){\n        String token = UUID.randomUUID().toString().replaceAll(\"-\", \"\");\n        return token;\n    }\n    \n    /**\n     * 生成jtw\n     * @param subject token中要存放的数据（json格式）\n     * @return\n     */\n    public static String createJWT(String subject) {\n        JwtBuilder builder = getJwtBuilder(subject, null, getUUID());// 设置过期时间\n        return builder.compact();\n    }\n\n    /**\n     * 生成jtw\n     * @param subject token中要存放的数据（json格式）\n     * @param ttlMillis token超时时间\n     * @return\n     */\n    public static String createJWT(String subject, Long ttlMillis) {\n        JwtBuilder builder = getJwtBuilder(subject, ttlMillis, getUUID());// 设置过期时间\n        return builder.compact();\n    }\n\n    private static JwtBuilder getJwtBuilder(String subject, Long ttlMillis, String uuid) {\n        SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;\n        SecretKey secretKey = generalKey();\n        long nowMillis = System.currentTimeMillis();\n        Date now = new Date(nowMillis);\n        if(ttlMillis==null){\n            ttlMillis=JwtUtil.JWT_TTL;\n        }\n        long expMillis = nowMillis + ttlMillis;\n        Date expDate = new Date(expMillis);\n        return Jwts.builder()\n                .setId(uuid)              //唯一的ID\n                .setSubject(subject)   // 主题  可以是JSON数据\n                .setIssuer(\"sg\")     // 签发者\n                .setIssuedAt(now)      // 签发时间\n                .signWith(signatureAlgorithm, secretKey) //使用HS256对称加密算法签名, 第二个参数为秘钥\n                .setExpiration(expDate);\n    }\n\n    /**\n     * 创建token\n     * @param id\n     * @param subject\n     * @param ttlMillis\n     * @return\n     */\n    public static String createJWT(String id, String subject, Long ttlMillis) {\n        JwtBuilder builder = getJwtBuilder(subject, ttlMillis, id);// 设置过期时间\n        return builder.compact();\n    }\n\n    public static void main(String[] args) throws Exception {\n        String token = \"eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJjYWM2ZDVhZi1mNjVlLTQ0MDAtYjcxMi0zYWEwOGIyOTIwYjQiLCJzdWIiOiJzZyIsImlzcyI6InNnIiwiaWF0IjoxNjM4MTA2NzEyLCJleHAiOjE2MzgxMTAzMTJ9.JVsSbkP94wuczb4QryQbAke3ysBDIL5ou8fWsbt_ebg\";\n        Claims claims = parseJWT(token);\n        System.out.println(claims);\n    }\n\n    /**\n     * 生成加密后的秘钥 secretKey\n     * @return\n     */\n    public static SecretKey generalKey() {\n        byte[] encodedKey = Base64.getDecoder().decode(JwtUtil.JWT_KEY);\n        SecretKey key = new SecretKeySpec(encodedKey, 0, encodedKey.length, \"AES\");\n        return key;\n    }\n    \n    /**\n     * 解析\n     *\n     * @param jwt\n     * @return\n     * @throws Exception\n     */\n    public static Claims parseJWT(String jwt) throws Exception {\n        SecretKey secretKey = generalKey();\n        return Jwts.parser()\n                .setSigningKey(secretKey)\n                .parseClaimsJws(jwt)\n                .getBody();\n    }\n\n\n}\n~~~~\n\n~~~~java\nimport java.util.*;\nimport java.util.concurrent.TimeUnit;\n\n@SuppressWarnings(value = { \"unchecked\", \"rawtypes\" })\n@Component\npublic class RedisCache\n{\n    @Autowired\n    public RedisTemplate redisTemplate;\n\n    /**\n     * 缓存基本的对象，Integer、String、实体类等\n     *\n     * @param key 缓存的键值\n     * @param value 缓存的值\n     */\n    public <T> void setCacheObject(final String key, final T value)\n    {\n        redisTemplate.opsForValue().set(key, value);\n    }\n\n    /**\n     * 缓存基本的对象，Integer、String、实体类等\n     *\n     * @param key 缓存的键值\n     * @param value 缓存的值\n     * @param timeout 时间\n     * @param timeUnit 时间颗粒度\n     */\n    public <T> void setCacheObject(final String key, final T value, final Integer timeout, final TimeUnit timeUnit)\n    {\n        redisTemplate.opsForValue().set(key, value, timeout, timeUnit);\n    }\n\n    /**\n     * 设置有效时间\n     *\n     * @param key Redis键\n     * @param timeout 超时时间\n     * @return true=设置成功；false=设置失败\n     */\n    public boolean expire(final String key, final long timeout)\n    {\n        return expire(key, timeout, TimeUnit.SECONDS);\n    }\n\n    /**\n     * 设置有效时间\n     *\n     * @param key Redis键\n     * @param timeout 超时时间\n     * @param unit 时间单位\n     * @return true=设置成功；false=设置失败\n     */\n    public boolean expire(final String key, final long timeout, final TimeUnit unit)\n    {\n        return redisTemplate.expire(key, timeout, unit);\n    }\n\n    /**\n     * 获得缓存的基本对象。\n     *\n     * @param key 缓存键值\n     * @return 缓存键值对应的数据\n     */\n    public <T> T getCacheObject(final String key)\n    {\n        ValueOperations<String, T> operation = redisTemplate.opsForValue();\n        return operation.get(key);\n    }\n\n    /**\n     * 删除单个对象\n     *\n     * @param key\n     */\n    public boolean deleteObject(final String key)\n    {\n        return redisTemplate.delete(key);\n    }\n\n    /**\n     * 删除集合对象\n     *\n     * @param collection 多个对象\n     * @return\n     */\n    public long deleteObject(final Collection collection)\n    {\n        return redisTemplate.delete(collection);\n    }\n\n    /**\n     * 缓存List数据\n     *\n     * @param key 缓存的键值\n     * @param dataList 待缓存的List数据\n     * @return 缓存的对象\n     */\n    public <T> long setCacheList(final String key, final List<T> dataList)\n    {\n        Long count = redisTemplate.opsForList().rightPushAll(key, dataList);\n        return count == null ? 0 : count;\n    }\n\n    /**\n     * 获得缓存的list对象\n     *\n     * @param key 缓存的键值\n     * @return 缓存键值对应的数据\n     */\n    public <T> List<T> getCacheList(final String key)\n    {\n        return redisTemplate.opsForList().range(key, 0, -1);\n    }\n\n    /**\n     * 缓存Set\n     *\n     * @param key 缓存键值\n     * @param dataSet 缓存的数据\n     * @return 缓存数据的对象\n     */\n    public <T> BoundSetOperations<String, T> setCacheSet(final String key, final Set<T> dataSet)\n    {\n        BoundSetOperations<String, T> setOperation = redisTemplate.boundSetOps(key);\n        Iterator<T> it = dataSet.iterator();\n        while (it.hasNext())\n        {\n            setOperation.add(it.next());\n        }\n        return setOperation;\n    }\n\n    /**\n     * 获得缓存的set\n     *\n     * @param key\n     * @return\n     */\n    public <T> Set<T> getCacheSet(final String key)\n    {\n        return redisTemplate.opsForSet().members(key);\n    }\n\n    /**\n     * 缓存Map\n     *\n     * @param key\n     * @param dataMap\n     */\n    public <T> void setCacheMap(final String key, final Map<String, T> dataMap)\n    {\n        if (dataMap != null) {\n            redisTemplate.opsForHash().putAll(key, dataMap);\n        }\n    }\n\n    /**\n     * 获得缓存的Map\n     *\n     * @param key\n     * @return\n     */\n    public <T> Map<String, T> getCacheMap(final String key)\n    {\n        return redisTemplate.opsForHash().entries(key);\n    }\n\n    /**\n     * 往Hash中存入数据\n     *\n     * @param key Redis键\n     * @param hKey Hash键\n     * @param value 值\n     */\n    public <T> void setCacheMapValue(final String key, final String hKey, final T value)\n    {\n        redisTemplate.opsForHash().put(key, hKey, value);\n    }\n\n    /**\n     * 获取Hash中的数据\n     *\n     * @param key Redis键\n     * @param hKey Hash键\n     * @return Hash中的对象\n     */\n    public <T> T getCacheMapValue(final String key, final String hKey)\n    {\n        HashOperations<String, String, T> opsForHash = redisTemplate.opsForHash();\n        return opsForHash.get(key, hKey);\n    }\n\n    /**\n     * 删除Hash中的数据\n     * \n     * @param key\n     * @param hkey\n     */\n    public void delCacheMapValue(final String key, final String hkey)\n    {\n        HashOperations hashOperations = redisTemplate.opsForHash();\n        hashOperations.delete(key, hkey);\n    }\n\n    /**\n     * 获取多个Hash中的数据\n     *\n     * @param key Redis键\n     * @param hKeys Hash键集合\n     * @return Hash对象集合\n     */\n    public <T> List<T> getMultiCacheMapValue(final String key, final Collection<Object> hKeys)\n    {\n        return redisTemplate.opsForHash().multiGet(key, hKeys);\n    }\n\n    /**\n     * 获得缓存的基本对象列表\n     *\n     * @param pattern 字符串前缀\n     * @return 对象列表\n     */\n    public Collection<String> keys(final String pattern)\n    {\n        return redisTemplate.keys(pattern);\n    }\n}\n~~~~\n\n~~~~java\nimport javax.servlet.http.HttpServletResponse;\nimport java.io.IOException;\n\npublic class WebUtils\n{\n    /**\n     * 将字符串渲染到客户端\n     * \n     * @param response 渲染对象\n     * @param string 待渲染的字符串\n     * @return null\n     */\n    public static String renderString(HttpServletResponse response, String string) {\n        try\n        {\n            response.setStatus(200);\n            response.setContentType(\"application/json\");\n            response.setCharacterEncoding(\"utf-8\");\n            response.getWriter().print(string);\n        }\n        catch (IOException e)\n        {\n            e.printStackTrace();\n        }\n        return null;\n    }\n}\n~~~~\n\n⑤实体类\n\n~~~~java\nimport java.io.Serializable;\nimport java.util.Date;\n\n\n/**\n * 用户表(User)实体类\n *\n * @author 三更\n */\n@Data\n@AllArgsConstructor\n@NoArgsConstructor\npublic class User implements Serializable {\n    private static final long serialVersionUID = -40356785423868312L;\n    \n    /**\n    * 主键\n    */\n    private Long id;\n    /**\n    * 用户名\n    */\n    private String userName;\n    /**\n    * 昵称\n    */\n    private String nickName;\n    /**\n    * 密码\n    */\n    private String password;\n    /**\n    * 账号状态（0正常 1停用）\n    */\n    private String status;\n    /**\n    * 邮箱\n    */\n    private String email;\n    /**\n    * 手机号\n    */\n    private String phonenumber;\n    /**\n    * 用户性别（0男，1女，2未知）\n    */\n    private String sex;\n    /**\n    * 头像\n    */\n    private String avatar;\n    /**\n    * 用户类型（0管理员，1普通用户）\n    */\n    private String userType;\n    /**\n    * 创建人的用户id\n    */\n    private Long createBy;\n    /**\n    * 创建时间\n    */\n    private Date createTime;\n    /**\n    * 更新人\n    */\n    private Long updateBy;\n    /**\n    * 更新时间\n    */\n    private Date updateTime;\n    /**\n    * 删除标志（0代表未删除，1代表已删除）\n    */\n    private Integer delFlag;\n}\n~~~~\n\n\n\n#### 2.3.3 实现\n\n##### 2.3.3.1 数据库校验用户\n\n​	从之前的分析我们可以知道，我们可以自定义一个UserDetailsService,让SpringSecurity使用我们的UserDetailsService。我们自己的UserDetailsService可以从数据库中查询用户名和密码。\n\n###### 准备工作\n\n​	我们先创建一个用户表， 建表语句如下：\n\n~~~~mysql\nCREATE TABLE `sys_user` (\n  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT \'主键\',\n  `user_name` VARCHAR(64) NOT NULL DEFAULT \'NULL\' COMMENT \'用户名\',\n  `nick_name` VARCHAR(64) NOT NULL DEFAULT \'NULL\' COMMENT \'昵称\',\n  `password` VARCHAR(64) NOT NULL DEFAULT \'NULL\' COMMENT \'密码\',\n  `status` CHAR(1) DEFAULT \'0\' COMMENT \'账号状态（0正常 1停用）\',\n  `email` VARCHAR(64) DEFAULT NULL COMMENT \'邮箱\',\n  `phonenumber` VARCHAR(32) DEFAULT NULL COMMENT \'手机号\',\n  `sex` CHAR(1) DEFAULT NULL COMMENT \'用户性别（0男，1女，2未知）\',\n  `avatar` VARCHAR(128) DEFAULT NULL COMMENT \'头像\',\n  `user_type` CHAR(1) NOT NULL DEFAULT \'1\' COMMENT \'用户类型（0管理员，1普通用户）\',\n  `create_by` BIGINT(20) DEFAULT NULL COMMENT \'创建人的用户id\',\n  `create_time` DATETIME DEFAULT NULL COMMENT \'创建时间\',\n  `update_by` BIGINT(20) DEFAULT NULL COMMENT \'更新人\',\n  `update_time` DATETIME DEFAULT NULL COMMENT \'更新时间\',\n  `del_flag` INT(11) DEFAULT \'0\' COMMENT \'删除标志（0代表未删除，1代表已删除）\',\n  PRIMARY KEY (`id`)\n) ENGINE=INNODB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT=\'用户表\'\n~~~~\n\n​		引入MybatisPuls和mysql驱动的依赖\n\n~~~~xml\n        <dependency>\n            <groupId>com.baomidou</groupId>\n            <artifactId>mybatis-plus-boot-starter</artifactId>\n            <version>3.4.3</version>\n        </dependency>\n        <dependency>\n            <groupId>mysql</groupId>\n            <artifactId>mysql-connector-java</artifactId>\n        </dependency>\n~~~~\n\n​		配置数据库信息\n\n~~~~yml\nspring:\n  datasource:\n    url: jdbc:mysql://localhost:3306/sg_security?characterEncoding=utf-8&serverTimezone=UTC\n    username: root\n    password: root\n    driver-class-name: com.mysql.cj.jdbc.Driver\n~~~~\n\n​		定义Mapper接口\n\n~~~~java\npublic interface UserMapper extends BaseMapper<User> {\n}\n~~~~\n\n​		修改User实体类\n\n~~~~java\n类名上加@TableName(value = \"sys_user\") ,id字段上加 @TableId\n~~~~\n\n​		配置Mapper扫描\n\n~~~~java\n@SpringBootApplication\n@MapperScan(\"com.sangeng.mapper\")\npublic class SimpleSecurityApplication {\n    public static void main(String[] args) {\n        ConfigurableApplicationContext run = SpringApplication.run(SimpleSecurityApplication.class);\n        System.out.println(run);\n    }\n}\n~~~~\n\n​		添加junit依赖\n\n~~~~java\n        <dependency>\n            <groupId>org.springframework.boot</groupId>\n            <artifactId>spring-boot-starter-test</artifactId>\n        </dependency>\n~~~~\n\n​	   测试MP是否能正常使用\n\n~~~~java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@SpringBootTest\npublic class MapperTest {\n\n    @Autowired\n    private UserMapper userMapper;\n\n    @Test\n    public void testUserMapper(){\n        List<User> users = userMapper.selectList(null);\n        System.out.println(users);\n    }\n}\n~~~~\n\n\n\n###### 核心代码实现\n\n创建一个类实现UserDetailsService接口，重写其中的方法。更加用户名从数据库中查询用户信息\n\n~~~~java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Service\npublic class UserDetailsServiceImpl implements UserDetailsService {\n\n    @Autowired\n    private UserMapper userMapper;\n\n    @Override\n    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {\n        //根据用户名查询用户信息\n        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();\n        wrapper.eq(User::getUserName,username);\n        User user = userMapper.selectOne(wrapper);\n        //如果查询不到数据就通过抛出异常来给出提示\n        if(Objects.isNull(user)){\n            throw new RuntimeException(\"用户名或密码错误\");\n        }\n        //TODO 根据用户查询权限信息 添加到LoginUser中\n        \n        //封装成UserDetails对象返回 \n        return new LoginUser(user);\n    }\n}\n~~~~\n\n因为UserDetailsService方法的返回值是UserDetails类型，所以需要定义一个类，实现该接口，把用户信息封装在其中。\n\n```java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Data\n@NoArgsConstructor\n@AllArgsConstructor\npublic class LoginUser implements UserDetails {\n\n    private User user;\n\n\n    @Override\n    public Collection<? extends GrantedAuthority> getAuthorities() {\n        return null;\n    }\n\n    @Override\n    public String getPassword() {\n        return user.getPassword();\n    }\n\n    @Override\n    public String getUsername() {\n        return user.getUserName();\n    }\n\n    @Override\n    public boolean isAccountNonExpired() {\n        return true;\n    }\n\n    @Override\n    public boolean isAccountNonLocked() {\n        return true;\n    }\n\n    @Override\n    public boolean isCredentialsNonExpired() {\n        return true;\n    }\n\n    @Override\n    public boolean isEnabled() {\n        return true;\n    }\n}\n```\n\n注意：如果要测试，需要往用户表中写入用户数据，并且如果你想让用户的密码是明文存储，需要在密码前加{noop}。例如\n\n![image-20211216123945882](img/image-20211216123945882.png)\n\n这样登陆的时候就可以用sg作为用户名，1234作为密码来登陆了。\n\n\n\n##### 2.3.3.2 密码加密存储\n\n​	实际项目中我们不会把密码明文存储在数据库中。\n\n​	默认使用的PasswordEncoder要求数据库中的密码格式为：{id}password 。它会根据id去判断密码的加密方式。但是我们一般不会采用这种方式。所以就需要替换PasswordEncoder。\n\n​	我们一般使用SpringSecurity为我们提供的BCryptPasswordEncoder。\n\n​	我们只需要使用把BCryptPasswordEncoder对象注入Spring容器中，SpringSecurity就会使用该PasswordEncoder来进行密码校验。\n\n​	我们可以定义一个SpringSecurity的配置类，SpringSecurity要求这个配置类要继承WebSecurityConfigurerAdapter。\n\n~~~~java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Configuration\npublic class SecurityConfig extends WebSecurityConfigurerAdapter {\n\n\n    @Bean\n    public PasswordEncoder passwordEncoder(){\n        return new BCryptPasswordEncoder();\n    }\n\n}\n~~~~\n\n##### 2.3.3.3 登陆接口\n\n​	接下我们需要自定义登陆接口，然后让SpringSecurity对这个接口放行,让用户访问这个接口的时候不用登录也能访问。\n\n​	在接口中我们通过AuthenticationManager的authenticate方法来进行用户认证,所以需要在SecurityConfig中配置把AuthenticationManager注入容器。\n\n​	认证成功的话要生成一个jwt，放入响应中返回。并且为了让用户下回请求时能通过jwt识别出具体的是哪个用户，我们需要把用户信息存入redis，可以把用户id作为key。\n\n~~~~java\n@RestController\npublic class LoginController {\n\n    @Autowired\n    private LoginServcie loginServcie;\n\n    @PostMapping(\"/user/login\")\n    public ResponseResult login(@RequestBody User user){\n        return loginServcie.login(user);\n    }\n}\n\n~~~~\n\n~~~~java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Configuration\npublic class SecurityConfig extends WebSecurityConfigurerAdapter {\n\n\n    @Bean\n    public PasswordEncoder passwordEncoder(){\n        return new BCryptPasswordEncoder();\n    }\n\n    @Override\n    protected void configure(HttpSecurity http) throws Exception {\n        http\n                //关闭csrf\n                .csrf().disable()\n                //不通过Session获取SecurityContext\n                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)\n                .and()\n                .authorizeRequests()\n                // 对于登录接口 允许匿名访问\n                .antMatchers(\"/user/login\").anonymous()\n                // 除上面外的所有请求全部需要鉴权认证\n                .anyRequest().authenticated();\n    }\n\n    @Bean\n    @Override\n    public AuthenticationManager authenticationManagerBean() throws Exception {\n        return super.authenticationManagerBean();\n    }\n}\n~~~~\n\n​	\n\n~~~~java\n@Service\npublic class LoginServiceImpl implements LoginServcie {\n\n    @Autowired\n    private AuthenticationManager authenticationManager;\n    @Autowired\n    private RedisCache redisCache;\n\n    @Override\n    public ResponseResult login(User user) {\n        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(user.getUserName(),user.getPassword());\n        Authentication authenticate = authenticationManager.authenticate(authenticationToken);\n        if(Objects.isNull(authenticate)){\n            throw new RuntimeException(\"用户名或密码错误\");\n        }\n        //使用userid生成token\n        LoginUser loginUser = (LoginUser) authenticate.getPrincipal();\n        String userId = loginUser.getUser().getId().toString();\n        String jwt = JwtUtil.createJWT(userId);\n        //authenticate存入redis\n        redisCache.setCacheObject(\"login:\"+userId,loginUser);\n        //把token响应给前端\n        HashMap<String,String> map = new HashMap<>();\n        map.put(\"token\",jwt);\n        return new ResponseResult(200,\"登陆成功\",map);\n    }\n}\n\n~~~~\n\n\n\n##### 2.3.3.4 认证过滤器\n\n​	我们需要自定义一个过滤器，这个过滤器会去获取请求头中的token，对token进行解析取出其中的userid。\n\n​	使用userid去redis中获取对应的LoginUser对象。\n\n​	然后封装Authentication对象存入SecurityContextHolder\n\n\n\n~~~~java\n@Component\npublic class JwtAuthenticationTokenFilter extends OncePerRequestFilter {\n\n    @Autowired\n    private RedisCache redisCache;\n\n    @Override\n    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {\n        //获取token\n        String token = request.getHeader(\"token\");\n        if (!StringUtils.hasText(token)) {\n            //放行\n            filterChain.doFilter(request, response);\n            return;\n        }\n        //解析token\n        String userid;\n        try {\n            Claims claims = JwtUtil.parseJWT(token);\n            userid = claims.getSubject();\n        } catch (Exception e) {\n            e.printStackTrace();\n            throw new RuntimeException(\"token非法\");\n        }\n        //从redis中获取用户信息\n        String redisKey = \"login:\" + userid;\n        LoginUser loginUser = redisCache.getCacheObject(redisKey);\n        if(Objects.isNull(loginUser)){\n            throw new RuntimeException(\"用户未登录\");\n        }\n        //存入SecurityContextHolder\n        //TODO 获取权限信息封装到Authentication中\n        UsernamePasswordAuthenticationToken authenticationToken =\n                new UsernamePasswordAuthenticationToken(loginUser,null,null);\n        SecurityContextHolder.getContext().setAuthentication(authenticationToken);\n        //放行\n        filterChain.doFilter(request, response);\n    }\n}\n~~~~\n\n~~~~java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Configuration\npublic class SecurityConfig extends WebSecurityConfigurerAdapter {\n\n\n    @Bean\n    public PasswordEncoder passwordEncoder(){\n        return new BCryptPasswordEncoder();\n    }\n\n\n    @Autowired\n    JwtAuthenticationTokenFilter jwtAuthenticationTokenFilter;\n\n    @Override\n    protected void configure(HttpSecurity http) throws Exception {\n        http\n                //关闭csrf\n                .csrf().disable()\n                //不通过Session获取SecurityContext\n                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)\n                .and()\n                .authorizeRequests()\n                // 对于登录接口 允许匿名访问\n                .antMatchers(\"/user/login\").anonymous()\n                // 除上面外的所有请求全部需要鉴权认证\n                .anyRequest().authenticated();\n\n        //把token校验过滤器添加到过滤器链中\n        http.addFilterBefore(jwtAuthenticationTokenFilter, UsernamePasswordAuthenticationFilter.class);\n    }\n\n    @Bean\n    @Override\n    public AuthenticationManager authenticationManagerBean() throws Exception {\n        return super.authenticationManagerBean();\n    }\n}\n\n~~~~\n\n\n\n##### 2.3.3.5 退出登陆\n\n​	我们只需要定义一个登陆接口，然后获取SecurityContextHolder中的认证信息，删除redis中对应的数据即可。\n\n~~~~java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Service\npublic class LoginServiceImpl implements LoginServcie {\n\n    @Autowired\n    private AuthenticationManager authenticationManager;\n    @Autowired\n    private RedisCache redisCache;\n\n    @Override\n    public ResponseResult login(User user) {\n        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(user.getUserName(),user.getPassword());\n        Authentication authenticate = authenticationManager.authenticate(authenticationToken);\n        if(Objects.isNull(authenticate)){\n            throw new RuntimeException(\"用户名或密码错误\");\n        }\n        //使用userid生成token\n        LoginUser loginUser = (LoginUser) authenticate.getPrincipal();\n        String userId = loginUser.getUser().getId().toString();\n        String jwt = JwtUtil.createJWT(userId);\n        //authenticate存入redis\n        redisCache.setCacheObject(\"login:\"+userId,loginUser);\n        //把token响应给前端\n        HashMap<String,String> map = new HashMap<>();\n        map.put(\"token\",jwt);\n        return new ResponseResult(200,\"登陆成功\",map);\n    }\n\n    @Override\n    public ResponseResult logout() {\n        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();\n        LoginUser loginUser = (LoginUser) authentication.getPrincipal();\n        Long userid = loginUser.getUser().getId();\n        redisCache.deleteObject(\"login:\"+userid);\n        return new ResponseResult(200,\"退出成功\");\n    }\n}\n\n~~~~\n\n\n\n\n\n## 3. 授权\n\n### 3.0 权限系统的作用\n\n​	例如一个学校图书馆的管理系统，如果是普通学生登录就能看到借书还书相关的功能，不可能让他看到并且去使用添加书籍信息，删除书籍信息等功能。但是如果是一个图书馆管理员的账号登录了，应该就能看到并使用添加书籍信息，删除书籍信息等功能。\n\n​	总结起来就是**不同的用户可以使用不同的功能**。这就是权限系统要去实现的效果。\n\n​	我们不能只依赖前端去判断用户的权限来选择显示哪些菜单哪些按钮。因为如果只是这样，如果有人知道了对应功能的接口地址就可以不通过前端，直接去发送请求来实现相关功能操作。\n\n​	所以我们还需要在后台进行用户权限的判断，判断当前用户是否有相应的权限，必须具有所需权限才能进行相应的操作。\n\n​	\n\n### 3.1 授权基本流程\n\n​	在SpringSecurity中，会使用默认的FilterSecurityInterceptor来进行权限校验。在FilterSecurityInterceptor中会从SecurityContextHolder获取其中的Authentication，然后获取其中的权限信息。当前用户是否拥有访问当前资源所需的权限。\n\n​	所以我们在项目中只需要把当前登录用户的权限信息也存入Authentication。\n\n​	然后设置我们的资源所需要的权限即可。\n\n### 3.2 授权实现\n\n#### 3.2.1 限制访问资源所需权限\n\n​	SpringSecurity为我们提供了基于注解的权限控制方案，这也是我们项目中主要采用的方式。我们可以使用注解去指定访问对应的资源所需的权限。\n\n​	但是要使用它我们需要先开启相关配置。\n\n~~~~java\n@EnableGlobalMethodSecurity(prePostEnabled = true)\n~~~~\n\n​	然后就可以使用对应的注解。@PreAuthorize\n\n~~~~java\n@RestController\npublic class HelloController {\n\n    @RequestMapping(\"/hello\")\n    @PreAuthorize(\"hasAuthority(\'test\')\")\n    public String hello(){\n        return \"hello\";\n    }\n}\n~~~~\n\n#### 3.2.2 封装权限信息\n\n​	我们前面在写UserDetailsServiceImpl的时候说过，在查询出用户后还要获取对应的权限信息，封装到UserDetails中返回。\n\n​	我们先直接把权限信息写死封装到UserDetails中进行测试。\n\n​	我们之前定义了UserDetails的实现类LoginUser，想要让其能封装权限信息就要对其进行修改。\n\n~~~~java\npackage com.sangeng.domain;\n\nimport com.alibaba.fastjson.annotation.JSONField;\nimport lombok.AllArgsConstructor;\nimport lombok.Data;\nimport lombok.NoArgsConstructor;\nimport org.springframework.security.core.GrantedAuthority;\nimport org.springframework.security.core.authority.SimpleGrantedAuthority;\nimport org.springframework.security.core.userdetails.UserDetails;\n\nimport java.util.Collection;\nimport java.util.List;\nimport java.util.stream.Collectors;\n\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Data\n@NoArgsConstructor\npublic class LoginUser implements UserDetails {\n\n    private User user;\n        \n    //存储权限信息\n    private List<String> permissions;\n    \n    \n    public LoginUser(User user,List<String> permissions) {\n        this.user = user;\n        this.permissions = permissions;\n    }\n\n\n    //存储SpringSecurity所需要的权限信息的集合\n    @JSONField(serialize = false)\n    private List<GrantedAuthority> authorities;\n\n    @Override\n    public  Collection<? extends GrantedAuthority> getAuthorities() {\n        if(authorities!=null){\n            return authorities;\n        }\n        //把permissions中字符串类型的权限信息转换成GrantedAuthority对象存入authorities中\n        authorities = permissions.stream().\n                map(SimpleGrantedAuthority::new)\n                .collect(Collectors.toList());\n        return authorities;\n    }\n\n    @Override\n    public String getPassword() {\n        return user.getPassword();\n    }\n\n    @Override\n    public String getUsername() {\n        return user.getUserName();\n    }\n\n    @Override\n    public boolean isAccountNonExpired() {\n        return true;\n    }\n\n    @Override\n    public boolean isAccountNonLocked() {\n        return true;\n    }\n\n    @Override\n    public boolean isCredentialsNonExpired() {\n        return true;\n    }\n\n    @Override\n    public boolean isEnabled() {\n        return true;\n    }\n}\n\n~~~~\n\n​		LoginUser修改完后我们就可以在UserDetailsServiceImpl中去把权限信息封装到LoginUser中了。我们写死权限进行测试，后面我们再从数据库中查询权限信息。\n\n~~~~java\nimport com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;\nimport com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;\nimport com.baomidou.mybatisplus.extension.conditions.query.LambdaQueryChainWrapper;\nimport com.sangeng.domain.LoginUser;\nimport com.sangeng.domain.User;\nimport com.sangeng.mapper.UserMapper;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.security.core.userdetails.UserDetails;\nimport org.springframework.security.core.userdetails.UserDetailsService;\nimport org.springframework.security.core.userdetails.UsernameNotFoundException;\nimport org.springframework.stereotype.Service;\n\nimport java.util.ArrayList;\nimport java.util.Arrays;\nimport java.util.List;\nimport java.util.Objects;\n\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Service\npublic class UserDetailsServiceImpl implements UserDetailsService {\n\n    @Autowired\n    private UserMapper userMapper;\n\n    @Override\n    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {\n        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();\n        wrapper.eq(User::getUserName,username);\n        User user = userMapper.selectOne(wrapper);\n        if(Objects.isNull(user)){\n            throw new RuntimeException(\"用户名或密码错误\");\n        }\n        //TODO 根据用户查询权限信息 添加到LoginUser中\n        List<String> list = new ArrayList<>(Arrays.asList(\"test\"));\n        return new LoginUser(user,list);\n    }\n}\n\n~~~~\n\n\n\n#### 3.2.3 从数据库查询权限信息\n\n##### 3.2.3.1 RBAC权限模型\n\n​	RBAC权限模型（Role-Based Access Control）即：基于角色的权限控制。这是目前最常被开发者使用也是相对易用、通用权限模型。\n\n​	![image-20211222110249727](img/image-20211222110249727.png)\n\n##### 3.2.3.2 准备工作\n\n~~~~sql\nCREATE DATABASE /*!32312 IF NOT EXISTS*/`sg_security` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;\n\nUSE `sg_security`;\n\n/*Table structure for table `sys_menu` */\n\nDROP TABLE IF EXISTS `sys_menu`;\n\nCREATE TABLE `sys_menu` (\n  `id` bigint(20) NOT NULL AUTO_INCREMENT,\n  `menu_name` varchar(64) NOT NULL DEFAULT \'NULL\' COMMENT \'菜单名\',\n  `path` varchar(200) DEFAULT NULL COMMENT \'路由地址\',\n  `component` varchar(255) DEFAULT NULL COMMENT \'组件路径\',\n  `visible` char(1) DEFAULT \'0\' COMMENT \'菜单状态（0显示 1隐藏）\',\n  `status` char(1) DEFAULT \'0\' COMMENT \'菜单状态（0正常 1停用）\',\n  `perms` varchar(100) DEFAULT NULL COMMENT \'权限标识\',\n  `icon` varchar(100) DEFAULT \'#\' COMMENT \'菜单图标\',\n  `create_by` bigint(20) DEFAULT NULL,\n  `create_time` datetime DEFAULT NULL,\n  `update_by` bigint(20) DEFAULT NULL,\n  `update_time` datetime DEFAULT NULL,\n  `del_flag` int(11) DEFAULT \'0\' COMMENT \'是否删除（0未删除 1已删除）\',\n  `remark` varchar(500) DEFAULT NULL COMMENT \'备注\',\n  PRIMARY KEY (`id`)\n) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT=\'菜单表\';\n\n/*Table structure for table `sys_role` */\n\nDROP TABLE IF EXISTS `sys_role`;\n\nCREATE TABLE `sys_role` (\n  `id` bigint(20) NOT NULL AUTO_INCREMENT,\n  `name` varchar(128) DEFAULT NULL,\n  `role_key` varchar(100) DEFAULT NULL COMMENT \'角色权限字符串\',\n  `status` char(1) DEFAULT \'0\' COMMENT \'角色状态（0正常 1停用）\',\n  `del_flag` int(1) DEFAULT \'0\' COMMENT \'del_flag\',\n  `create_by` bigint(200) DEFAULT NULL,\n  `create_time` datetime DEFAULT NULL,\n  `update_by` bigint(200) DEFAULT NULL,\n  `update_time` datetime DEFAULT NULL,\n  `remark` varchar(500) DEFAULT NULL COMMENT \'备注\',\n  PRIMARY KEY (`id`)\n) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT=\'角色表\';\n\n/*Table structure for table `sys_role_menu` */\n\nDROP TABLE IF EXISTS `sys_role_menu`;\n\nCREATE TABLE `sys_role_menu` (\n  `role_id` bigint(200) NOT NULL AUTO_INCREMENT COMMENT \'角色ID\',\n  `menu_id` bigint(200) NOT NULL DEFAULT \'0\' COMMENT \'菜单id\',\n  PRIMARY KEY (`role_id`,`menu_id`)\n) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;\n\n/*Table structure for table `sys_user` */\n\nDROP TABLE IF EXISTS `sys_user`;\n\nCREATE TABLE `sys_user` (\n  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT \'主键\',\n  `user_name` varchar(64) NOT NULL DEFAULT \'NULL\' COMMENT \'用户名\',\n  `nick_name` varchar(64) NOT NULL DEFAULT \'NULL\' COMMENT \'昵称\',\n  `password` varchar(64) NOT NULL DEFAULT \'NULL\' COMMENT \'密码\',\n  `status` char(1) DEFAULT \'0\' COMMENT \'账号状态（0正常 1停用）\',\n  `email` varchar(64) DEFAULT NULL COMMENT \'邮箱\',\n  `phonenumber` varchar(32) DEFAULT NULL COMMENT \'手机号\',\n  `sex` char(1) DEFAULT NULL COMMENT \'用户性别（0男，1女，2未知）\',\n  `avatar` varchar(128) DEFAULT NULL COMMENT \'头像\',\n  `user_type` char(1) NOT NULL DEFAULT \'1\' COMMENT \'用户类型（0管理员，1普通用户）\',\n  `create_by` bigint(20) DEFAULT NULL COMMENT \'创建人的用户id\',\n  `create_time` datetime DEFAULT NULL COMMENT \'创建时间\',\n  `update_by` bigint(20) DEFAULT NULL COMMENT \'更新人\',\n  `update_time` datetime DEFAULT NULL COMMENT \'更新时间\',\n  `del_flag` int(11) DEFAULT \'0\' COMMENT \'删除标志（0代表未删除，1代表已删除）\',\n  PRIMARY KEY (`id`)\n) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT=\'用户表\';\n\n/*Table structure for table `sys_user_role` */\n\nDROP TABLE IF EXISTS `sys_user_role`;\n\nCREATE TABLE `sys_user_role` (\n  `user_id` bigint(200) NOT NULL AUTO_INCREMENT COMMENT \'用户id\',\n  `role_id` bigint(200) NOT NULL DEFAULT \'0\' COMMENT \'角色id\',\n  PRIMARY KEY (`user_id`,`role_id`)\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n~~~~\n\n~~~~mysql\nSELECT \n	DISTINCT m.`perms`\nFROM\n	sys_user_role ur\n	LEFT JOIN `sys_role` r ON ur.`role_id` = r.`id`\n	LEFT JOIN `sys_role_menu` rm ON ur.`role_id` = rm.`role_id`\n	LEFT JOIN `sys_menu` m ON m.`id` = rm.`menu_id`\nWHERE\n	user_id = 2\n	AND r.`status` = 0\n	AND m.`status` = 0\n~~~~\n\n\n\n~~~~java\nimport com.baomidou.mybatisplus.annotation.TableId;\nimport com.baomidou.mybatisplus.annotation.TableName;\nimport com.fasterxml.jackson.annotation.JsonInclude;\nimport lombok.AllArgsConstructor;\nimport lombok.Data;\nimport lombok.NoArgsConstructor;\n\nimport java.io.Serializable;\nimport java.util.Date;\n\n/**\n * 菜单表(Menu)实体类\n *\n * @author makejava\n * @since 2021-11-24 15:30:08\n */\n@TableName(value=\"sys_menu\")\n@Data\n@AllArgsConstructor\n@NoArgsConstructor\n@JsonInclude(JsonInclude.Include.NON_NULL)\npublic class Menu implements Serializable {\n    private static final long serialVersionUID = -54979041104113736L;\n    \n        @TableId\n    private Long id;\n    /**\n    * 菜单名\n    */\n    private String menuName;\n    /**\n    * 路由地址\n    */\n    private String path;\n    /**\n    * 组件路径\n    */\n    private String component;\n    /**\n    * 菜单状态（0显示 1隐藏）\n    */\n    private String visible;\n    /**\n    * 菜单状态（0正常 1停用）\n    */\n    private String status;\n    /**\n    * 权限标识\n    */\n    private String perms;\n    /**\n    * 菜单图标\n    */\n    private String icon;\n    \n    private Long createBy;\n    \n    private Date createTime;\n    \n    private Long updateBy;\n    \n    private Date updateTime;\n    /**\n    * 是否删除（0未删除 1已删除）\n    */\n    private Integer delFlag;\n    /**\n    * 备注\n    */\n    private String remark;\n}\n~~~~\n\n\n\n##### 3.2.3.3 代码实现\n\n​	我们只需要根据用户id去查询到其所对应的权限信息即可。\n\n​	所以我们可以先定义个mapper，其中提供一个方法可以根据userid查询权限信息。\n\n~~~~java\nimport com.baomidou.mybatisplus.core.mapper.BaseMapper;\nimport com.sangeng.domain.Menu;\n\nimport java.util.List;\n\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\npublic interface MenuMapper extends BaseMapper<Menu> {\n    List<String> selectPermsByUserId(Long id);\n}\n~~~~\n\n​	尤其是自定义方法，所以需要创建对应的mapper文件，定义对应的sql语句\n\n~~~~xml\n<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\" >\n<mapper namespace=\"com.sangeng.mapper.MenuMapper\">\n\n\n    <select id=\"selectPermsByUserId\" resultType=\"java.lang.String\">\n        SELECT\n            DISTINCT m.`perms`\n        FROM\n            sys_user_role ur\n            LEFT JOIN `sys_role` r ON ur.`role_id` = r.`id`\n            LEFT JOIN `sys_role_menu` rm ON ur.`role_id` = rm.`role_id`\n            LEFT JOIN `sys_menu` m ON m.`id` = rm.`menu_id`\n        WHERE\n            user_id = #{userid}\n            AND r.`status` = 0\n            AND m.`status` = 0\n    </select>\n</mapper>\n~~~~\n\n​	在application.yml中配置mapperXML文件的位置\n\n~~~~yaml\nspring:\n  datasource:\n    url: jdbc:mysql://localhost:3306/sg_security?characterEncoding=utf-8&serverTimezone=UTC\n    username: root\n    password: root\n    driver-class-name: com.mysql.cj.jdbc.Driver\n  redis:\n    host: localhost\n    port: 6379\nmybatis-plus:\n  mapper-locations: classpath*:/mapper/**/*.xml \n\n~~~~\n\n\n\n​	然后我们可以在UserDetailsServiceImpl中去调用该mapper的方法查询权限信息封装到LoginUser对象中即可。\n\n~~~~java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Service\npublic class UserDetailsServiceImpl implements UserDetailsService {\n\n    @Autowired\n    private UserMapper userMapper;\n\n    @Autowired\n    private MenuMapper menuMapper;\n\n    @Override\n    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {\n        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();\n        wrapper.eq(User::getUserName,username);\n        User user = userMapper.selectOne(wrapper);\n        if(Objects.isNull(user)){\n            throw new RuntimeException(\"用户名或密码错误\");\n        }\n        List<String> permissionKeyList =  menuMapper.selectPermsByUserId(user.getId());\n//        //测试写法\n//        List<String> list = new ArrayList<>(Arrays.asList(\"test\"));\n        return new LoginUser(user,permissionKeyList);\n    }\n}\n~~~~\n\n\n\n\n\n## 4. 自定义失败处理\n\n​	我们还希望在认证失败或者是授权失败的情况下也能和我们的接口一样返回相同结构的json，这样可以让前端能对响应进行统一的处理。要实现这个功能我们需要知道SpringSecurity的异常处理机制。\n\n​	在SpringSecurity中，如果我们在认证或者授权的过程中出现了异常会被ExceptionTranslationFilter捕获到。在ExceptionTranslationFilter中会去判断是认证失败还是授权失败出现的异常。\n\n> 如果是认证过程中出现的异常会被封装成AuthenticationException然后调用**AuthenticationEntryPoint**对象的方法去进行异常处理。\n>\n> 如果是授权过程中出现的异常会被封装成AccessDeniedException然后调用**AccessDeniedHandler**对象的方法去进行异常处理。\n>\n> 所以如果我们需要自定义异常处理，我们只需要自定义AuthenticationEntryPoint和AccessDeniedHandler然后配置给SpringSecurity即可。\n\n\n\n①自定义实现类\n\n~~~~java\n@Component\npublic class AccessDeniedHandlerImpl implements AccessDeniedHandler {\n    @Override\n    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) throws IOException, ServletException {\n        ResponseResult result = new ResponseResult(HttpStatus.FORBIDDEN.value(), \"权限不足\");\n        String json = JSON.toJSONString(result);\n        WebUtils.renderString(response,json);\n\n    }\n}\n\n~~~~\n\n~~~~java\n/**\n * @Author 三更  B站： https://space.bilibili.com/663528522\n */\n@Component\npublic class AuthenticationEntryPointImpl implements AuthenticationEntryPoint {\n    @Override\n    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {\n        ResponseResult result = new ResponseResult(HttpStatus.UNAUTHORIZED.value(), \"认证失败请重新登录\");\n        String json = JSON.toJSONString(result);\n        WebUtils.renderString(response,json);\n    }\n}\n\n~~~~\n\n\n\n\n\n②配置给SpringSecurity\n\n​	\n\n​	先注入对应的处理器\n\n~~~~java\n    @Autowired\n    private AuthenticationEntryPoint authenticationEntryPoint;\n\n    @Autowired\n    private AccessDeniedHandler accessDeniedHandler;\n~~~~\n\n​	然后我们可以使用HttpSecurity对象的方法去配置。\n\n~~~~java\n        http.exceptionHandling().authenticationEntryPoint(authenticationEntryPoint).\n                accessDeniedHandler(accessDeniedHandler);\n~~~~\n\n\n\n## 5. 跨域\n\n​	浏览器出于安全的考虑，使用 XMLHttpRequest对象发起 HTTP请求时必须遵守同源策略，否则就是跨域的HTTP请求，默认情况下是被禁止的。 同源策略要求源相同才能正常进行通信，即协议、域名、端口号都完全一致。 \n\n​	前后端分离项目，前端项目和后端项目一般都不是同源的，所以肯定会存在跨域请求的问题。\n\n​	所以我们就要处理一下，让前端能进行跨域请求。\n\n①先对SpringBoot配置，运行跨域请求\n\n~~~~java\n@Configuration\npublic class CorsConfig implements WebMvcConfigurer {\n\n    @Override\n    public void addCorsMappings(CorsRegistry registry) {\n      // 设置允许跨域的路径\n        registry.addMapping(\"/**\")\n                // 设置允许跨域请求的域名\n                .allowedOriginPatterns(\"*\")\n                // 是否允许cookie\n                .allowCredentials(true)\n                // 设置允许的请求方式\n                .allowedMethods(\"GET\", \"POST\", \"DELETE\", \"PUT\")\n                // 设置允许的header属性\n                .allowedHeaders(\"*\")\n                // 跨域允许时间\n                .maxAge(3600);\n    }\n}\n~~~~\n\n②开启SpringSecurity的跨域访问\n\n由于我们的资源都会收到SpringSecurity的保护，所以想要跨域访问还要让SpringSecurity运行跨域访问。\n\n~~~~java\n    @Override\n    protected void configure(HttpSecurity http) throws Exception {\n        http\n                //关闭csrf\n                .csrf().disable()\n                //不通过Session获取SecurityContext\n                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)\n                .and()\n                .authorizeRequests()\n                // 对于登录接口 允许匿名访问\n                .antMatchers(\"/user/login\").anonymous()\n                // 除上面外的所有请求全部需要鉴权认证\n                .anyRequest().authenticated();\n\n        //添加过滤器\n        http.addFilterBefore(jwtAuthenticationTokenFilter, UsernamePasswordAuthenticationFilter.class);\n\n        //配置异常处理器\n        http.exceptionHandling()\n                //配置认证失败处理器\n                .authenticationEntryPoint(authenticationEntryPoint)\n                .accessDeniedHandler(accessDeniedHandler);\n\n        //允许跨域\n        http.cors();\n    }\n\n~~~~\n\n\n\n\n\n## 6. 遗留小问题\n\n### 其它权限校验方法\n\n​	我们前面都是使用@PreAuthorize注解，然后在在其中使用的是hasAuthority方法进行校验。SpringSecurity还为我们提供了其它方法例如：hasAnyAuthority，hasRole，hasAnyRole等。\n\n​    \n\n​	这里我们先不急着去介绍这些方法，我们先去理解hasAuthority的原理，然后再去学习其他方法你就更容易理解，而不是死记硬背区别。并且我们也可以选择定义校验方法，实现我们自己的校验逻辑。\n\n​	hasAuthority方法实际是执行到了SecurityExpressionRoot的hasAuthority，大家只要断点调试既可知道它内部的校验原理。\n\n​	它内部其实是调用authentication的getAuthorities方法获取用户的权限列表。然后判断我们存入的方法参数数据在权限列表中。\n\n\n\n​	hasAnyAuthority方法可以传入多个权限，只要用户有其中任意一个权限都可以访问对应资源。\n\n~~~~java\n    @PreAuthorize(\"hasAnyAuthority(\'admin\',\'test\',\'system:dept:list\')\")\n    public String hello(){\n        return \"hello\";\n    }\n~~~~\n\n\n\n​	hasRole要求有对应的角色才可以访问，但是它内部会把我们传入的参数拼接上 **ROLE_** 后再去比较。所以这种情况下要用用户对应的权限也要有 **ROLE_** 这个前缀才可以。\n\n~~~~java\n    @PreAuthorize(\"hasRole(\'system:dept:list\')\")\n    public String hello(){\n        return \"hello\";\n    }\n~~~~\n\n\n\n​	hasAnyRole 有任意的角色就可以访问。它内部也会把我们传入的参数拼接上 **ROLE_** 后再去比较。所以这种情况下要用用户对应的权限也要有 **ROLE_** 这个前缀才可以。\n\n~~~~java\n    @PreAuthorize(\"hasAnyRole(\'admin\',\'system:dept:list\')\")\n    public String hello(){\n        return \"hello\";\n    }\n~~~~\n\n\n\n\n\n### 自定义权限校验方法\n\n​	我们也可以定义自己的权限校验方法，在@PreAuthorize注解中使用我们的方法。\n\n~~~~java\n@Component(\"ex\")\npublic class SGExpressionRoot {\n\n    public boolean hasAuthority(String authority){\n        //获取当前用户的权限\n        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();\n        LoginUser loginUser = (LoginUser) authentication.getPrincipal();\n        List<String> permissions = loginUser.getPermissions();\n        //判断用户权限集合中是否存在authority\n        return permissions.contains(authority);\n    }\n}\n~~~~\n\n​	 在SPEL表达式中使用 @ex相当于获取容器中bean的名字未ex的对象。然后再调用这个对象的hasAuthority方法\n\n~~~~java\n    @RequestMapping(\"/hello\")\n    @PreAuthorize(\"@ex.hasAuthority(\'system:dept:list\')\")\n    public String hello(){\n        return \"hello\";\n    }\n~~~~\n\n\n\n### 基于配置的权限控制\n\n​	我们也可以在配置类中使用使用配置的方式对资源进行权限控制。\n\n~~~~java\n    @Override\n    protected void configure(HttpSecurity http) throws Exception {\n        http\n                //关闭csrf\n                .csrf().disable()\n                //不通过Session获取SecurityContext\n                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)\n                .and()\n                .authorizeRequests()\n                // 对于登录接口 允许匿名访问\n                .antMatchers(\"/user/login\").anonymous()\n                .antMatchers(\"/testCors\").hasAuthority(\"system:dept:list222\")\n                // 除上面外的所有请求全部需要鉴权认证\n                .anyRequest().authenticated();\n\n        //添加过滤器\n        http.addFilterBefore(jwtAuthenticationTokenFilter, UsernamePasswordAuthenticationFilter.class);\n\n        //配置异常处理器\n        http.exceptionHandling()\n                //配置认证失败处理器\n                .authenticationEntryPoint(authenticationEntryPoint)\n                .accessDeniedHandler(accessDeniedHandler);\n\n        //允许跨域\n        http.cors();\n    }\n~~~~\n\n\n\n\n\n\n\n### CSRF\n\n​	CSRF是指跨站请求伪造（Cross-site request forgery），是web常见的攻击之一。\n\n​	https://blog.csdn.net/freeking101/article/details/86537087\n\n​	SpringSecurity去防止CSRF攻击的方式就是通过csrf_token。后端会生成一个csrf_token，前端发起请求的时候需要携带这个csrf_token,后端会有过滤器进行校验，如果没有携带或者是伪造的就不允许访问。\n\n​	我们可以发现CSRF攻击依靠的是cookie中所携带的认证信息。但是在前后端分离的项目中我们的认证信息其实是token，而token并不是存储中cookie中，并且需要前端代码去把token设置到请求头中才可以，所以CSRF攻击也就不用担心了。\n\n\n\n### 认证成功处理器\n\n​	实际上在UsernamePasswordAuthenticationFilter进行登录认证的时候，如果登录成功了是会调用AuthenticationSuccessHandler的方法进行认证成功后的处理的。AuthenticationSuccessHandler就是登录成功处理器。\n\n​	我们也可以自己去自定义成功处理器进行成功后的相应处理。\n\n~~~~java\n@Component\npublic class SGSuccessHandler implements AuthenticationSuccessHandler {\n\n    @Override\n    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {\n        System.out.println(\"认证成功了\");\n    }\n}\n\n~~~~\n\n~~~~java\n@Configuration\npublic class SecurityConfig extends WebSecurityConfigurerAdapter {\n\n    @Autowired\n    private AuthenticationSuccessHandler successHandler;\n\n    @Override\n    protected void configure(HttpSecurity http) throws Exception {\n        http.formLogin().successHandler(successHandler);\n\n        http.authorizeRequests().anyRequest().authenticated();\n    }\n}\n\n~~~~\n\n\n\n### 认证失败处理器\n\n​	实际上在UsernamePasswordAuthenticationFilter进行登录认证的时候，如果认证失败了是会调用AuthenticationFailureHandler的方法进行认证失败后的处理的。AuthenticationFailureHandler就是登录失败处理器。\n\n​	我们也可以自己去自定义失败处理器进行失败后的相应处理。\n\n~~~~java\n@Component\npublic class SGFailureHandler implements AuthenticationFailureHandler {\n    @Override\n    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {\n        System.out.println(\"认证失败了\");\n    }\n}\n~~~~\n\n\n\n~~~~java\n@Configuration\npublic class SecurityConfig extends WebSecurityConfigurerAdapter {\n\n    @Autowired\n    private AuthenticationSuccessHandler successHandler;\n\n    @Autowired\n    private AuthenticationFailureHandler failureHandler;\n\n    @Override\n    protected void configure(HttpSecurity http) throws Exception {\n        http.formLogin()\n//                配置认证成功处理器\n                .successHandler(successHandler)\n//                配置认证失败处理器\n                .failureHandler(failureHandler);\n\n        http.authorizeRequests().anyRequest().authenticated();\n    }\n}\n\n~~~~\n\n\n\n### 登出成功处理器\n\n~~~~java\n@Component\npublic class MyLogoutSuccessHandler implements LogoutSuccessHandler {\n    @Override\n    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {\n        System.out.println(\"注销成功\");\n    }\n}\n\n~~~~\n\n~~~~java\n@Configuration\npublic class SecurityConfig extends WebSecurityConfigurerAdapter {\n\n    @Autowired\n    private AuthenticationSuccessHandler successHandler;\n\n    @Autowired\n    private AuthenticationFailureHandler failureHandler;\n\n    @Autowired\n    private LogoutSuccessHandler logoutSuccessHandler;\n\n    @Override\n    protected void configure(HttpSecurity http) throws Exception {\n        http.formLogin()\n//                配置认证成功处理器\n                .successHandler(successHandler)\n//                配置认证失败处理器\n                .failureHandler(failureHandler);\n\n        http.logout()\n                //配置注销成功处理器\n                .logoutSuccessHandler(logoutSuccessHandler);\n\n        http.authorizeRequests().anyRequest().authenticated();\n    }\n}\n~~~~\n\n\n\n\n\n### 其他认证方案畅想\n\n\n\n\n\n## 7. 源码讲解\n\n​	投票过50更新源码讲解', 'SpringSecurity框架教程-Spring Security+JWT实现项目级前端分离认证授权', 1, 'https://sg-blog-oss.oss-cn-beijing.aliyuncs.com/2022/01/31/948597e164614902ab1662ba8452e106.png', '1', '0', 105, '0', NULL, '2022-01-23 23:20:11', NULL, NULL, 0);
INSERT INTO `roydon_article` VALUES (8, 'SpringSecurity从入门到精通2', '2', 'SpringSecurity框架教程-Spring Security+JWT实现项目级前端分离认证授权', 1, 'https://sg-blog-oss.oss-cn-beijing.aliyuncs.com/2022/01/31/948597e164614902ab1662ba8452e106.png', '0', '0', 105, '0', NULL, '2022-01-23 23:20:11', NULL, NULL, 0);
INSERT INTO `roydon_article` VALUES (9, 'SpringSecurity从入门到精通3', '3', 'SpringSecurity框架教程-Spring Security+JWT实现项目级前端分离认证授权', 1, 'https://sg-blog-oss.oss-cn-beijing.aliyuncs.com/2022/01/31/948597e164614902ab1662ba8452e106.png', '0', '0', 105, '0', NULL, '2022-01-23 23:20:11', NULL, NULL, 0);

-- ----------------------------
-- Table structure for roydon_article_tag
-- ----------------------------
DROP TABLE IF EXISTS `roydon_article_tag`;
CREATE TABLE `roydon_article_tag`  (
  `article_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '文章id',
  `tag_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '标签id',
  PRIMARY KEY (`article_id`, `tag_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文章标签关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roydon_article_tag
-- ----------------------------
INSERT INTO `roydon_article_tag` VALUES (1, 4);
INSERT INTO `roydon_article_tag` VALUES (2, 1);
INSERT INTO `roydon_article_tag` VALUES (2, 4);
INSERT INTO `roydon_article_tag` VALUES (3, 4);
INSERT INTO `roydon_article_tag` VALUES (3, 5);

-- ----------------------------
-- Table structure for roydon_category
-- ----------------------------
DROP TABLE IF EXISTS `roydon_category`;
CREATE TABLE `roydon_category`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类名',
  `pid` bigint(0) NULL DEFAULT -1 COMMENT '父分类id，如果没有父分类为-1',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态0:正常,1禁用',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` int(0) NULL DEFAULT 0 COMMENT '删除标志（0代表未删除，1代表已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roydon_category
-- ----------------------------
INSERT INTO `roydon_category` VALUES (1, 'java', -1, 'wsd', '0', NULL, NULL, NULL, NULL, 0);
INSERT INTO `roydon_category` VALUES (2, 'PHP', -1, 'wsd', '0', NULL, NULL, NULL, NULL, 0);

-- ----------------------------
-- Table structure for roydon_comment
-- ----------------------------
DROP TABLE IF EXISTS `roydon_comment`;
CREATE TABLE `roydon_comment`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '评论类型（0代表文章评论，1代表友链评论）',
  `article_id` bigint(0) NULL DEFAULT NULL COMMENT '文章id',
  `root_id` bigint(0) NULL DEFAULT -1 COMMENT '根评论id',
  `content` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评论内容',
  `to_comment_user_id` bigint(0) NULL DEFAULT -1 COMMENT '所回复的目标评论的userid',
  `to_comment_id` bigint(0) NULL DEFAULT -1 COMMENT '回复目标评论id',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` int(0) NULL DEFAULT 0 COMMENT '删除标志（0代表未删除，1代表已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roydon_comment
-- ----------------------------
INSERT INTO `roydon_comment` VALUES (1, '0', 1, -1, 'asS', -1, -1, 1, '2022-01-29 07:59:22', 1, '2022-01-29 07:59:22', 0);
INSERT INTO `roydon_comment` VALUES (2, '0', 1, -1, '[哈哈]SDAS', -1, -1, 1, '2022-01-29 08:01:24', 1, '2022-01-29 08:01:24', 0);
INSERT INTO `roydon_comment` VALUES (3, '0', 1, -1, '是大多数', -1, -1, 1, '2022-01-29 16:07:24', 1, '2022-01-29 16:07:24', 0);
INSERT INTO `roydon_comment` VALUES (4, '0', 1, -1, '撒大声地', -1, -1, 1, '2022-01-29 16:12:09', 1, '2022-01-29 16:12:09', 0);
INSERT INTO `roydon_comment` VALUES (5, '0', 1, -1, '你再说什么', -1, -1, 1, '2022-01-29 18:19:56', 1, '2022-01-29 18:19:56', 0);
INSERT INTO `roydon_comment` VALUES (6, '0', 1, -1, 'hffd', -1, -1, 1, '2022-01-29 22:13:52', 1, '2022-01-29 22:13:52', 0);
INSERT INTO `roydon_comment` VALUES (9, '0', 1, 2, '你说什么', 1, 2, 1, '2022-01-29 22:18:40', 1, '2022-01-29 22:18:40', 0);
INSERT INTO `roydon_comment` VALUES (10, '0', 1, 2, '哈哈哈哈[哈哈]', 1, 9, 1, '2022-01-29 22:29:15', 1, '2022-01-29 22:29:15', 0);
INSERT INTO `roydon_comment` VALUES (11, '0', 1, 2, 'we全文', 1, 10, 3, '2022-01-29 22:29:55', 1, '2022-01-29 22:29:55', 0);
INSERT INTO `roydon_comment` VALUES (12, '0', 1, -1, '王企鹅', -1, -1, 1, '2022-01-29 22:30:20', 1, '2022-01-29 22:30:20', 0);
INSERT INTO `roydon_comment` VALUES (13, '0', 1, -1, '什么阿是', -1, -1, 1, '2022-01-29 22:30:56', 1, '2022-01-29 22:30:56', 0);
INSERT INTO `roydon_comment` VALUES (14, '0', 1, -1, '新平顶山', -1, -1, 1, '2022-01-29 22:32:51', 1, '2022-01-29 22:32:51', 0);
INSERT INTO `roydon_comment` VALUES (15, '0', 1, -1, '2222', -1, -1, 1, '2022-01-29 22:34:38', 1, '2022-01-29 22:34:38', 0);
INSERT INTO `roydon_comment` VALUES (16, '0', 1, 2, '3333', 1, 11, 1, '2022-01-29 22:34:47', 1, '2022-01-29 22:34:47', 0);
INSERT INTO `roydon_comment` VALUES (17, '0', 1, 2, '回复weqedadsd', 3, 11, 1, '2022-01-29 22:38:00', 1, '2022-01-29 22:38:00', 0);
INSERT INTO `roydon_comment` VALUES (18, '0', 1, -1, 'sdasd', -1, -1, 1, '2022-01-29 23:18:19', 1, '2022-01-29 23:18:19', 0);
INSERT INTO `roydon_comment` VALUES (19, '0', 1, -1, '111', -1, -1, 1, '2022-01-29 23:22:23', 1, '2022-01-29 23:22:23', 0);
INSERT INTO `roydon_comment` VALUES (20, '0', 1, 1, '你说啥？', 1, 1, 1, '2022-01-30 10:06:21', 1, '2022-01-30 10:06:21', 0);
INSERT INTO `roydon_comment` VALUES (21, '0', 1, -1, '友链添加个呗', -1, -1, 1, '2022-01-30 10:06:50', 1, '2022-01-30 10:06:50', 0);
INSERT INTO `roydon_comment` VALUES (22, '1', 1, -1, '友链评论2', -1, -1, 1, '2022-01-30 10:08:28', 1, '2022-01-30 10:08:28', 0);
INSERT INTO `roydon_comment` VALUES (23, '1', 1, 22, '回复友链评论3', 1, 22, 1, '2022-01-30 10:08:50', 1, '2022-01-30 10:08:50', 0);
INSERT INTO `roydon_comment` VALUES (24, '1', 1, -1, '友链评论4444', -1, -1, 1, '2022-01-30 10:09:03', 1, '2022-01-30 10:09:03', 0);
INSERT INTO `roydon_comment` VALUES (25, '1', 1, 22, '收到的', 1, 22, 1, '2022-01-30 10:13:28', 1, '2022-01-30 10:13:28', 0);
INSERT INTO `roydon_comment` VALUES (26, '0', 1, -1, 'sda', -1, -1, 1, '2022-01-30 10:39:05', 1, '2022-01-30 10:39:05', 0);
INSERT INTO `roydon_comment` VALUES (27, '0', 1, 1, '说你咋地', 1, 20, 14787164048662, '2022-01-30 17:19:30', 14787164048662, '2022-01-30 17:19:30', 0);
INSERT INTO `roydon_comment` VALUES (28, '0', 1, 1, 'sdad', 1, 1, 14787164048662, '2022-01-31 11:11:20', 14787164048662, '2022-01-31 11:11:20', 0);
INSERT INTO `roydon_comment` VALUES (29, '0', 1, -1, '你说是的ad', -1, -1, 14787164048662, '2022-01-31 14:10:11', 14787164048662, '2022-01-31 14:10:11', 0);
INSERT INTO `roydon_comment` VALUES (30, '0', 1, 1, '撒大声地', 1, 1, 14787164048662, '2022-01-31 20:19:18', 14787164048662, '2022-01-31 20:19:18', 0);

-- ----------------------------
-- Table structure for roydon_link
-- ----------------------------
DROP TABLE IF EXISTS `roydon_link`;
CREATE TABLE `roydon_link`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `logo` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '网站地址',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '2' COMMENT '审核状态 (0代表审核通过，1代表审核未通过，2代表未审核)',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` int(0) NULL DEFAULT 0 COMMENT '删除标志（0代表未删除，1代表已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '友链' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roydon_link
-- ----------------------------
INSERT INTO `roydon_link` VALUES (1, 'baidu', 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fn1.itc.cn%2Fimg8%2Fwb%2Frecom%2F2016%2F05%2F10%2F146286696706220328.PNG&refer=http%3A%2F%2Fn1.itc.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646205529&t=f942665181eb9b0685db7a6f59d59975', 'sda', 'https://www.baidu.com', '0', NULL, '2022-01-13 08:25:47', NULL, '2022-01-13 08:36:14', 0);
INSERT INTO `roydon_link` VALUES (2, 'dubai', 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fn1.itc.cn%2Fimg8%2Fwb%2Frecom%2F2016%2F05%2F10%2F146286696706220328.PNG&refer=http%3A%2F%2Fn1.itc.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646205529&t=f942665181eb9b0685db7a6f59d59975', 'dada', 'https://www.qq.com', '0', NULL, '2022-01-13 09:06:10', NULL, '2022-01-13 09:07:09', 0);
INSERT INTO `roydon_link` VALUES (3, 'sa', 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fn1.itc.cn%2Fimg8%2Fwb%2Frecom%2F2016%2F05%2F10%2F146286696706220328.PNG&refer=http%3A%2F%2Fn1.itc.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646205529&t=f942665181eb9b0685db7a6f59d59975', 'da', 'https://www.taobao.com', '1', NULL, '2022-01-13 09:23:01', NULL, '2022-01-13 09:23:01', 0);

-- ----------------------------
-- Table structure for roydon_tag
-- ----------------------------
DROP TABLE IF EXISTS `roydon_tag`;
CREATE TABLE `roydon_tag`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签名',
  `create_by` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` bigint(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `del_flag` int(0) NULL DEFAULT 0 COMMENT '删除标志（0代表未删除，1代表已删除）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '标签' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roydon_tag
-- ----------------------------
INSERT INTO `roydon_tag` VALUES (1, 'Mybatis', NULL, NULL, NULL, '2022-01-11 09:20:50', 0, 'weqwe');
INSERT INTO `roydon_tag` VALUES (2, 'asdas', NULL, '2022-01-11 09:20:55', NULL, '2022-01-11 09:20:55', 1, 'weqw');
INSERT INTO `roydon_tag` VALUES (3, 'weqw', NULL, '2022-01-11 09:21:07', NULL, '2022-01-11 09:21:07', 1, 'qweqwe');
INSERT INTO `roydon_tag` VALUES (4, 'Java', NULL, '2022-01-13 15:22:43', NULL, '2022-01-13 15:22:43', 0, 'sdad');
INSERT INTO `roydon_tag` VALUES (5, 'WAD', NULL, '2022-01-13 15:22:47', NULL, '2022-01-13 15:22:47', 0, 'ASDAD');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(0) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `is_frame` int(0) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2028 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, 1, 'M', '0', '0', '', 'system', 0, '2021-11-12 10:46:19', 0, NULL, '系统管理目录', '0');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', 1, 'C', '0', '0', 'system:user:list', 'user', 0, '2021-11-12 10:46:19', 1, '2022-07-31 15:47:58', '用户管理菜单', '0');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', 1, 'C', '0', '0', 'system:role:list', 'peoples', 0, '2021-11-12 10:46:19', 0, NULL, '角色管理菜单', '0');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', 1, 'C', '0', '0', 'system:menu:list', 'tree-table', 0, '2021-11-12 10:46:19', 0, NULL, '菜单管理菜单', '0');
INSERT INTO `sys_menu` VALUES (1001, '用户查询', 100, 1, '', '', 1, 'F', '0', '0', 'system:user:query', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1002, '用户新增', 100, 2, '', '', 1, 'F', '0', '0', 'system:user:add', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1003, '用户修改', 100, 3, '', '', 1, 'F', '0', '0', 'system:user:edit', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1004, '用户删除', 100, 4, '', '', 1, 'F', '0', '0', 'system:user:remove', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1005, '用户导出', 100, 5, '', '', 1, 'F', '0', '0', 'system:user:export', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1006, '用户导入', 100, 6, '', '', 1, 'F', '0', '0', 'system:user:import', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1007, '重置密码', 100, 7, '', '', 1, 'F', '0', '0', 'system:user:resetPwd', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1008, '角色查询', 101, 1, '', '', 1, 'F', '0', '0', 'system:role:query', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1009, '角色新增', 101, 2, '', '', 1, 'F', '0', '0', 'system:role:add', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1010, '角色修改', 101, 3, '', '', 1, 'F', '0', '0', 'system:role:edit', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1011, '角色删除', 101, 4, '', '', 1, 'F', '0', '0', 'system:role:remove', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1012, '角色导出', 101, 5, '', '', 1, 'F', '0', '0', 'system:role:export', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1013, '菜单查询', 102, 1, '', '', 1, 'F', '0', '0', 'system:menu:query', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1014, '菜单新增', 102, 2, '', '', 1, 'F', '0', '0', 'system:menu:add', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1015, '菜单修改', 102, 3, '', '', 1, 'F', '0', '0', 'system:menu:edit', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (1016, '菜单删除', 102, 4, '', '', 1, 'F', '0', '0', 'system:menu:remove', '#', 0, '2021-11-12 10:46:19', 0, NULL, '', '0');
INSERT INTO `sys_menu` VALUES (2017, '内容管理', 0, 4, 'content', NULL, 1, 'M', '0', '0', NULL, 'table', NULL, '2022-01-08 02:44:38', 1, '2022-07-31 12:34:23', '', '0');
INSERT INTO `sys_menu` VALUES (2018, '分类管理', 2017, 1, 'category', 'content/category/index', 1, 'C', '0', '0', 'content:category:list', 'example', NULL, '2022-01-08 02:51:45', NULL, '2022-01-08 02:51:45', '', '0');
INSERT INTO `sys_menu` VALUES (2019, '文章管理', 2017, 0, 'article', 'content/article/index', 1, 'C', '0', '0', 'content:article:list', 'build', NULL, '2022-01-08 02:53:10', NULL, '2022-01-08 02:53:10', '', '0');
INSERT INTO `sys_menu` VALUES (2021, '标签管理', 2017, 6, 'tag', 'content/tag/index', 1, 'C', '0', '0', 'content:tag:index', 'button', NULL, '2022-01-08 02:55:37', NULL, '2022-01-08 02:55:50', '', '0');
INSERT INTO `sys_menu` VALUES (2022, '友链管理', 2017, 4, 'link', 'content/link/index', 1, 'C', '0', '0', 'content:link:list', '404', NULL, '2022-01-08 02:56:50', NULL, '2022-01-08 02:56:50', '', '0');
INSERT INTO `sys_menu` VALUES (2023, '写博文', 0, 0, 'write', 'content/article/write/index', 1, 'C', '0', '0', 'content:article:writer', 'build', NULL, '2022-01-08 03:39:58', 1, '2022-07-31 22:07:05', '', '0');
INSERT INTO `sys_menu` VALUES (2024, '友链新增', 2022, 0, '', NULL, 1, 'F', '0', '0', 'content:link:add', '#', NULL, '2022-01-16 07:59:17', NULL, '2022-01-16 07:59:17', '', '0');
INSERT INTO `sys_menu` VALUES (2025, '友链修改', 2022, 1, '', NULL, 1, 'F', '0', '0', 'content:link:edit', '#', NULL, '2022-01-16 07:59:44', NULL, '2022-01-16 07:59:44', '', '0');
INSERT INTO `sys_menu` VALUES (2026, '友链删除', 2022, 1, '', NULL, 1, 'F', '0', '0', 'content:link:remove', '#', NULL, '2022-01-16 08:00:05', NULL, '2022-01-16 08:00:05', '', '0');
INSERT INTO `sys_menu` VALUES (2027, '友链查询', 2022, 2, '', NULL, 1, 'F', '0', '0', 'content:link:query', '#', NULL, '2022-01-16 08:04:09', NULL, '2022-01-16 08:04:09', '', '0');
INSERT INTO `sys_menu` VALUES (2028, '导出分类', 2018, 1, '', NULL, 1, 'F', '0', '0', 'content:category:export', '#', NULL, '2022-01-21 07:06:59', NULL, '2022-01-21 07:06:59', '', '0');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(0) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '0', '0', 0, '2021-11-12 10:46:19', 0, NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '0', '0', 0, '2021-11-12 10:46:19', 0, '2022-01-01 22:32:58', '普通角色');
INSERT INTO `sys_role` VALUES (11, '嘎嘎嘎', 'aggag', 5, '0', '0', NULL, '2022-01-06 14:07:40', NULL, '2022-01-07 03:48:48', '嘎嘎嘎');
INSERT INTO `sys_role` VALUES (12, '友链审核员', 'link', 1, '0', '0', NULL, '2022-01-16 06:49:30', NULL, '2022-01-16 08:05:09', NULL);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(0) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (0, 0);
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 2000);
INSERT INTO `sys_role_menu` VALUES (3, 2);
INSERT INTO `sys_role_menu` VALUES (3, 3);
INSERT INTO `sys_role_menu` VALUES (3, 4);
INSERT INTO `sys_role_menu` VALUES (3, 100);
INSERT INTO `sys_role_menu` VALUES (3, 101);
INSERT INTO `sys_role_menu` VALUES (3, 103);
INSERT INTO `sys_role_menu` VALUES (3, 104);
INSERT INTO `sys_role_menu` VALUES (3, 105);
INSERT INTO `sys_role_menu` VALUES (3, 106);
INSERT INTO `sys_role_menu` VALUES (3, 107);
INSERT INTO `sys_role_menu` VALUES (3, 108);
INSERT INTO `sys_role_menu` VALUES (3, 109);
INSERT INTO `sys_role_menu` VALUES (3, 110);
INSERT INTO `sys_role_menu` VALUES (3, 111);
INSERT INTO `sys_role_menu` VALUES (3, 112);
INSERT INTO `sys_role_menu` VALUES (3, 113);
INSERT INTO `sys_role_menu` VALUES (3, 114);
INSERT INTO `sys_role_menu` VALUES (3, 115);
INSERT INTO `sys_role_menu` VALUES (3, 116);
INSERT INTO `sys_role_menu` VALUES (3, 500);
INSERT INTO `sys_role_menu` VALUES (3, 501);
INSERT INTO `sys_role_menu` VALUES (3, 1001);
INSERT INTO `sys_role_menu` VALUES (3, 1002);
INSERT INTO `sys_role_menu` VALUES (3, 1003);
INSERT INTO `sys_role_menu` VALUES (3, 1004);
INSERT INTO `sys_role_menu` VALUES (3, 1005);
INSERT INTO `sys_role_menu` VALUES (3, 1006);
INSERT INTO `sys_role_menu` VALUES (3, 1007);
INSERT INTO `sys_role_menu` VALUES (3, 1008);
INSERT INTO `sys_role_menu` VALUES (3, 1009);
INSERT INTO `sys_role_menu` VALUES (3, 1010);
INSERT INTO `sys_role_menu` VALUES (3, 1011);
INSERT INTO `sys_role_menu` VALUES (3, 1012);
INSERT INTO `sys_role_menu` VALUES (3, 1017);
INSERT INTO `sys_role_menu` VALUES (3, 1018);
INSERT INTO `sys_role_menu` VALUES (3, 1019);
INSERT INTO `sys_role_menu` VALUES (3, 1020);
INSERT INTO `sys_role_menu` VALUES (3, 1021);
INSERT INTO `sys_role_menu` VALUES (3, 1022);
INSERT INTO `sys_role_menu` VALUES (3, 1023);
INSERT INTO `sys_role_menu` VALUES (3, 1024);
INSERT INTO `sys_role_menu` VALUES (3, 1025);
INSERT INTO `sys_role_menu` VALUES (3, 1026);
INSERT INTO `sys_role_menu` VALUES (3, 1027);
INSERT INTO `sys_role_menu` VALUES (3, 1028);
INSERT INTO `sys_role_menu` VALUES (3, 1029);
INSERT INTO `sys_role_menu` VALUES (3, 1030);
INSERT INTO `sys_role_menu` VALUES (3, 1031);
INSERT INTO `sys_role_menu` VALUES (3, 1032);
INSERT INTO `sys_role_menu` VALUES (3, 1033);
INSERT INTO `sys_role_menu` VALUES (3, 1034);
INSERT INTO `sys_role_menu` VALUES (3, 1035);
INSERT INTO `sys_role_menu` VALUES (3, 1036);
INSERT INTO `sys_role_menu` VALUES (3, 1037);
INSERT INTO `sys_role_menu` VALUES (3, 1038);
INSERT INTO `sys_role_menu` VALUES (3, 1039);
INSERT INTO `sys_role_menu` VALUES (3, 1040);
INSERT INTO `sys_role_menu` VALUES (3, 1041);
INSERT INTO `sys_role_menu` VALUES (3, 1042);
INSERT INTO `sys_role_menu` VALUES (3, 1043);
INSERT INTO `sys_role_menu` VALUES (3, 1044);
INSERT INTO `sys_role_menu` VALUES (3, 1045);
INSERT INTO `sys_role_menu` VALUES (3, 1046);
INSERT INTO `sys_role_menu` VALUES (3, 1047);
INSERT INTO `sys_role_menu` VALUES (3, 1048);
INSERT INTO `sys_role_menu` VALUES (3, 1049);
INSERT INTO `sys_role_menu` VALUES (3, 1050);
INSERT INTO `sys_role_menu` VALUES (3, 1051);
INSERT INTO `sys_role_menu` VALUES (3, 1052);
INSERT INTO `sys_role_menu` VALUES (3, 1053);
INSERT INTO `sys_role_menu` VALUES (3, 1054);
INSERT INTO `sys_role_menu` VALUES (3, 1055);
INSERT INTO `sys_role_menu` VALUES (3, 1056);
INSERT INTO `sys_role_menu` VALUES (3, 1057);
INSERT INTO `sys_role_menu` VALUES (3, 1058);
INSERT INTO `sys_role_menu` VALUES (3, 1059);
INSERT INTO `sys_role_menu` VALUES (3, 1060);
INSERT INTO `sys_role_menu` VALUES (3, 2000);
INSERT INTO `sys_role_menu` VALUES (11, 1);
INSERT INTO `sys_role_menu` VALUES (11, 100);
INSERT INTO `sys_role_menu` VALUES (11, 101);
INSERT INTO `sys_role_menu` VALUES (11, 102);
INSERT INTO `sys_role_menu` VALUES (11, 103);
INSERT INTO `sys_role_menu` VALUES (11, 104);
INSERT INTO `sys_role_menu` VALUES (11, 105);
INSERT INTO `sys_role_menu` VALUES (11, 106);
INSERT INTO `sys_role_menu` VALUES (11, 107);
INSERT INTO `sys_role_menu` VALUES (11, 108);
INSERT INTO `sys_role_menu` VALUES (11, 500);
INSERT INTO `sys_role_menu` VALUES (11, 501);
INSERT INTO `sys_role_menu` VALUES (11, 1001);
INSERT INTO `sys_role_menu` VALUES (11, 1002);
INSERT INTO `sys_role_menu` VALUES (11, 1003);
INSERT INTO `sys_role_menu` VALUES (11, 1004);
INSERT INTO `sys_role_menu` VALUES (11, 1005);
INSERT INTO `sys_role_menu` VALUES (11, 1006);
INSERT INTO `sys_role_menu` VALUES (11, 1007);
INSERT INTO `sys_role_menu` VALUES (11, 1008);
INSERT INTO `sys_role_menu` VALUES (11, 1009);
INSERT INTO `sys_role_menu` VALUES (11, 1010);
INSERT INTO `sys_role_menu` VALUES (11, 1011);
INSERT INTO `sys_role_menu` VALUES (11, 1012);
INSERT INTO `sys_role_menu` VALUES (11, 1013);
INSERT INTO `sys_role_menu` VALUES (11, 1014);
INSERT INTO `sys_role_menu` VALUES (11, 1015);
INSERT INTO `sys_role_menu` VALUES (11, 1016);
INSERT INTO `sys_role_menu` VALUES (11, 1017);
INSERT INTO `sys_role_menu` VALUES (11, 1018);
INSERT INTO `sys_role_menu` VALUES (11, 1019);
INSERT INTO `sys_role_menu` VALUES (11, 1020);
INSERT INTO `sys_role_menu` VALUES (11, 1021);
INSERT INTO `sys_role_menu` VALUES (11, 1022);
INSERT INTO `sys_role_menu` VALUES (11, 1023);
INSERT INTO `sys_role_menu` VALUES (11, 1024);
INSERT INTO `sys_role_menu` VALUES (11, 1025);
INSERT INTO `sys_role_menu` VALUES (11, 1026);
INSERT INTO `sys_role_menu` VALUES (11, 1027);
INSERT INTO `sys_role_menu` VALUES (11, 1028);
INSERT INTO `sys_role_menu` VALUES (11, 1029);
INSERT INTO `sys_role_menu` VALUES (11, 1030);
INSERT INTO `sys_role_menu` VALUES (11, 1031);
INSERT INTO `sys_role_menu` VALUES (11, 1032);
INSERT INTO `sys_role_menu` VALUES (11, 1033);
INSERT INTO `sys_role_menu` VALUES (11, 1034);
INSERT INTO `sys_role_menu` VALUES (11, 1035);
INSERT INTO `sys_role_menu` VALUES (11, 1036);
INSERT INTO `sys_role_menu` VALUES (11, 1037);
INSERT INTO `sys_role_menu` VALUES (11, 1038);
INSERT INTO `sys_role_menu` VALUES (11, 1039);
INSERT INTO `sys_role_menu` VALUES (11, 1040);
INSERT INTO `sys_role_menu` VALUES (11, 1041);
INSERT INTO `sys_role_menu` VALUES (11, 1042);
INSERT INTO `sys_role_menu` VALUES (11, 1043);
INSERT INTO `sys_role_menu` VALUES (11, 1044);
INSERT INTO `sys_role_menu` VALUES (11, 1045);
INSERT INTO `sys_role_menu` VALUES (11, 2000);
INSERT INTO `sys_role_menu` VALUES (11, 2003);
INSERT INTO `sys_role_menu` VALUES (11, 2004);
INSERT INTO `sys_role_menu` VALUES (11, 2005);
INSERT INTO `sys_role_menu` VALUES (11, 2006);
INSERT INTO `sys_role_menu` VALUES (11, 2007);
INSERT INTO `sys_role_menu` VALUES (11, 2008);
INSERT INTO `sys_role_menu` VALUES (11, 2009);
INSERT INTO `sys_role_menu` VALUES (11, 2010);
INSERT INTO `sys_role_menu` VALUES (11, 2011);
INSERT INTO `sys_role_menu` VALUES (11, 2012);
INSERT INTO `sys_role_menu` VALUES (11, 2013);
INSERT INTO `sys_role_menu` VALUES (11, 2014);
INSERT INTO `sys_role_menu` VALUES (12, 2017);
INSERT INTO `sys_role_menu` VALUES (12, 2022);
INSERT INTO `sys_role_menu` VALUES (12, 2024);
INSERT INTO `sys_role_menu` VALUES (12, 2025);
INSERT INTO `sys_role_menu` VALUES (12, 2026);
INSERT INTO `sys_role_menu` VALUES (12, 2027);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NULL' COMMENT '用户名',
  `nick_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NULL' COMMENT '昵称',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NULL' COMMENT '密码',
  `type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户类型：0代表普通用户，1代表管理员',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone_number` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户性别（0男，1女，2未知）',
  `avatar` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `create_by` bigint(0) NULL DEFAULT NULL COMMENT '创建人的用户id',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `del_flag` int(0) NULL DEFAULT 0 COMMENT '删除标志（0代表未删除，1代表已删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'roydon', 'roydon233', '$2a$10$.C5nLKwbb4VW3qSuqsaykuAj9mKa4XQaSfL.dOmmOr4L2fERgLgtG', '1', '0', '23412332@qq.com', '18888888888', '1', 'https://img1.imgtp.com/2022/09/01/w4nMeVBG.jpg', NULL, '2022-01-05 09:01:56', 1, '2022-01-30 15:37:03', 0);
INSERT INTO `sys_user` VALUES (18, 'weixin', 'weixin', '$2a$10$y3k3fnMZsBNihsVLXWfI8uMNueVXBI08k.LzWYaKsW8CW7xXy18wC', '0', '0', 'weixin@qq.com', NULL, NULL, 'https://img1.imgtp.com/2022/09/01/w4nMeVBG.jpg', -1, '2022-01-30 17:18:44', -1, '2022-01-30 17:18:44', 0);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (5, 2);
INSERT INTO `sys_user_role` VALUES (6, 12);

SET FOREIGN_KEY_CHECKS = 1;
