#!/bin/bash
#
# Run JMeter Docker image with options

NAME="jmeter"
IMAGE="wikim13/jmeter:5.3"

# Finally run
sudo docker stop ${NAME} > /dev/null 2>&1
sudo docker rm ${NAME} > /dev/null 2>&1
sudo docker run --name ${NAME} -i -v ${PWD}:${PWD} -w ${PWD} ${IMAGE}  -Dlog_level.jmeter=DEBUG -Jjmeter.save.saveservice.response_data=true -Jjmeter.save.saveservice.response_data.on_error=true -Jjmeter.save.saveservice.output_format=xml -Jjmeter.save.saveservice.samplerData=true -Jjmeterengine.force.system.exit=true \
	-n -t ${T_DIR}/test-plan.jmx -l ${T_DIR}/test-plan.jtl -j ${T_DIR}/jmeter.log
