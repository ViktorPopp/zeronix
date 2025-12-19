#include "cpu.h"

inline void halt()
{
    __asm__ volatile("hlt");
}

void halt_loop()
{
    for (;;)
    {
        halt();
    }
}
