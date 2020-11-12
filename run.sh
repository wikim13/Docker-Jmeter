#!/bin/bash
#
# Run JMeter Docker image with options

NAME="jmeter"
IMAGE="wikim13/jmeter:5.3"

# Finally run
sudo docker stop ${NAME} > /dev/null 2>&1
sudo docker rm ${NAME} > /dev/null 2>&1
sudo docker run --name ${NAME} -v ${PWD}:${PWD} -w ${PWD} ${IMAGE} -Jjmeterengine.force.system.exit=true jmeter.save.saveservice.subresults=false -Jjmeter.save.saveservice.response_data=tr$
        -n -t ${T_DIR}/test-plan.jmx -l ${T_DIR}/test-plan.jtl



 
