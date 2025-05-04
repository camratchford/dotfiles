#!/bin/bash

# Scrubs the ~/.ssh/known_hosts file of any fingerprints assoicated to the hostname provided
# Will check DNS hostname, IPv4, IPv6 for associated known_host entries
# Args:
#   $1 = hostname (or IP)
#

function newsshhost() {
  ssh-keygen -f ~/.ssh/known_hosts -R $1
  local ip=$(grep $1 /etc/hosts | awk '{print $1}')
  if [[ -n $ip ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R $ip
  fi
  ip=$(dig -t a +short $1)
  if [[ -n $ip ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R $ip
  fi
  ip=$(dig -t aaaa +short $1)
  if [[ -n $ip ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R $ip
  fi
  ssh-keyscan -t ecdsa $1 >> ~/.ssh/known_hosts
}

