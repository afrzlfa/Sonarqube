#!/bin/bash

echo "[*] [Running]"

mkdir -p sonarqube_postgres sonarqube

cat <<EOF > sonarqube_postgres/Dockerfile
FROM postgres:latest

ENV POSTGRES_USER=sonar
ENV POSTGRES_PASSWORD=sonar
ENV POSTGRES_DB=sonar

EXPOSE 5432

VOLUME /var/lib/postgresql/data
EOF

cat <<EOF > sonarqube/Dockerfile
FROM sonarqube:latest

ENV SONAR_JDBC_URL=jdbc:postgresql://postgres-sonar:5432/sonar
ENV SONAR_JDBC_USERNAME=sonar
ENV SONAR_JDBC_PASSWORD=sonar

EXPOSE 9000
EOF

docker build -t my-postgres ./sonarqube_postgres
docker run -d --name postgres-sonar -p 5432:5432 my-postgres

docker build -t my-sonarqube ./sonarqube
docker run -d --name sonarqube -p 9000:9000 --link postgres-sonar:postgres my-sonarqube

echo "[+] [SonarQube URL: http://localhost:9000]"
