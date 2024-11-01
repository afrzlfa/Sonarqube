FROM sonarqube:latest

ENV SONAR_JDBC_URL=jdbc:postgresql://sonar-postgres:5432/sonar
ENV SONAR_JDBC_USERNAME=sonar
ENV SONAR_JDBC_PASSWORD=sonar

EXPOSE 9000

VOLUME /opt/sonarqube/data
VOLUME /opt/sonarqube/extensions
