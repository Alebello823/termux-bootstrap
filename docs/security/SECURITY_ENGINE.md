# Security Engine

## Purpose

The Security Engine analyzes the local Termux environment
and identifies security conditions.

It is designed as a defensive security framework.

## Execution Flow


tb security

        |
        v

report.sh

        |
        v

audit.sh

        |
        +---- permissions.sh
        |
        +---- packages.sh
        |
        +---- ssh.sh

        |
        v

score.sh


## Current Checks

### Permissions

Checks:
- Home directory permissions

### Packages

Checks:
- Termux package manager
- Installed packages count

### SSH

Checks:
- SSH directory
- ED25519 key availability


## Reports

Generated file:

reports/security_report.txt


## Future Extensions

Possible modules:

- Service analysis
- Configuration review
- Security recommendations
- Compliance checks
