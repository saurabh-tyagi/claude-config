# Project: AWS Untagged Resource Manager

## Purpose
Python CLI tool that scans an AWS DataLake account for untagged resources,
enriches them with Cost Explorer data, and reports sorted by cost descending.

## Key files
- `main.py` — click CLI entry point
- `config.yaml` — regions, lookback_days, blacklist rules
- `src/models.py` — UntaggedResource dataclass
- `src/scanner.py` — Resource Groups Tagging API scan (multi-region)
- `src/cost_analyzer.py` — Cost Explorer: resource-level first, service-level fallback
- `src/blacklist.py` — regex name patterns + resource type + ARN exclusions
- `src/reporter.py` — table / JSON / CSV rendering (tabulate)

## Dependencies
boto3, pyyaml, click, tabulate

## IAM permissions needed
tag:GetResources, ce:GetCostAndUsage

## Cost strategy
1. Try RESOURCE_ID grouping in Cost Explorer (requires opt-in feature)
2. Fall back to service total divided equally among untagged resources of that service
3. "~$X.XX" prefix indicates service-level estimate; "$X.XX" = resource-level
