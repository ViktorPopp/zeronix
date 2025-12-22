#include "boot.h"
#include "cpu.h"
#include "limine/limine.h"
#include <stddef.h>

void kstart()
{
    if (!LIMINE_BASE_REVISION_SUPPORTED(limine_base_revision))
    {
        halt_loop();
    }

    if (limine_framebuffer_request.response == NULL ||
        limine_framebuffer_request.response->framebuffer_count < 1)
    {
        halt_loop();
    }

    struct limine_framebuffer *framebuffer = limine_framebuffer_request.response->framebuffers[0];

    for (size_t i = 0; i < 100; i++)
    {
        volatile uint32_t *fb_ptr                = framebuffer->address;
        fb_ptr[i * (framebuffer->pitch / 4) + i] = 0xffffff;
    }

    halt_loop();
}
