#!/bin/bash
#aws s3 cp <Path to s3> ${T_DIR}/test-plan.jmx

S3_folder=$1
echo "downloading jmx files from s3"
aws s3 sync $S3_folder test/trivial

export T_DIR=test/trivial

# Reporting dir: start fresh
export R_DIR=${T_DIR}/report
rm -rf ${R_DIR} > /dev/null 2>&1
mkdir -p ${R_DIR}

echo "new directory created"


/bin/rm -f ${T_DIR}/test-plan.jtl ${T_DIR}/jmeter.log  > /dev/null 2>&1

echo "old logs removed"


#./run.sh -Dlog_level.jmeter=DEBUG \
#	-JTARGET_HOST=${TARGET_HOST} -JTARGET_PORT=${TARGET_PORT} \
#	-JTARGET_PATH=${TARGET_PATH} -JTARGET_KEYWORD=${TARGET_KEYWORD} \
#	-n -t ${T_DIR}/test-plan.jmx -l ${T_DIR}/test-plan.jtl -j ${T_DIR}/jmeter.log \
#	-e -o ${R_DIR}

echo "starting comtainer"
./run.sh -Dlog_level.jmeter=DEBUG \
	-n -t ${T_DIR}/test-plan.jmx -l ${T_DIR}/test-plan.jtl -j ${T_DIR}/jmeter.log \
	-e -o ${R_DIR}


echo "==== jmeter.log ===="
cat ${T_DIR}/jmeter.log

echo "==== Raw Test Report ===="
cat ${T_DIR}/test-plan.jtl

echo "==== HTML Test Report ===="
echo "See HTML test report in ${R_DIR}/index.html"


# upload the output files to an s3 bucket
aws s3 sync ${T_DIR} $S3_folder
