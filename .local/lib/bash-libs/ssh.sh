#!/bin/bash



function newsshhost {
  # Scrubs the ~/.ssh/known_hosts file of any fingerprints associated to the hostname provided
  # Will check DNS hostname, IPv4, IPv6 for associated known_host entries
  # Args:
  #   $1 = hostname (or IP)
  local HOSTNAME IP_ADDRESS
  HOSTNAME="${1?'No hostname provided'}"
  ssh-keygen -f ~/.ssh/known_hosts -R "$HOSTNAME"

  # v4/v6 - from hosts
  IP_ADDRESS=$(grep "$HOSTNAME" /etc/hosts | awk '{print $1}')
  if [[ -n $IP_ADDRESS ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R "$IP_ADDRESS"
  fi

  # v4 - from DNS
  IP_ADDRESS=$(dig -t a +short "$HOSTNAME")
  if [[ -n $IP_ADDRESS ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R "$IP_ADDRESS"
  fi

  # v6 - from DNS
  IP_ADDRESS=$(dig -t aaaa +short "$HOSTNAME")
  if [[ -n $IP_ADDRESS ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R "$IP_ADDRESS"
  fi
  ssh-keyscan -t ecdsa "$HOSTNAME" >> ~/.ssh/known_hosts
}

