
#!/usr/bin/env bash
set -euo pipefail

while IFS=: read -r service class port; do

  base="services/${service}-service"
  package="com.flashtix.${service}"
  java_dir="$base/src/main/java/com/flashtix/$service"

  mkdir -p "$java_dir/api"
  mkdir -p "$base/src/main/resources"

  cat > "$base/pom.xml" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>com.flashtix</groupId>
        <artifactId>flashtix-x</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <relativePath>../../pom.xml</relativePath>
    </parent>

    <artifactId>${service}-service</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-webmvc</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOF

  cat > "$java_dir/${class}ServiceApplication.java" <<EOF
package ${package};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ${class}ServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(
            ${class}ServiceApplication.class,
            args
        );
    }
}
EOF

  cat > "$java_dir/api/PingController.java" <<EOF
package ${package}.api;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PingController {

    @GetMapping("/internal/ping")
    public Map<String, String> ping() {
        return Map.of(
            "service", "${service}-service",
            "status", "UP"
        );
    }
}
EOF

  cat > "$base/src/main/resources/application.yml" <<EOF
spring:
  application:
    name: ${service}-service

server:
  port: ${port}

management:
  endpoints:
    web:
      exposure:
        include: health,info
EOF

  echo "Created ${service}-service on port ${port}"

done <<EOF
booking:Booking:8082
payment:Payment:8083
notification:Notification:8084
EOF
