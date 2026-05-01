// Native MicroPython module example for ESP32.
//
// The module exports one function:
//     HelloWorld.sayHello()
//
// Importing the generated HelloWorld.mpy file makes this function available
// at the module level inside MicroPython.

#include "py/dynruntime.h"

// Print the fixed demo string to the active MicroPython terminal/REPL.
static mp_obj_t hello_world_say_hello(void) {
    mp_printf(&mp_plat_print, "Hello World\n");
    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_0(hello_world_say_hello_obj, hello_world_say_hello);

// Module entry point called by MicroPython when HelloWorld.mpy is imported.
mp_obj_t mpy_init(mp_obj_fun_bc_t *self, size_t n_args, size_t n_kw, mp_obj_t *args) {
    // Initialize the dynamic runtime support before touching module globals.
    MP_DYNRUNTIME_INIT_ENTRY

    // Export the module function as HelloWorld.sayHello.
    mp_store_global(MP_QSTR_sayHello, MP_OBJ_FROM_PTR(&hello_world_say_hello_obj));

    // Finalize module initialization and restore the previous runtime state.
    MP_DYNRUNTIME_INIT_EXIT
}
