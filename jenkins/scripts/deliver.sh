#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
# Sanitize the NAME variable to remove unwanted characters and escape sequences
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name | sed -e 's/\x1b\[[0-9;]*m//g' | tr -d '\r' | tr -d '\n' | sed 's/[^a-zA-Z0-9._-]//g')
set +x

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
# Sanitize the VERSION variable to remove unwanted characters and escape sequences
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version | sed -e 's/\x1b\[[0-9;]*m//g' | tr -d '\r' | tr -d '\n' | sed 's/[^a-zA-Z0-9._-]//g')
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x
# Verify if the JAR file exists before running it
if [ ! -f target/${NAME}-${VERSION}.jar ]; then
    echo "Error: JAR file target/${NAME}-${VERSION}.jar not found!"
    exit 1
fi
java -jar target/${NAME}-${VERSION}.jar
