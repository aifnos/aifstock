package aifstock.admin.service;

import aifstock.admin.dto.RolePermissionUpsertRequest;
import aifstock.admin.vo.PermissionDefinitionVO;
import aifstock.admin.vo.RoleSummaryVO;

import java.util.List;

/**
 * 角色权限配置服务。
 */
public interface RoleAccessManageService {

    /** 查询全部角色及其权限 */
    List<RoleSummaryVO> listRoles();

    /** 保存/替换指定角色的权限 */
    void saveRolePermissions(RolePermissionUpsertRequest request);

    /**
     * 删除指定角色权限配置。
     *
     * @param roleCode 角色编码
     */
    void deleteRole(String roleCode);

    /** 返回可分配的权限点目录 */
    List<PermissionDefinitionVO> permissionCatalog();
}
