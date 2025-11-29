import argparse
import json
import sys
from typing import Any, Dict, List

import requests

from config import API_KEY_ID, BEARER, URL


# -----------------------------
# Shared helpers
# -----------------------------


def _default_headers() -> Dict[str, str]:
    return {
        "accept": "*/*",
        "content-type": "application/json",
        "authorization": f"Bearer {BEARER}",
        "origin": "https://release.bnntest.com",
        "referer": "https://release.bnntest.com/admin-console/networks/connectors?",
    }


def _extract_connectors(payload: Any) -> List[Dict[str, Any]]:
    """Normalize the API response into a list of connector/satellite dicts."""
    if isinstance(payload, dict) and payload.get("error_code") not in (0, None):
        raise ValueError(
            f"{payload.get('error_code')}: {payload.get('error_description')}"
        )

    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        for key in ("satellites", "items", "data", "connectors", "results"):
            if isinstance(payload.get(key), list):
                return payload[key]
        data = payload.get("data")
        if isinstance(data, dict):
            for key in ("satellites", "items", "result", "connectors", "results"):
                if isinstance(data.get(key), list):
                    return data[key]
        if isinstance(data, list):
            return data
    return []


def _summarize(connector: Dict[str, Any]) -> Dict[str, Any]:
    """Return only the requested connector fields."""
    metadata = connector.get("metadata", {}) if isinstance(connector, dict) else {}

    # Gather a usable spec block from common locations
    spec_candidates = [
        connector.get("spec"),
        connector.get("specification"),
        connector.get("spec_template"),
        connector.get("details"),
        connector.get("config"),
    ]
    spec = next((cand for cand in spec_candidates if isinstance(cand, dict)), {})  # type: ignore[arg-type]

    # Status can be a dict with status/state or a plain string
    raw_status = connector.get("status") if isinstance(connector, dict) else None
    status_block = raw_status if isinstance(raw_status, dict) else {}

    connector_id = (
        connector.get("id")
        or metadata.get("id")
        or metadata.get("uid")
        or metadata.get("name")
        or spec.get("id")
    )

    status_value = None
    if isinstance(status_block, dict):
        status_value = status_block.get("status") or status_block.get("state")
    if status_value is None:
        status_value = (
            raw_status if isinstance(raw_status, str) else connector.get("status")
        )

    return {
        "id": connector_id,
        "name": metadata.get("name")
        or metadata.get("display_name")
        or connector.get("name"),
        "tunnel_ip_address": spec.get("tunnel_ip_address")
        or (
            status_block.get("tunnel_ip_address")
            if isinstance(status_block, dict)
            else None
        )
        or connector.get("tunnel_ip_address"),
        "status": status_value,
        "cidrs": spec.get("cidrs")
        or spec.get("service_cidrs")
        or connector.get("cidrs"),
        "domains": spec.get("domains")
        or spec.get("fqdn")
        or spec.get("fqdns")
        or connector.get("domains"),
        "connector_version": spec.get("connector_version")
        or status_block.get("connector_version")
        or connector.get("connector_version"),
        "extended_network_access_capability": spec.get(
            "extended_network_access_capability"
        )
        or spec.get("extended_network_access")
        or status_block.get("extended_network_access_capability")
        or connector.get("extended_network_access_capability"),
    }


def _filter_by_prefix(
    connectors: List[Dict[str, Any]], prefixes: List[str]
) -> List[Dict[str, Any]]:
    """Return connectors whose name starts with any of the given prefixes."""
    normalized = [p.lower() for p in prefixes if p]
    if not normalized:
        return connectors

    filtered: List[Dict[str, Any]] = []
    for connector in connectors:
        name = None
        if isinstance(connector, dict):
            name = (
                connector.get("name")
                or connector.get("display_name")
                or connector.get("metadata", {}).get("name")
            )
        if name and any(name.lower().startswith(p) for p in normalized):
            filtered.append(connector)
    return filtered


# -----------------------------
# Create
# -----------------------------


def create_connectors(count: int, name_prefix: str, start_number: int) -> None:
    count = max(count, 0)
    start_number = max(start_number, 1)
    headers = _default_headers()
    headers["referer"] = (
        "https://release.bnntest.com/admin-console/networks/connectors/add"
    )

    with requests.Session() as session:
        session.headers.update(headers)
        for i in range(count):
            name = f"{name_prefix}-{start_number + i:03d}"
            # Map sequence number to third octet: 1->2, 2->3, ..., 253->254, 254->2, ...
            octet = ((start_number + i - 1) % 253) + 2
            cidr = f"172.28.{octet}.0/24"
            desc = f"{name} description"
            payload = {
                "kind": "BanyanConnector",
                "api_version": "rbac.banyanops.com/v1",
                "type": "attribute-based",
                "metadata": {
                    "name": name,
                    "display_name": name,
                    "description": desc,
                },
                "spec": {
                    "keepalive": 20,
                    "api_key_id": API_KEY_ID,
                    "cidrs": [cidr],
                    "domains": ["canadasolution.com"],
                    "peer_access_tiers": [
                        {"cluster": "global-edge", "access_tiers": ["*"]}
                    ],
                    "disable_snat": False,
                    "extended_network_access": True,
                },
            }
            resp = session.post(URL, data=json.dumps(payload), timeout=30)
            try:
                resp.raise_for_status()
                print(f"{name} ({cidr}) -> {resp.status_code}")
            except Exception as exc:
                print(
                    f"ERROR {name} ({cidr}): {exc} | Response: {resp.text}",
                    file=sys.stderr,
                )


# -----------------------------
# List
# -----------------------------


def list_connectors(limit: int, prefixes: List[str]) -> List[Dict[str, Any]]:
    """Fetch and summarize connectors, optionally filtering by prefixes."""
    headers = _default_headers()
    params = {"limit": limit}
    with requests.Session() as session:
        session.headers.update(headers)
        response = session.get(URL, params=params, timeout=30)
        response.raise_for_status()
        raw = response.json()

    connectors = _extract_connectors(raw)
    if not connectors:
        print(
            json.dumps(
                {
                    "message": "No connectors parsed; dumping top-level keys for debugging.",
                    "keys": list(raw.keys()) if isinstance(raw, dict) else "n/a",
                    "payload": raw,
                },
                indent=2,
            ),
            file=sys.stderr,
        )
    filtered = _filter_by_prefix(connectors, prefixes)
    return [_summarize(item) for item in filtered]


# -----------------------------
# Delete
# -----------------------------


def delete_connectors(prefixes: List[str], limit: int, dry_run: bool) -> None:
    """Delete connectors whose name starts with any of the prefixes."""
    headers = _default_headers()

    try:
        connectors = list_connectors(limit=limit, prefixes=[])
    except Exception as exc:
        print(f"Failed to fetch connectors: {exc}", file=sys.stderr)
        sys.exit(1)

    targets = _filter_by_prefix(connectors, prefixes)
    if not targets:
        print("No connectors matched the given prefix(es).")
        return

    with requests.Session() as session:
        session.headers.update(headers)
        for conn in targets:
            cid = conn.get("id") or conn.get("connector_id")
            name = conn.get("name") or cid
            if not cid:
                print(f"Skipping {name}: missing id", file=sys.stderr)
                continue

            if dry_run:
                print(f"DRY RUN: would delete {name} ({cid})")
                continue

            endpoint = f"{URL.rstrip('/')}/{cid}"
            try:
                resp = session.delete(endpoint, timeout=30)
                resp.raise_for_status()
                print(f"Deleted {name} ({cid})")
            except Exception as exc:
                print(f"ERROR deleting {name} ({cid}): {exc}", file=sys.stderr)


# -----------------------------
# CLI
# -----------------------------


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Create, list, or delete Banyan connectors."
    )
    sub = parser.add_subparsers(dest="command", required=True)

    create_p = sub.add_parser("create", help="Create connectors.")
    create_p.add_argument(
        "-c",
        "--count",
        type=int,
        default=3,
        help="Number of connectors to create (default: 3).",
    )
    create_p.add_argument(
        "--start-number",
        type=int,
        default=1,
        help=(
            "Starting number for connector names (default: 1 -> {prefix}-001). "
            "CIDRs advance with the number and wrap the third octet after 254 back to 2."
        ),
    )
    create_p.add_argument(
        "-p",
        "--prefix",
        default="aws-linux-connector",
        help="Prefix for connector names (default: aws-linux-connector).",
    )

    list_p = sub.add_parser("list", help="List connectors.")
    list_p.add_argument(
        "-l",
        "--limit",
        type=int,
        default=100,
        help="Maximum number of connectors to fetch (default: 100).",
    )
    list_p.add_argument(
        "-p",
        "--prefix",
        action="append",
        help="Filter connectors whose name starts with this prefix (can be repeated).",
    )

    delete_p = sub.add_parser("delete", help="Delete connectors by prefix.")
    delete_p.add_argument(
        "-p",
        "--prefix",
        action="append",
        required=True,
        help="Prefix to match connector names (can be repeated).",
    )
    delete_p.add_argument(
        "-l",
        "--limit",
        type=int,
        default=200,
        help="Maximum number of connectors to fetch before filtering (default: 200).",
    )
    delete_p.add_argument(
        "--dry-run",
        action="store_true",
        help="List the matching connectors without deleting.",
    )

    args = parser.parse_args()

    if args.command == "create":
        create_connectors(
            count=args.count,
            name_prefix=args.prefix,
            start_number=args.start_number,
        )
    elif args.command == "list":
        summaries = list_connectors(limit=args.limit, prefixes=args.prefix or [])
        print(json.dumps(summaries, indent=2))
    elif args.command == "delete":
        delete_connectors(prefixes=args.prefix, limit=args.limit, dry_run=args.dry_run)


if __name__ == "__main__":
    main()
