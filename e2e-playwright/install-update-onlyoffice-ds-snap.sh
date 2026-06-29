#!/usr/bin/env bash
set -euo pipefail

: "${SNAP_NAME:?SNAP_NAME is required}"
: "${SCENARIO:?SCENARIO is required}"

wait_for_snapd() {
  echo "==> Wait for snapd to become idle"
  for attempt in {1..60}; do
    if ! snap changes | awk 'NR > 1 && $2 == "Doing" { found = 1 } END { exit found ? 0 : 1 }'; then
      return
    fi

    echo "snapd is still busy ($attempt/60)..."
    sleep 5
  done

  echo "snapd still has changes in progress:" >&2
  snap changes >&2 || true
  return 1
}

install_snapd() {
  echo "==> Ensure snapd is installed"
  if ! command -v snap >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get install -y snapd
    elif command -v dnf >/dev/null 2>&1; then
      dnf install -y snapd
    elif command -v yum >/dev/null 2>&1; then
      yum install -y snapd
    else
      echo "No supported package manager found for snapd installation" >&2
      exit 1
    fi
  fi

  systemctl enable --now snapd.socket
  ln -sfn /var/lib/snapd/snap /snap
  snap wait system seed.loaded
  wait_for_snapd
}

install_local_snap() {
  local allow_existing_install=${1:-false}

  echo "==> Install local snap artifact"
  if ! snap install --dangerous ./${SNAP_NAME}_*.snap; then
    if [ "$allow_existing_install" != true ] || ! snap list "$SNAP_NAME" >/dev/null 2>&1; then
      return 1
    fi
    echo "${SNAP_NAME} is installed despite the non-zero snap install exit code" >&2
  fi
  wait_for_snapd
}

run_scenario() {
  echo "==> Run ${SCENARIO} scenario"
  case "$SCENARIO" in
    clean)
      install_local_snap true
      ;;
    upgrade)
      echo "==> Install current stable snap from the store"
      snap install "$SNAP_NAME"
      wait_for_snapd
      echo "==> Prepare installed snap for local refresh"
      snap stop "$SNAP_NAME" || true
      wait_for_snapd
      rm -rf "/tmp/snap-private-tmp/snap.${SNAP_NAME}"
      install_local_snap
      snap start "$SNAP_NAME"
      wait_for_snapd
      ;;
    *)
      echo "Unknown scenario: $SCENARIO" >&2
      exit 1
      ;;
  esac
}

require_service_active() {
  local service="$1"
  awk -v svc="$service" '
    $1 == svc { found = 1; state = $3 }
    END { exit !(found && state == "active") }
  '
}

check_services() {
  local services

  echo "==> Check snap services"
  for attempt in {1..60}; do
    services=$(snap services "$SNAP_NAME")
    printf '%s\n' "$services"

    if printf '%s\n' "$services" | require_service_active "${SNAP_NAME}.nginx" && \
       printf '%s\n' "$services" | require_service_active "${SNAP_NAME}.documentserver"; then
      return
    fi

    echo "Snap services are not active yet ($attempt/60)..."
    sleep 5
  done

  echo "Snap services did not become active" >&2
  return 1
}

install_snapd
run_scenario
check_services

echo "==> Enable example app"
snap set "$SNAP_NAME" onlyoffice.example-enabled=true
wait_for_snapd
