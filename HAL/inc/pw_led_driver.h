#ifndef PW_LED_DRIVER_H_
#define PW_LED_DRIVER_H_

#define led_set(led, value)     IOWR_8DIRECT(PULSEWIDTH_LEDS_BASE, (led*4), value)
#define led_check(led)          IORD_8DIRECT(PULSEWIDTH_LEDS_BASE, (led*4))

#endif