# cmake_minimum_required(VERSION 3.16.0)
# set (CMAKE_CXX_STANDARD 20) # версия стандартка языка C++ (C++ 2020)
# set (CMAKE_CXX_FLAGS_RELEASE "-O0") # отключение оптимизации компилятора (оптимизация = 0)
# set (CMAKE_CXX_FLAGS "-O0 -g3 -Wall -Wpedantic -fsanitize=address -fsanitize=undefined -fsanitize=leak")
# set (CMAKE_CXX_FLAGS "-O0 -g3 -Wall -Wextra -Wpedantic -fsanitize=address -fsanitize=undefined -fsanitize=leak")
# set (CMAKE_CXX_COMPILER "g++")
#set (CMAKE_CXX_FLAGS "-Wall -Wpedantic")
#enable_testing()

macro(if_use_Arduino)
    # Задаём файл для компиляции и отладки
    SET(ArduinoProject
        arduino_sketch
    )
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
        Arduino/main.cpp
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
        
    SET(UserFiles 
        src/arduino_sketch.cpp
    )

endmacro(if_use_Arduino)


# project(${ArduinoProject} VERSION 0.1 LANGUAGES CXX C)

macro(compile_arduino)
    # ----------------------------------------
    # Проект 
    add_executable(
        ${ArduinoProject}    # имя проекта
        ${ArduinoFiles}   # платформенно-назависимые исходники
        ${UserFiles}   # платформенно зависимые исходники
    )
    
endmacro(compile_arduino)

        




