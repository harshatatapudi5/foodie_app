
FROM tomcat:10.1-jdk21-temurin

COPY src/main/webapp/ /usr/local/tomcat/webapps/ROOT/
COPY src/main/java/ /tmp/java/

EXPOSE 8080

CMD ["catalina.sh", "run"]
