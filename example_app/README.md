# Example App

This file is the sample MicroPython application for the native module example.

It expects `HelloWorld.mpy` to already be installed into the device `lib`
directory via `mip` or `mpremote mip`.

## Run

Install the package first:

```bash
mpremote mip install ./dist/mip/package.json
```

Then copy the example app:

```bash
mpremote fs cp ./example_app/main.py :main.py
mpremote reset
```

