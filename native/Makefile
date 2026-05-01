# Location of the top-level MicroPython directory.
# Override on the command line if your checkout lives elsewhere.
MPY_DIR ?= ../../micropython

# The output module name. The generated file is HelloWorld.mpy.
MOD = HelloWorld

# Source files that become part of the native module.
SRC = HelloWorld.c

# ESP32 uses the Xtensa windowed ABI in MicroPython native modules.
ARCH ?= xtensawin

# Pull in MicroPython's standard dynamic-runtime build rules.
include $(MPY_DIR)/py/dynruntime.mk

