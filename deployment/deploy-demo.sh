#!/usr/bin/env bash
# Demostración reproducible Blue/Green en el runner de CI.
set -euo pipefail
cd "$(dirname "$0")/.."
jar="${1:-target/calculadora-cicd-1.0.0.jar}"
mkdir -p deployment/runtime
cleanup() { kill "${router_pid:-}" "${green_pid:-}" "${blue_pid:-}" 2>/dev/null || true; }
trap cleanup EXIT

echo blue > deployment/runtime/active-slot.txt
APP_PORT=8081 APP_VERSION=blue java -jar "$jar" > deployment/runtime/blue.log 2>&1 &
blue_pid=$!
node deployment/router.js > deployment/runtime/router.log 2>&1 &
router_pid=$!
for i in {1..30}; do curl --fail --silent http://127.0.0.1:8080/health >/dev/null && break || sleep 1; done
bash deployment/acceptance.sh http://127.0.0.1:8080 blue

APP_PORT=8082 APP_VERSION=green java -jar "$jar" > deployment/runtime/green.log 2>&1 &
green_pid=$!
for i in {1..30}; do curl --fail --silent http://127.0.0.1:8082/health >/dev/null && break || sleep 1; done
bash deployment/acceptance.sh http://127.0.0.1:8082 green
echo green > deployment/runtime/active-slot.txt
bash deployment/acceptance.sh http://127.0.0.1:8080 green
echo 'DEPLOY PASS active=green'

# Simulación controlada: devolver tráfico al slot anterior y verificarlo.
echo blue > deployment/runtime/active-slot.txt
bash deployment/acceptance.sh http://127.0.0.1:8080 blue
echo 'ROLLBACK PASS active=blue'
