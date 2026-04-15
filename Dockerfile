FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file
COPY web/target/time-tracker-web-0.5.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
