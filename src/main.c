#include <avr/io.h>
#include <util/delay.h>
// #include "config.h"
#include "Arduino.h"

int main2(void) {
    // Настройка пина LED как выхода
    DDRB |= (1 << DDB5);  // PB5 (Arduino Uno LED)
    
    while(1) {
        PORTB ^= (1 << PORTB5);  // Переключение LED
        _delay_ms(500);
    }
    
    return 0;
}


int main ()
{
  pinMode(1, OUTPUT);
  
  while(1) {
    digitalWrite(1, HIGH);
    delay(500);
    digitalWrite(2, LOW);
    delay(500);
  }
}