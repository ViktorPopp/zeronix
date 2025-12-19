#include "boot.h"
#include "limine/limine.h"

__attribute__((used, section(".limine_requests"))) volatile uint64_t limine_base_revision[3] =
    LIMINE_BASE_REVISION(3);

__attribute__((used, section(".limine_requests_"
                             "start"))) volatile uint64_t limine_requests_start_marker[4] =
    LIMINE_REQUESTS_START_MARKER;

__attribute__((used,
               section(".limine_requests_end"))) volatile uint64_t limine_requests_end_marker[2] =
    LIMINE_REQUESTS_END_MARKER;
