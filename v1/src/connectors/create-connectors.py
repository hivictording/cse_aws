import json
import os
import requests

BEARER = 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjNlYzdjMWIyOThhODQzNzliMGQyNmU0ZGQ2NmMwYWM0Yjc0ODc1YjEiLCJ0eXAiOiJKV1QifQ.eyJBY2Nlc3NUb2tlbiI6ImxldmVsMSIsIkFjdCI6dHJ1ZSwiQXV0aCI6IkxPQ0FMIiwiQXV0aFVzZXJPcmdJRCI6ImExZTgzZWM0LTcxM2EtNGNjMi1iZDIxLTcxMjkzY2M0YWMwNSIsIkVtYWlsIjoic2FAYmFueWFub3BzLmNvbSIsIk5vVlBOIjoiRU5BQkxFRCIsIk9yZ0lEIjoiOWM2MTk3N2EtNjUzZS00M2M5LWExZGYtMjRlMGFlNDMyODkzIiwiUGFyZW50T3JnSUQiOiI0M2QwNWY4MS1kYjBkLTExZTktYTkyMi00MjAxMGEzMmIwMzAiLCJQcm9maWxlIjoiQWRtaW4iLCJSZWZyZXNoIjoiZmFsc2UiLCJSZWZyZXNoRW1haWwiOiIiLCJVbmlxdWVJRCI6Ijc3NWI0OTI5LTU0ODMtNGY4ZS04N2E3LTM2MzUwMWQ1YjkzYSIsImV4cCI6MTc2NDQwNzc5MywiaWF0IjoxNzY0MzY0NTkzfQ.sG7qAIPaw_R8vR4y3XlEg4h679aJUmNuK2Bze0SNg0aOe9dGl6wnPU21UDSLtsd5tTnSyDh5rgviCshTP9NfdlpHTog8BkqKS1MoT9agWG3Fbe96_Q-jqmF3rT0vSmCro2whugIHtYOm9J3NAj-0LfH9QLoF1hWO4cZrLJfjMfHgtJ7x-GiLqKd7Dwcs13L537ICPLk2XM_nb6qzXI2GTPNQ85EHdrLgpepj5sPU7Cu0VhQfdzHoGeLbQkKsHfINuJSUzvcUAxLrl55yXe79OWvchhSLyrgM1-ZJ7r0hGfSDRQSiW5BFY1KadpgVo2KakT2tDquwvXN76Soi0gejUA'
# MSW_SSO = os.environ.get("BNN_MSW_SSO", "YOUR_X_MSW_SSO_TOKEN")

url = "https://release.bnntest.com/api/v2/satellite"

count = 3
start_octet = 2  # 172.28.<start_octet>.0/24
api_key_id = "31e100e3-97cf-4b7a-ba0a-c2abe19cc6a9"

headers = {
    "accept": "*/*",
    "content-type": "application/json",
    "authorization": f"Bearer {BEARER}",
    # "x-msw-sso": MSW_SSO,
    "origin": "https://release.bnntest.com",
    "referer": "https://release.bnntest.com/admin-console/networks/connectors/add",
}

with requests.Session() as s:
    s.headers.update(headers)
    for i in range(count):
        name = f"aws-linux-connector-{i+1:03d}"
        cidr = f"172.28.{start_octet + i}.0/24"
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
                "api_key_id": api_key_id,
                "cidrs": [cidr],
                "domains": ["canadasolution.com"],
                "peer_access_tiers": [{"cluster": "global-edge", "access_tiers": ["*"]}],
                "disable_snat": False,
                "extended_network_access": True,
            },
        }
        resp = s.post(url, data=json.dumps(payload), timeout=30)
        try:
            resp.raise_for_status()
            print(f"{name} ({cidr}) -> {resp.status_code}")
        except Exception as e:
            print(f"ERROR {name} ({cidr}): {e} | Response: {resp.text}")
