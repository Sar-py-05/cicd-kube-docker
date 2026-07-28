# Runtime image
FROM tomcat:9.0-jdk21-temurin

# Remove default applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR built by Jenkins
COPY target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh","run"]
