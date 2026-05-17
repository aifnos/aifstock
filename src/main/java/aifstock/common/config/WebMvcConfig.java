package aifstock.common.config;

import aifstock.file.config.FileStorageProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.util.StringUtils;

/**
 * Web MVC 配置，注册上传文件的静态资源访问路径。
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private final FileStorageProperties fileStorageProperties;

    public WebMvcConfig(FileStorageProperties fileStorageProperties) {
        this.fileStorageProperties = fileStorageProperties;
    }

    /**
     * 静态资源映射，将上传目录映射为可访问的 HTTP 路径
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        if (fileStorageProperties == null || !StringUtils.hasText(fileStorageProperties.getUploadDir())) {
            return;
        }
        String accessPattern = fileStorageProperties.getAccessPattern();
        String uploadDir = fileStorageProperties.getUploadDir();
        if (!accessPattern.endsWith("**")) {
            accessPattern = accessPattern.endsWith("/") ? accessPattern + "**" : accessPattern + "/**";
        }
        String location = uploadDir.endsWith("/") ? uploadDir : uploadDir + "/";
        registry.addResourceHandler(accessPattern)
                .addResourceLocations("file:" + location);
    }
}
