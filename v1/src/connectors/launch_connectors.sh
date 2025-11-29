#!/usr/bin/env bash

set -euo pipefail

: "${COMMAND_CENTER_URL:=https://release.bnntest.com}"
: "${API_KEY_SECRET:=CqyXdUWfabPgBtUme07gENR64dkDPhv1c46uEVYoCdk}"

usage() {
  echo "Usage: $0 [START_NUM [END_NUM]]" >&2
  echo "  START_NUM defaults to 1; END_NUM defaults to 3." >&2
}

log() {
  local level="$1"; shift
  printf '[%s] %-9s %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "${level}" "$*"
}

if [[ "${1:-}" =~ ^(-h|--help)$ ]]; then
  usage
  exit 0
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is not installed or not on PATH." >&2
  exit 1
fi

START_NUM=${1:-1}
END_NUM=${2:-3}

if ! [[ "${START_NUM}" =~ ^[0-9]+$ && "${END_NUM}" =~ ^[0-9]+$ ]]; then
  echo "Error: START_NUM and END_NUM must be non-negative integers." >&2
  usage
  exit 1
fi

if (( END_NUM < START_NUM )); then
  echo "Error: END_NUM (${END_NUM}) must be greater than or equal to START_NUM (${START_NUM})." >&2
  exit 1
fi

export COMMAND_CENTER_URL
export API_KEY_SECRET

for ((n=START_NUM; n<=END_NUM; n++)); do

  export CONNECTOR_NAME=$(printf "myconnector-%03d" "${n}")

  log "STARTING" "Launching docker connector ${CONNECTOR_NAME}"

  sleep 1

  sudo -E docker run --name ${CONNECTOR_NAME} --privileged --pull always --restart unless-stopped --cap-add=NET_ADMIN -e COMMAND_CENTER_URL -e API_KEY_SECRET -e CONNECTOR_NAME -d gcr.io/banyan-pub/connector:2.0.7
  
  log "COMPLETED" "Launching docker connector ${CONNECTOR_NAME}"

  sleep 1
done
