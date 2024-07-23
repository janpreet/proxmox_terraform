#!/bin/bash
chmod +x /tmp/k8s_join_command.sh
source /tmp/k8s_worker_env.sh
JOIN_COMMAND=$(ssh -o StrictHostKeyChecking=no -i ${SSH_PRIVATE_KEY} ${SSH_USER}@${MASTER_IP} 'cat /tmp/join_command.sh')
sudo $JOIN_COMMAND
