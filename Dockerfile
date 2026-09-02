# syntax=docker/dockerfile:1
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

RUN useradd --system --home /app --shell /usr/sbin/nologin gunbound \
    && mkdir -p /app/config /app/logs \
    && chown -R gunbound:gunbound /app

COPY --chown=gunbound:gunbound target/gunbound-server.jar /app/gunbound-server.jar
COPY --chown=gunbound:gunbound config.properties.example /app/config/config.properties

USER gunbound

EXPOSE 8372/tcp 8360/tcp 8352/tcp 8381/udp

ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxRAMPercentage=75"

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/gunbound-server.jar"]
