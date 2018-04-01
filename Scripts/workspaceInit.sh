#!/bin/bash

function die {
    echo $1
    exit 10
}

SCRIPTS=/projects/DSpace-codenvy/Scripts
DSPACE_SRC=/home/user/dspace-src/DSpace
SRCROOT=$(dirname $DSPACE_SRC)
DSPACE_INSTALL=/home/user/dspace
BASE_BRANCH=dspace-6_x
TOMCAT=/home/user/tomcat8/bin/catalina.sh
LOAD_DIR=/project/DSpace-codenvy/TestData

if [ ! -e ${DSPACE_SRC} ]
then
  if [ ! -e $SRCROOT ]
  then 
    mkdir -p ${SRCROOT} || die "cannot mkdir ${SRCROOT}"
  fi
  
  cd ${SRCROOT}
  git clone https://github.com/DSpace/DSpace.git || die "cannot clone DSpace here"
  cd $DSPACE_SRC
  git checkout $BASE_BRANCH || die "cannot checkout $BASE_BRANCH"
fi

${SCRIPTS}/build.sh || die "build failed"

${DSPACE_INSTALL}/bin/dspace create-administrator -e test@test.edu -f Admin -l User -p admin -c en || die "create admin failed"

if [ -e $LOAD_DIR ]
then
  cd $LOAD_DIR
  for file in COMM* COLL* ITEM*; 
  do 
  ${DSPACE_INSTALL}/bin/dspace packager -r -t AIP -e test@test.edu -f -u $file
  done
fi

${TOMCAT} start

