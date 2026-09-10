# Setup Guide

Step-by-step instructions to build the lab from scratch. Expect this to take a weekend if you're new to VMs; a few hours if you're comfortable with them.

## Prerequisites

- A machine with at least 16GB RAM (8GB is possible but tight for 3 VMs)
- ~100GB free disk space
- VirtualBox (free) or Proxmox VE (free, better if you have spare hardware)
- Downloaded ISOs: Kali Linux, Ubuntu Server (or Windows 10 eval), Wazuh (or plan to install via script on Ubuntu)

## Step 1 — Create an isolated network

**This is the most important step.** Before installing anything, create a Host-Only or Internal Network in VirtualBox so none of these VMs can reach the real internet or your home network directly.

- VirtualBox: `File > Host Network Manager > Create`
- Give it a private range, e.g. `192.168.56.0/24`

Every VM in this lab attaches to this network only (plus NAT if you need internet access for `apt update`, which you can enable temporarily then disable).

## Step 2 — Build the Victim VM

1. Install Ubuntu Server (or Windows 10) on a VM attached to your isolated network
2. Enable relevant logging:
   - **Linux:** ensure `rsyslog` and `auditd` are installed and running
   - **Windows:** enable Security Event Logging via Local Group Policy (Audit Logon Events, Audit Process Tracking)
3. Note the victim's IP address — you'll need it for the attacker VM and the SIEM

## Step 3 — Build the Attacker VM

1. Install Kali Linux on a VM attached to the same isolated network
2. Verify it can reach the victim: `ping <victim-ip>`
3. Verify it **cannot** reach the outside world (double-check your network config)

## Step 4 — Build the SIEM (Wazuh)

Easiest path: install the Wazuh all-in-one stack on a third Ubuntu VM.

```bash
# On the SIEM VM
curl -sO https://packages.wazuh.com/4.x/wazuh-install.sh
sudo bash ./wazuh-install.sh -a
```

This installs the Wazuh manager, indexer, and dashboard. Follow the script's output for the auto-generated admin password.

## Step 5 — Connect the Victim to the SIEM

Install the Wazuh agent on your victim VM and point it at the SIEM's IP:

```bash
# On the Victim VM
curl -sO https://packages.wazuh.com/4.x/wazuh-agent.sh
sudo WAZUH_MANAGER='<siem-ip>' bash ./wazuh-agent.sh
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

Confirm the agent shows as "Active" in the Wazuh dashboard under **Agents**.

## Step 6 — Baseline check

Before simulating any attacks:
- Log into the victim machine normally a few times — confirm you see login events in the Wazuh dashboard
- Run a basic `nmap -sV <victim-ip>` from the attacker — confirm you see *something* in the logs (even if not yet a proper alert)

If logs are flowing, you're ready for [`attack-scenarios.md`](attack-scenarios.md).

## Troubleshooting

| Problem | Likely cause |
|---|---|
| Agent shows "Never Connected" | Firewall blocking port 1514/1515, or wrong manager IP |
| No logs appearing | `auditd`/`rsyslog` not running, or Wazuh agent not forwarding correctly |
| Attacker can reach internet | Double check adapter is Host-Only/Internal, not Bridged/NAT |
