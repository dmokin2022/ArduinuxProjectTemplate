cmake_minimum_required(VERSION 3.15)
project(avr_project C CXX)

# Настройка для AVR
set(MCU atmega328p)
set(F_CPU 16000000UL)

# Поиск компилятора AVR
find_program(AVR_CC avr-gcc)
find_program(AVR_CXX avr-g++)
find_program(AVR_OBJCOPY avr-objcopy)
find_program(AVR_SIZE avr-size)
find_program(AVR_OBJDUMP avr-objdump)

if(NOT AVR_CC)
    message(FATAL_ERROR "AVR-GCC not found!")
endif()

# Настройка компилятора
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_C_COMPILER ${AVR_CC})
set(CMAKE_CXX_COMPILER ${AVR_CXX})

# Флаги компиляции
set(CMAKE_C_FLAGS "-mmcu=${MCU} -DF_CPU=${F_CPU} -Os -Wall")
set(CMAKE_CXX_FLAGS "-mmcu=${MCU} -DF_CPU=${F_CPU} -Os -Wall")

# Флаги линковки
set(CMAKE_EXE_LINKER_FLAGS "-mmcu=${MCU} -Wl,--gc-sections")

#-----------------------------
    # Указываем include-директории  
    # include_directories(${CMAKE_SOURCE_DIR})
    include_directories(Arduino)
    
    # Список общих платфоремнно-назависимых файлов проекта
    SET(ArduinoFiles
        Arduino/abi.cpp
        Arduino/hooks.c
        Arduino/wiring.c
        Arduino/IPAddress.cpp
        Arduino/Stream.cpp
        Arduino/wiring_digital.c
        Arduino/CDC.cpp
        #Arduino/main.cpp
        Arduino/Tone.cpp
        Arduino/wiring_pulse.c
        Arduino/new
        Arduino/wiring_pulse.S
        Arduino/HardwareSerial0.cpp
        Arduino/new.cpp
        Arduino/wiring_shift.c
        Arduino/HardwareSerial1.cpp
        Arduino/USBCore.cpp
        Arduino/WMath.cpp
        Arduino/HardwareSerial2.cpp
        Arduino/PluggableUSB.cpp
        Arduino/WString.cpp
        Arduino/HardwareSerial3.cpp
        Arduino/HardwareSerial.cpp
        Arduino/Print.cpp
        Arduino/WInterrupts.c
        Arduino/wiring_analog.c
    )
#-----------------------------

include_directories(/usr/share/arduino/hardware/arduino/avr/variants/standard)

# Добавление исходников
add_executable(${PROJECT_NAME} 
    src/main.c
    # Добавьте другие исходные файлы здесь
    ${ArduinoFiles}
)

# Дополнительные настройки
target_include_directories(${PROJECT_NAME} PRIVATE include)

# Целевые объекты для программирования
add_custom_target(flash
    DEPENDS ${PROJECT_NAME}
    COMMAND avrdude -p ${MCU} -c arduino -P /dev/ttyUSB0 -b 115200 -U flash:w:${PROJECT_NAME}.hex:i
    COMMENT "Programming ${MCU} with ${PROJECT_NAME}.hex"
)

# Генерация HEX файла
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${AVR_OBJCOPY} -O ihex -R .eeprom $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_NAME}.hex
    COMMAND ${AVR_SIZE} $<TARGET_FILE:${PROJECT_NAME}>
    COMMENT "Generating HEX file and size report"
)

# Генерация листинга
add_custom_target(lst
    DEPENDS ${PROJECT_NAME}
    COMMAND ${AVR_OBJDUMP} -h -S $<TARGET_FILE:${PROJECT_NAME}> > ${PROJECT_NAME}.lst
    COMMENT "Generating listing file"
)