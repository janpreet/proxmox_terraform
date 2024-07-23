#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y haproxy
echo "${HAPROXY_CONFIG}" | sudo tee /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy
