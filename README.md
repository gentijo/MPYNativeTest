# Native `HelloWorld` MicroPython Module for ESP32

This repository is a complete example of a native MicroPython `.mpy` module that:

- is written in C
- builds as a native `.mpy` library for the ESP32 port
- can be installed with `mip`
- exposes `HelloWorld.sayHello()`
- includes a Docker environment pinned to MicroPython `v1.27.0` tooling

After installation, MicroPython code uses the module like this:

```python
import HelloWorld

HelloWorld.sayHello()
```

That prints:

```text
Hello World
```

## What This Project Contains

- `native/HelloWorld.c`: the native module source
- `native/Makefile`: the MicroPython dynamic runtime build
- `scripts/build.sh`: builds `HelloWorld.mpy` for ESP32 and stages a `mip` package
- `Dockerfile`: container image with ESP-IDF `v5.5.1` and MicroPython `v1.27.0`
- `docker-compose.yml`: starts the development container as `HelloWorld`
- `package.json`: repo-root package manifest consumed by `mip`
- `packaging/package.json`: staged package manifest for `dist/mip`
- `example_app/main.py`: sample MicroPython app that imports and uses the module

## Prerequisites

You need:

- `python3`
- `make`
- `pyelftools`
- `mpy-cross` built inside the MicroPython checkout
- the ESP32 Xtensa toolchain on `PATH`

For host builds, this project defaults to the sibling checkout at:

```text
../micropython
```

Inside the Docker container, it automatically uses:

```text
/opt/micropython
```

The build targets the standard ESP32 architecture used by MicroPython native modules:

```text
ARCH=xtensawin
```

That matches the MicroPython native-module documentation for ESP32.

## Build

From this repository root:

```bash
./scripts/build.sh
```

If your MicroPython checkout is somewhere else:

```bash
MICROPY_DIR=/absolute/path/to/micropython ./scripts/build.sh
```

The build produces:

- `native/HelloWorld.mpy`
- `dist/mip/HelloWorld.mpy`
- `dist/mip/package.json`

## Docker Development Environment

The container pins the versions needed for this example:

- MicroPython source: `v1.27.0`
- ESP-IDF: `v5.5.1`

This matches the `ports/esp32/README.md` in the MicroPython `v1.27.0` tag, which says the recommended ESP-IDF version is `v5.5.1`.

Start the container:

```bash
docker compose up -d
```

Open a shell:

```bash
docker exec -it HelloWorld bash
```

Inside the container:

```bash
cd /opt/NAtiveMpyTest
./scripts/build.sh
```

The project directory is bind-mounted from the host into:

```text
/opt/NAtiveMpyTest
```

The bundled MicroPython checkout lives at:

```text
/opt/micropython
```

## Install With `mip`

### Option 1: Install from the local checkout with `mpremote`

This is the easiest way to test during development:

```bash
mpremote mip install ./package.json
```

You can also install from the staged package directory directly:

```bash
mpremote mip install ./dist/mip/package.json
```

### Option 2: Install directly on the device from GitHub

If you push this repository to GitHub and commit the built `dist/mip/HelloWorld.mpy` artifact, then from an ESP32 REPL you can run:

```python
import mip
mip.install("github:YOUR_GITHUB_USER/YOUR_REPO")
```

The repo-root `package.json` points at `dist/mip/HelloWorld.mpy`, so `mip` can resolve the built artifact from the repository root.

## Deploy The Example Application

After installing the package:

```bash
mpremote fs cp ./example_app/main.py :main.py
mpremote reset
```

The board will print:

```text
Hello World
```

## Notes

- This example is intentionally minimal and exposes a module-level function named `sayHello`.
- Although your prompt mentioned a `HelloWorld` class, the required usage is `import HelloWorld` followed by `HelloWorld.sayHello()`, which is a module import pattern rather than a class instance pattern.
- Native `.mpy` files are architecture-specific, so this build is for the ESP32 port only.

## References

- MicroPython native module documentation: <https://docs.micropython.org/en/v1.27.0/develop/natmod.html>
- MicroPython package management documentation: <https://docs.micropython.org/en/latest/reference/packages.html>
