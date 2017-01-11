<configuration>
    <property name="LOG_PATH" value="${r"$"}{LOG_PATH:-${r"$"}{LOG_TEMP:-${r"$"}{java.io.tmpdir:-/tmp}}}" />
    <conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter" />
    <conversionRule conversionWord="wex" converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter" />
    <conversionRule conversionWord="wEx" converterClass="org.springframework.boot.logging.logback.ExtendedWhitespaceThrowableProxyConverter" />
    <property name="CONSOLE_LOG_PATTERN" value="${r"$"}{CONSOLE_LOG_PATTERN:-%clr(%d{yyyy-MM-dd HH:mm:ss.SSS}){faint} %clr(${r"$"}{LOG_LEVEL_PATTERN:-%5p}) %clr(${r"$"}{PID:- }){magenta} %clr(---){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n${r"$"}{LOG_EXCEPTION_CONVERSION_WORD:-%wEx}}"/>
    <property name="FILE_LOG_PATTERN" value="%d{yyyy-MM-dd HH:mm:ss.SSS} ${r"$"}{LOG_LEVEL_PATTERN:-%5p} ${r"$"}{PID:- } --- [%t] %-40.40logger{39} : %m%n${r"$"}{LOG_EXCEPTION_CONVERSION_WORD:-%wEx}"/>

    <appender name="DEBUG_LEVEL_REMAPPER" class="org.springframework.boot.logging.logback.LevelRemappingAppender">
        <destinationLogger>org.springframework.boot</destinationLogger>
    </appender>
    <jmxConfigurator/>
    <logger name="org.apache.catalina.startup.DigesterFactory" level="ERROR"/>
    <logger name="org.apache.catalina.util.LifecycleBase" level="ERROR"/>
    <logger name="org.apache.coyote.http11.Http11NioProtocol" level="WARN"/>
    <logger name="org.apache.sshd.common.util.SecurityUtils" level="WARN"/>
    <logger name="org.apache.tomcat.util.net.NioSelectorPool" level="WARN"/>
    <logger name="org.crsh.plugin" level="WARN"/>
    <logger name="org.crsh.ssh" level="WARN"/>
    <logger name="org.eclipse.jetty.util.component.AbstractLifeCycle" level="ERROR"/>
    <logger name="org.hibernate.validator.internal.util.Version" level="WARN"/>
    <logger name="org.springframework.boot.actuate.autoconfigure.CrshAutoConfiguration" level="WARN"/>
    <logger name="org.springframework.boot.actuate.endpoint.jmx" additivity="false">
        <appender-ref ref="DEBUG_LEVEL_REMAPPER"/>
    </logger>
    <logger name="org.thymeleaf" additivity="false">
        <appender-ref ref="DEBUG_LEVEL_REMAPPER"/>
    </logger>



    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>${r"$"}{CONSOLE_LOG_PATTERN}</pattern>
            <charset>utf8</charset>
        </encoder>
    </appender>

    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <encoder>
            <Pattern>${r"$"}{FILE_LOG_PATTERN}</Pattern>
            <charset>utf8</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${r"$"}{LOG_FILE}/common/%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="ERROR_LOG_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <encoder>
            <Pattern>${r"$"}{FILE_LOG_PATTERN}</Pattern>
            <charset>utf8</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${r"$"}{LOG_FILE}/error/%d{yyyy-MM-dd}.error.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <filter class="ch.qos.logback.classic.filter.LevelFilter"><!-- 只打印错误日志 -->
            <level>ERROR</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>

    <root level="INFO">
        <appender-ref ref="CONSOLE" />
        <appender-ref ref="FILE" />
        <appender-ref ref="ERROR_LOG_FILE" />
    </root>

</configuration>