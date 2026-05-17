# aifstock

aifstock 现在已瘦身为后台公共能力服务，只保留管理端登录、管理员账号、RBAC 权限、菜单/按钮权限、文件上传、JWT 安全认证、统一返回和全局异常处理。

## 技术栈

- Java 21
- Spring Boot 3.5.7
- Spring Web
- Spring Security + JWT
- MyBatis + XML Mapper
- PageHelper
- MySQL
- Redis
- Validation
- Lombok

## 保留功能

- 管理端认证：管理员登录、当前管理员信息、动态菜单。
- 管理员账号：管理员分页、详情、新增、编辑、删除。
- RBAC 权限：角色权限配置、权限目录、角色菜单分配、角色按钮权限分配。
- 菜单管理：菜单树、新增、编辑、删除、菜单按钮权限维护。
- 文件上传：认证用户上传文件，本地静态文件访问。
- 公共基础：JWT 无状态认证、CORS、统一响应、全局异常、密码加密、Redis 配置。

## 目录结构

```text
.
├── pom.xml
├── src
│   └── main
│       ├── java/aifstock
│       │   ├── admin       # 管理员账号、RBAC、菜单管理
│       │   ├── auth        # 管理端登录、管理员信息、动态菜单
│       │   ├── common      # 通用返回、异常、安全、配置、工具类
│       │   └── file        # 文件上传与本地存储
│       └── resources
│           ├── application.yml
│           ├── mapper      # MyBatis XML Mapper
│           └── logback-spring*.xml
└── web                 # 当前为空，未发现独立前端工程文件
```

## 环境要求

- JDK 21+
- Maven 3.9+
- MySQL 8.x 或兼容版本
- Redis 6.x+

当前仓库未包含数据库建表脚本。运行前需要准备以下表：

- `t_admin`
- `t_menu`
- `t_menu_permission`
- `t_role_access`
- `t_role_menu`
- `t_role_menu_permission`

## 本地启动

1. 创建数据库。

```sql
CREATE DATABASE aifstock DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 修改配置。

编辑 `src/main/resources/application.yml`，按本地环境调整 MySQL、Redis、JWT 和文件上传配置。

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/aifstock?useSSL=false&serverTimezone=UTC&characterEncoding=utf8
    username: root
    password: 123456
  data:
    redis:
      host: localhost
      port: 6379

security:
  jwt:
    secret: aifstock-server-key-test-aifstock-server-key-test

file:
  upload-dir: ./uploads
  base-url: http://localhost:8080/files
```

3. 启动 MySQL 与 Redis。

4. 启动应用。

```bash
mvn spring-boot:run
```

应用默认监听 `8080` 端口。

## 构建与测试

```bash
# 编译并打包
mvn clean package

# 跳过测试打包
mvn -DskipTests package

# 运行测试
mvn test
```

## API 概览

所有接口统一返回 `Result<T>` 格式：

```json
{
  "code": 200,
  "msg": "成功",
  "data": {}
}
```

保留接口：

- `POST /admin/auth/login`：管理员登录。
- `GET /admin/auth/info`：当前管理员信息。
- `GET /admin/auth/menus`：当前管理员动态菜单。
- `/admin/rbac/admins/**`：管理员账号管理。
- `/admin/rbac/roles`：角色列表。
- `/admin/rbac/permissions/catalog`：权限目录。
- `/admin/rbac/roles/**`：角色菜单与按钮权限分配。
- `/admin/rbac/menus/**`：菜单与菜单按钮权限管理。
- `POST /file/upload`：认证用户文件上传。
- `/files/**`：本地上传文件访问路径。

### 认证方式

登录成功后接口返回 token，后续受保护接口需要在请求头中携带：

```http
Authorization: Bearer <token>
```

当前仅放行 `POST /admin/auth/login`、`/error`、`/files/**` 和 `OPTIONS` 预检请求，其余接口默认需要认证。

## 文件上传

文件上传接口：

```http
POST /file/upload
Content-Type: multipart/form-data
Authorization: Bearer <token>
```

参数：

- `file`：上传文件。
- `bizTag`：可选，业务目录标签。

默认允许类型包括 `jpg`、`jpeg`、`png`、`gif`、`pdf`、`mp4`，默认上传目录为 `./uploads`。

## 开发提示

- Mapper XML 仅保留 `AdminMapper.xml`、`MenuMapper.xml`、`RoleAccessMapper.xml`、`RoleMenuMapper.xml`。
- 统一返回类位于 `common/result/Result.java`，响应码位于 `common/result/ResultCode.java`。
- JWT、安全放行规则与 CORS 配置位于 `common/security/SecurityConfig.java`。
- 文件存储配置位于 `file/config/FileStorageProperties.java`，当前默认使用本地存储。
- 项目不再支持门户用户 token，JWT 主体只保留 `ADMIN` 与 `SUPER_ADMIN`。

## 注意事项

- 生产环境请务必修改默认数据库账号、JWT 密钥和文件访问域名。
- 当前配置文件中 `spring.profiles.active` 默认为 `dev`。
- 仓库中未发现前端工程依赖文件，`web` 目录当前为空。
- 仓库中未发现数据库初始化脚本，部署前需要补充 schema 与初始化数据。
