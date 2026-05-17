package aifstock.common.security;

/**
 * 后台功能所需的资源-动作权限点定义。
 */
public enum AdminPermission {

    // 文件上传
    FILE_UPLOAD("FILE", "UPLOAD", "文件-上传"),

    // 管理员账户管理
    ADMIN_ACCOUNT_CREATE("ADMIN_ACCOUNT", "CREATE", "管理员-新增"),
    ADMIN_ACCOUNT_UPDATE("ADMIN_ACCOUNT", "UPDATE", "管理员-修改/分配角色"),
    ADMIN_ACCOUNT_DELETE("ADMIN_ACCOUNT", "DELETE", "管理员-删除"),
    ADMIN_ACCOUNT_READ("ADMIN_ACCOUNT", "READ", "管理员-查看"),

    // 角色权限管理
    ROLE_ACCESS_READ("ROLE_ACCESS", "READ", "角色权限-查看"),
    ROLE_ACCESS_UPDATE("ROLE_ACCESS", "UPDATE", "角色权限-配置"),

    // 菜单管理
    MENU_CREATE("MENU", "CREATE", "菜单-新增"),
    MENU_UPDATE("MENU", "UPDATE", "菜单-修改"),
    MENU_DELETE("MENU", "DELETE", "菜单-删除"),
    MENU_READ("MENU", "READ", "菜单-查看");

    private final String resourceKey;
    private final String action;
    private final String description;

    AdminPermission(String resourceKey, String action, String description) {
        this.resourceKey = resourceKey;
        this.action = action;
        this.description = description;
    }

    /**
     * 资源键。
     */
    public String resourceKey() {
        return resourceKey;
    }

    /**
     * 动作键。
     */
    public String action() {
        return action;
    }

    /**
     * 拼接后的权限键，便于展示。
     */
    public String asKey() {
        return resourceKey + ":" + action;
    }

    /**
     * 权限点描述信息。
     */
    public String description() {
        return description;
    }
}
