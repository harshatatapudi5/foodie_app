
FROM tomcat:10.1-jdk21-temurin

WORKDIR /app

COPY src/main/java/ /app/src/main/java/
COPY src/main/webapp/ /app/src/main/webapp/

RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    && cp -r /app/src/main/webapp/. /usr/local/tomcat/webapps/ROOT/ \
    && find /app/src/main/java -name "*.java" > /tmp/sources.txt \
    && javac -encoding UTF-8 \
       -cp "/usr/local/tomcat/lib/*:/app/src/main/webapp/WEB-INF/lib/*" \
       -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
       @/tmp/sources.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]

