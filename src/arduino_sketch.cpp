// #include <iostream>

// #include "Linuxduino.h"

/**
 * @file main.c
 *
 */

/*********************
 *      INCLUDES
 *********************/

#ifndef _DEFAULT_SOURCE
#define _DEFAULT_SOURCE /* needed for usleep() */
#endif

// #include <stdio.h>
// #include <stdlib.h>
// #ifdef _MSC_VER
// #include <Windows.h>
// #else
// #include <pthread.h>
// #include <unistd.h>
// #endif
// #include <SDL.h>

// #include "hal/hal.h"
// #include "lvgl/demos/lv_demos.h"
// #include "lvgl/examples/lv_examples.h"
// #include "lvgl/lvgl.h"

/*********************
 *      DEFINES
 *********************/

/**********************
 *      TYPEDEFS
 **********************/

/**********************
 *  STATIC PROTOTYPES
 **********************/

/**********************
 *  STATIC VARIABLES
 **********************/

/**********************
 *      MACROS
 **********************/

/**********************
 *   GLOBAL FUNCTIONS
 **********************/

// #if LV_USE_OS != LV_OS_FREERTOS

#include "../Arduino/Arduino.h"

void loop(void) {
  delay(100);
  Serial.println("Don't warry. Be happy!!!");
}

void setup()
// int main(int argc, char **argv)
{
  // (void)argc; /*Unused*/
  // (void)argv; /*Unused*/

  // printf("Hello world");
  // Serial.begin("/dev/ttyUSB0", 9600);
  Serial.begin(9600);
  // std::cout << "Передаём на UART" << std::endl;

  /*Initialize LVGL*/
  // lv_init();

  /*Initialize the HAL (display, input devices, tick) for LVGL*/
  // sdl_hal_init(480, 640);

  /* Run the default demo */
  /* To try a different demo or example, replace this with one of: */
  /* - lv_demo_benchmark(); */
  /* - lv_demo_stress(); */
  /* - lv_example_label_1(); */
  /* - etc. */
  // lv_demo_widgets();

  while (1) {
    /* Periodically call the lv_task handler.
     * It could be done in a timer interrupt or an OS task too.*/
    // uint32_t sleep_time_ms = lv_timer_handler();
    // if (sleep_time_ms == LV_NO_TIMER_READY) {
    //   sleep_time_ms = LV_DEF_REFR_PERIOD;
    // }

    // loop();
    delay(100);
    Serial.println("Don't warry. Be happy!!!");

#ifdef _MSC_VER
    Sleep(sleep_time_ms);
#else
    // usleep(sleep_time_ms * 1000);
#endif
  }

  // return 0;
}

/**********************
 *   STATIC FUNCTIONS
 **********************/

// void setup(void) {
//   printf("Hello world");
//   Serial.begin("/dev/ttyUSB0", 9600);

//   std::cout << "fasdfasdf" << std::endl;
// }

// void loop() {}