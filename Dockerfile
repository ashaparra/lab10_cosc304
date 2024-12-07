FROM tomcat:9-jdk11

EXPOSE 8080

# Copy the entire WebContent folder to the ROOT application
COPY ./WebContent/ /usr/local/tomcat/webapps/ROOT/

# Copy the SQL Server JDBC driver to Tomcat lib directory
COPY ./WebContent/WEB-INF/lib/mssql-jdbc-11.2.0.jre11.jar /usr/local/tomcat/lib/mssql-jdbc-11.2.0.jre11.jar

# Debug: List files to verify they are copied correctly
RUN ls -l /usr/local/tomcat/webapps/ROOT/
RUN ls -l /usr/local/tomcat/lib/

CMD ["catalina.sh", "run"]