#!/bin/bash

function die {
    echo $1
    exit 10
}

DSPACE_SRC=/home/user/dspace-src
DSPACE_INSTALL=/home/user/dspace
LOCAL_CFG=/projects/DSpace-codenvy/CodenvyConfig/local.cfg
MVN_TARGET=package
#MVN_TARGET="package -Dmirage2.on=true"
DSPACE_VER=6

START_TOMCAT=${1:-0}
TOMCAT=/home/user/tomcat8/bin/catalina.sh

echo $START_TOMCAT
exit

cd ${DSPACE_SRC}/DSpace || die "src dir ${DSPACE_SRC} does not exist"
cp ${LOCAL_CFG} . || die "error copying local: ${LOCAL_CFG}"
mvn ${MVN_TARGET} || die "maven failed"
cd dspace/target/dspace-installer || die "install dir not found"
cp /projects/DSpace-codenvy/overlay/* webapps || die "could not copy webapps overlay"

${TOMCAT} stop

ant update

if [ $START_TOMCAT != 0 ]
then
  ${TOMCAT} stop
fi
