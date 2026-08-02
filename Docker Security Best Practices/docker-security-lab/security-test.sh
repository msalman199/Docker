#!/bin/bash

echo "=== Docker Security Best Practices Test ==="

echo "1. Testing user namespaces..."
docker run --rm ubuntu:20.04 /bin/bash -c "echo 'User: $(whoami), UID: $(id -u)'"

echo "2. Testing seccomp profile..."
docker run --rm --security-opt seccomp=~/docker-security-lab/seccomp/restricted-profile.json ubuntu:20.04 /bin/bash -c "echo 'Seccomp: OK'" 2>/dev/null && echo "Seccomp profile applied" || echo "Seccomp profile failed"

echo "3. Testing AppArmor profile..."
docker run --rm --security-opt apparmor=docker-restricted ubuntu:20.04 /bin/bash -c "echo 'AppArmor: OK'" 2>/dev/null && echo "AppArmor profile applied" || echo "AppArmor profile failed"

echo "4. Testing resource limits..."
docker run --rm --memory=64m --cpus="0.5" ubuntu:20.04 /bin/bash -c "echo 'Resource limits: OK'"

echo "5. Testing vulnerability scanning..."
docker scout cves ubuntu:20.04 | head -10

echo "=== Security test completed ==="
