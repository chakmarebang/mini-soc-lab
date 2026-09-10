# Mini SOC Lab — Attack Simulation & Detection

A hands-on home lab project simulating a Security Operations Center (SOC): I build a small vulnerable network, launch simulated attacks against it, detect those attacks using a SIEM, and document the full incident response cycle.

**Goal:** Demonstrate practical blue-team skills (log analysis, detection engineering, incident response) mapped to real-world frameworks like MITRE ATT&CK — built for a career transition into a SOC Analyst / Security Analyst role.

---

## 🧱 Lab Architecture

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  Attacker VM     │      │   Victim VM      │      │  SIEM / Monitor  │
│  Kali Linux      │─────▶│  Ubuntu/Windows  │─────▶│  Wazuh           │
│  (isolated NAT)  │      │  (logs forwarded)│      │  (dashboards +   │
│                  │      │                  │      │   alert rules)   │
└─────────────────┘      └─────────────────┘      └─────────────────┘
```

All VMs run on an isolated host-only/NAT network — nothing here touches the public internet or a real target.

| Component | Tool | Purpose |
|---|---|---|
| Hypervisor | VirtualBox / Proxmox | Host the lab |
| Attacker | Kali Linux | Launch simulated attacks |
| Victim | Ubuntu Server (or Windows 10) | Target with logging enabled |
| SIEM | Wazuh | Collect logs, alert, dashboard |
| Optional | pfSense | Firewall / network segmentation |

---

## 📁 Repo Structure

```
mini-soc-lab/
├── README.md                     # You are here
├── docs/
│   ├── setup-guide.md            # Step-by-step lab build instructions
│   ├── attack-scenarios.md       # What attacks I ran and why
│   └── mitre-attack-mapping.md   # Techniques mapped to MITRE ATT&CK
├── detection-rules/
│   └── wazuh-custom-rules.xml    # Custom detection rules written for this lab
├── scripts/
│   └── simulate-attacks.sh       # Reference commands used (lab-only, documented)
├── incident-reports/
│   └── template/
│       └── incident-report-template.md
└── LICENSE
```

---

## 🚦 Project Status

- [ ] Lab environment built
- [ ] Log forwarding configured
- [ ] Attack scenario 1: SSH brute force — simulated & detected
- [ ] Attack scenario 2: Network/port scan — simulated & detected
- [ ] Attack scenario 3: Reverse shell — simulated & detected
- [ ] Custom detection rules written
- [ ] Dashboards built
- [ ] Incident reports written for each scenario
- [ ] Write-up published (blog/LinkedIn)

---

## 🎯 What This Project Demonstrates

- **Detection engineering** — writing and tuning SIEM rules, not just clicking around a dashboard
- **MITRE ATT&CK literacy** — mapping real attacker behavior to a framework recruiters recognize
- **Incident response documentation** — the actual deliverable SOC analysts produce daily
- **End-to-end thinking** — attacker perspective + defender perspective, not just one side

---

## 📚 Start Here

1. Read [`docs/setup-guide.md`](docs/setup-guide.md) to build the lab
2. Read [`docs/attack-scenarios.md`](docs/attack-scenarios.md) to see what to simulate
3. Use [`detection-rules/wazuh-custom-rules.xml`](detection-rules/wazuh-custom-rules.xml) as a starting point for your own rules
4. Fill out an [`incident-reports/template/incident-report-template.md`](incident-reports/template/incident-report-template.md) for every attack you detect

---

## ⚠️ Disclaimer

This project is for **educational purposes in an isolated lab environment only**. Every attack technique here is run against machines I own, on a network with no internet-facing exposure. Do not run these tools against systems you do not own or have explicit written permission to test.

---

## 🔗 Author Notes

this is just a simple demo to understand soc roles in cybersecurity
