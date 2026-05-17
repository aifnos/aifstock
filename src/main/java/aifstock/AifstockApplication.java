package aifstock;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

/**
 * Spring Boot 应用启动入口，负责加载 aifstock 所有模块。
 */
@SpringBootApplication
@ConfigurationPropertiesScan("aifstock")
public class AifstockApplication {

    public static void main(String[] args) {
        SpringApplication.run(AifstockApplication.class, args);
    }

}
