#!/bin/bash
chmod +x /tmp/haproxy_setup.sh
source /tmp/haproxy_env.sh
export HAPROXY_CONFIG=$(templatefile(${HAPROXY_TEMPLATE_FILE}, { master1_ip = ${MASTER1_IP}, master2_ip = ${MASTER2_IP} }))
/tmp/haproxy_setup.sh
