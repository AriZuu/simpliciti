#ifdef ISM_EU

#if LINK_SPEED == 1

#include "smartrf_1k.h"

#elif LINK_SPEED == 38

#include "smartrf_38k.h"

#elif LINK_SPEED == 78

#include "smartrf_chronos.h"

#else

#error LINK_SPEED not defined.

#endif

#else

#error "Wrong ISM band specified"

#endif // ISM_EU
