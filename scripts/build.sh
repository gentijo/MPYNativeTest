#!/usr/bin/env bash

# Build the ESP32 native .mpy module and stage a mip-installable package.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCH="${ARCH:-xtensawin}"
DIST_DIR="$ROOT_DIR/dist/mip"

if [[ -n "${MICROPY_DIR:-}" ]]; then
    MICROPY_DIR="$MICROPY_DIR"
elif [[ -d "$ROOT_DIR/../micropython" ]]; then
    MICROPY_DIR="$ROOT_DIR/../micropython"
elif [[ -d "/opt/micropython" ]]; then
    MICROPY_DIR="/opt/micropython"
else
    MICROPY_DIR="$ROOT_DIR/../micropython"
fi

if [[ ! -d "$MICROPY_DIR" ]]; then
    echo "error: MicroPython checkout not found at: $MICROPY_DIR" >&2
    echo "set MICROPY_DIR to your local MicroPython repository path" >&2
    exit 1
fi

if [[ ! -x "$MICROPY_DIR/mpy-cross/build/mpy-cross" ]]; then
    echo "error: mpy-cross is missing at: $MICROPY_DIR/mpy-cross/build/mpy-cross" >&2
    echo "build it first with: make -C \"$MICROPY_DIR/mpy-cross\"" >&2
    exit 1
fi

if ! command -v xtensa-esp32-elf-gcc >/dev/null 2>&1; then
    echo "error: xtensa-esp32-elf-gcc is not on PATH" >&2
    echo "install the ESP32 cross-toolchain and add it to PATH before building" >&2
    exit 1
fi

echo "Building HelloWorld.mpy for ARCH=$ARCH"
make -C "$ROOT_DIR/native" clean
make -C "$ROOT_DIR/native" MPY_DIR="$MICROPY_DIR" ARCH="$ARCH"

mkdir -p "$DIST_DIR"
cp "$ROOT_DIR/native/HelloWorld.mpy" "$DIST_DIR/HelloWorld.mpy"
cp "$ROOT_DIR/packaging/package.json" "$DIST_DIR/package.json"

echo "Staged mip package in: $DIST_DIR"
