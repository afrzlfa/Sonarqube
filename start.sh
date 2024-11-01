#!/bin/bash

echo "[*] [Running]"

mkdir -p sonarqube_postgres sonarqube

cat <<EOF > sonarqube_postgres/Dockerfile
FROM postgres:latest

ENV POSTGRES_USER=sonar
ENV POSTGRES_PASSWORD=sonar
ENV POSTGRES_DB=sonar

EXPOSE 5432
EOF

cat <<EOF > sonarqube/Dockerfile
FROM sonarqube:latest

ENV SONAR_JDBC_URL=jdbc:postgresql://sonar-postgres:5432/sonar
ENV SONAR_JDBC_USERNAME=sonar
ENV SONAR_JDBC_PASSWORD=sonar

EXPOSE 9000
EOF

if [ "$(docker ps -aq -f name=sonar-postgres)" ]; then
    docker stop sonar-postgres
    docker rm sonar-postgres
fi

if [ "$(docker ps -aq -f name=sonarqube)" ]; then
    docker stop sonarqube
    docker rm sonarqube
fi

if [ "$(docker images -q sonar-postgres 2> /dev/null)" ]; then
    docker rmi sonar-postgres
fi

if [ "$(docker images -q sonarqube 2> /dev/null)" ]; then
    docker rmi sonarqube
fi

docker build -t sonar-postgres ./sonarqube_postgres
docker run -d --name sonar-postgres -p 5432:5432 sonar-postgres

until [ "$(docker logs sonar-postgres 2>&1 | grep 'database system is ready to accept connections')" ]; do
    sleep 1
done

docker build -t sonarqube ./sonarqube
docker run -d --name sonarqube -p 9000:9000 --link sonar-postgres:postgres sonarqube

echo "[+] [SonarQube URL: http://localhost:9000]"
echo "[+] [Username: admin]"
echo "[+] [Password: admin]"
