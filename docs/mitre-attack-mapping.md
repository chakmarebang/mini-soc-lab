# MITRE ATT&CK Mapping

Mapping each simulated attack to the [MITRE ATT&CK framework](https://attack.mitre.org/). This table is a great thing to paste directly into a portfolio write-up or interview — it signals you think in frameworks recruiters and hiring managers recognize.

| Scenario | Tactic | Technique ID | Technique Name | Detection Source |
|---|---|---|---|---|
| SSH Brute Force | Credential Access | T1110 | Brute Force | Wazuh (auth logs) |
| Port Scanning | Discovery | T1046 | Network Service Scanning | Wazuh + Suricata (optional) |
| Reverse Shell | Execution | T1059 | Command and Scripting Interpreter | Wazuh (process/audit logs) |
| Reverse Shell (C2 channel) | Command and Control | T1071 | Application Layer Protocol | Wazuh (network logs) |

## Why this matters for job applications

SOC job postings frequently ask for "MITRE ATT&CK familiarity." Being able to say *"I simulated T1110 and T1046 in a home lab and wrote detection rules for each"* is a concrete, verifiable claim — far stronger than listing "MITRE ATT&CK" as a bullet-point skill with nothing behind it.

## Extending this table

As you add scenarios, keep this file updated. A growing, well-maintained mapping table over time also shows continuous learning — worth mentioning in interviews ("I keep adding to this as I learn new techniques").
