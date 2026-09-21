#!/usr/bin/env bash
set -euo pipefail
url="${1:?Indique URL base}"
version="${2:?Indique versión esperada}"
health="$(curl --fail --silent --show-error "$url/health")"
sum="$(curl --fail --silent --show-error "$url/calculate?op=sumar&a=8&b=5")"
test "$health" = "OK:$version"
test "$sum" = "13"
echo "ACCEPTANCE PASS url=$url version=$version health=$health suma=$sum"
