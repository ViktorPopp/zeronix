#include "boot.h"
#include "cpu.h"
#include "limine/limine.h"

void kstart()
{
    if (!LIMINE_BASE_REVISION_SUPPORTED(limine_base_revision))
    {
        halt_loop();
    }

    halt_loop();
}
