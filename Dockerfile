FROM tomcat:10.1-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY FoodDelivery.war /usr/local/tomcat/webapps/ROOT.war

RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml

EXPOSE 10000

CMD ["catalina.sh", "run"]
