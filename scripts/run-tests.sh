#!/bin/bash
# Test suite for NexUSB

set -e

echo "=== NexUSB Test Suite ==="
echo ""

TESTS_PASSED=0
TESTS_FAILED=0

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Test function
# Usage: run_test "description" command [args...]
run_test() {
    local test_name=$1
    shift

    echo -n "Testing $test_name... "

    if "$@" &> /dev/null; then
        echo -e "${GREEN}PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# File structure tests
echo "[1/5] File Structure Tests"
run_test "build.sh exists" [ -f build.sh ]
run_test "build-minimal.sh exists" [ -f build-minimal.sh ]
run_test "scripts directory exists" [ -d scripts ]
run_test "config directory exists" [ -d config ]
run_test "theme directory exists" [ -d theme ]
run_test "docs directory exists" [ -d docs ]
echo ""

# Script syntax tests
echo "[2/5] Script Syntax Tests"
run_test "build.sh syntax" bash -n build.sh
run_test "build-minimal.sh syntax" bash -n build-minimal.sh

for script in scripts/*.sh; do
    run_test "$(basename "$script") syntax" bash -n "$script"
done

for script in autorun/*.sh; do
    run_test "$(basename "$script") syntax" bash -n "$script"
done
echo ""

# Python syntax tests
echo "[3/5] Python Syntax Tests"
if command -v python3 &> /dev/null; then
    for pyfile in gui/*.py; do
        run_test "$(basename "$pyfile") syntax" python3 -m py_compile "$pyfile"
    done
else
    echo "Python3 not found, skipping Python tests"
fi
echo ""

# Configuration tests
echo "[4/5] Configuration Tests"
run_test "tools.conf format" grep -E '^[A-Z]+\|.+\|.+\|.+$' config/tools.conf
run_test "windows-tools.conf format" grep -E '^.+\|.+\|.+$' config/windows-tools.conf
run_test "iso-collection.conf format" grep -E '^.+\|.+\|[0-9]+\|.+$' config/iso-collection.conf
echo ""

# Documentation tests
echo "[5/5] Documentation Tests"
run_test "README.md exists" [ -f README.md ]
run_test "BUILD.md exists" [ -f BUILD.md ]
run_test "LICENSE exists" [ -f LICENSE ]
run_test "CONTRIBUTING.md exists" [ -f CONTRIBUTING.md ]

for doc in docs/*.md; do
    run_test "$(basename "$doc") exists" [ -f "$doc" ]
done
echo ""

# Summary
echo "=== Test Summary ==="
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"
echo ""

if [ "$TESTS_FAILED" -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
