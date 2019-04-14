#!/bin/bash

set -e; set -u;

if ! grep -w "192.168.200.5 chef-server chef" /etc/hosts; then echo "192.168.200.5 chef-server chef" >> /etc/hosts; fi
