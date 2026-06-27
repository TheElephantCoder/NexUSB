#!/bin/bash
# test suite

set -e

echo "=== NexUSB Test Suite ==="
echo ""

TESTS_PASSED=0
TESTS_FAILED=0

# colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# run_test "name" cmd [args...]
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

# file structure
echo "[1/5] File Structure Tests"
run_test "build.sh exists" [ -f build.sh ]
run_test "build-minimal.sh exists" [ -f build-minimal.sh ]
run_test "scripts directory exists" [ -d scripts ]
run_test "config directory exists" [ -d config ]
run_test "theme directory exists" [ -d theme ]
run_test "docs directory exists" [ -d docs ]
echo ""

# shell syntax
echo "[2/5] Script Syntax Tests"
run_test "build.sh syntax" bash -n build.sh
run_test "build-minimal.sh syntax" bash -n build-minimal.sh

for script in scripts/*.sh; do
    run_test "$(basename "$script") syntax" bash -n "$script"
done

for script in autorun/*.sh; do
    run_test "$(basename "$script") syntax" bash -n "$script"
done

for dir in docker windows; do
    for script in "$dir"/*.sh; do
        [ -e "$script" ] || continue
        run_test "$(basename "$script") syntax" bash -n "$script"
    done
done
echo ""

# python syntax
echo "[3/5] Python Syntax Tests"
if command -v python3 &> /dev/null; then
    for pyfile in gui/*.py; do
        run_test "$(basename "$pyfile") syntax" python3 -m py_compile "$pyfile"
    done
else
    echo "Python3 not found, skipping Python tests"
fi
echo ""

# config format
echo "[4/5] Configuration Tests"
run_test "tools.conf format" grep -E '^[A-Z]+\|.+\|.+\|.+$' config/tools.conf
run_test "windows-tools.conf format" grep -E '^.+\|.+\|.+$' config/windows-tools.conf
run_test "iso-collection.conf format" grep -E '^.+\|.+\|[0-9]+\|.+$' config/iso-collection.conf
echo ""

# docs
echo "[5/5] Documentation Tests"
run_test "README.md exists" [ -f README.md ]
run_test "BUILD.md exists" [ -f BUILD.md ]
run_test "LICENSE exists" [ -f LICENSE ]
run_test "CONTRIBUTING.md exists" [ -f CONTRIBUTING.md ]

for doc in docs/*.md; do
    run_test "$(basename "$doc") exists" [ -f "$doc" ]
done
echo ""

# summary
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
