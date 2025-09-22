macro (if_use_FreeRTOS)

    if(USE_FREERTOS)
        message(STATUS "FreeRTOS is enabled")

        # FreeRTOS integration when USE_FREERTOS is enabled
        add_library(freertos_config INTERFACE)
        target_include_directories(freertos_config SYSTEM INTERFACE ${PROJECT_SOURCE_DIR}/config)
        target_compile_definitions(freertos_config INTERFACE projCOVERAGE_TEST=0)

        # Add FreeRTOS as a subdirectory
        add_subdirectory(FreeRTOS)

        # FreeRTOS-specific include directories
        include_directories(${PROJECT_SOURCE_DIR}/FreeRTOS/include)
        include_directories(${PROJECT_SOURCE_DIR}/FreeRTOS/portable/ThirdParty/GCC/Posix)
        include_directories(${PROJECT_SOURCE_DIR}/config)

        # Add FreeRTOS sources
        file(GLOB FREERTOS_SOURCES
            "${PROJECT_SOURCE_DIR}/FreeRTOS/*.c"
            "${PROJECT_SOURCE_DIR}/FreeRTOS/portable/MemMang/heap_4.c"
            "${PROJECT_SOURCE_DIR}/FreeRTOS/portable/ThirdParty/GCC/Posix/*.c"
        )

        # Create the main executable, depending on the FreeRTOS option
        # list(APPEND MAIN_SOURCES src/freertos_main.c src/freertos/freertos_posix_port.c ${FREERTOS_SOURCES})
        # list(APPEND MAIN_LIBS freertos_config freertos_kernel)

    else()
        message(STATUS "FreeRTOS is disabled")
        set(FREERTOS_SOURCES "")  # No FreeRTOS sources if FreeRTOS is disabled
        # list(APPEND MAIN_SOURCES src/main.c)
    endif()

endmacro()


# Define options for LVGL with default values (OFF)
macro(Define_options_for_LVGL_with_default_values)
    option(LV_USE_DRAW_SDL "Use SDL draw unit" OFF)
    option(LV_USE_LIBPNG "Use libpng to decode PNG" OFF)
    option(LV_USE_LIBJPEG_TURBO "Use libjpeg turbo to decode JPEG" OFF)
    option(LV_USE_FFMPEG "Use libffmpeg to display video using lv_ffmpeg" OFF)
    option(LV_USE_FREETYPE "Use freetype library" OFF)

    add_compile_definitions($<$<BOOL:${LV_USE_DRAW_SDL}>:LV_USE_DRAW_SDL=1>)
    add_compile_definitions($<$<BOOL:${LV_USE_LIBPNG}>:LV_USE_LIBPNG=1>)
    add_compile_definitions($<$<BOOL:${LV_USE_LIBJPEG_TURBO}>:LV_USE_LIBJPEG_TURBO=1>)
    add_compile_definitions($<$<BOOL:${LV_USE_FFMPEG}>:LV_USE_FFMPEG=1>)    
endmacro()


macro (add_lv_options_to_main_libs)
    # Conditionally include and link SDL2_image if LV_USE_DRAW_SDL is enabled
    if(LV_USE_DRAW_SDL)
        set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")
        find_package(SDL2_image REQUIRED)
        target_include_directories(lvgl PUBLIC ${SDL2_IMAGE_INCLUDE_DIRS})
        list(APPEND MAIN_LIBS ${SDL2_IMAGE_LIBRARIES})
    endif()

    # Conditionally include and link libpng if LV_USE_LIBPNG is enabled
    if(LV_USE_LIBPNG)
        find_package(PNG REQUIRED)
        target_include_directories(lvgl PUBLIC ${PNG_INCLUDE_DIRS})
        list(APPEND MAIN_LIBS ${PNG_LIBRARIES})
    endif()

    # Conditionally include and link libjpeg-turbo if LV_USE_LIBJPEG_TURBO is enabled
    if(LV_USE_LIBJPEG_TURBO)
        find_package(JPEG REQUIRED)
        target_include_directories(lvgl PUBLIC ${JPEG_INCLUDE_DIRS})
        list(APPEND MAIN_LIBS ${JPEG_LIBRARIES})
    endif()

    # Conditionally include and link FFmpeg libraries if LV_USE_FFMPEG is enabled
    if(LV_USE_FFMPEG)
        list(APPEND MAIN_LIBS avformat avcodec avutil swscale z)
    endif()
endmacro()


# Apply additional compile options if the build type is Debug
macro (if_debug_option)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(STATUS "Debug mode enabled")

        target_compile_options(lvgl PRIVATE
            -pedantic-errors
            -Wall
            -Wclobbered
            -Wdeprecated
            -Wdouble-promotion
            -Wempty-body
            -Wextra
            -Wformat-security
            -Wmaybe-uninitialized
            # -Wmissing-prototypes
            -Wpointer-arith
            -Wmultichar
            -Wno-pedantic # ignored for now, we convert functions to pointers for properties table.
            -Wreturn-type
            -Wshadow
            -Wshift-negative-value
            -Wsizeof-pointer-memaccess
            -Wtype-limits
            -Wundef
            -Wuninitialized
            -Wunreachable-code
            -Wfloat-conversion
            -Wstrict-aliasing
        )

        if (ASAN)
            message(STATUS "AddressSanitizer enabled")

            # Add AddressSanitizer flags
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address -fno-omit-frame-pointer")
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fsanitize=address -fno-omit-frame-pointer")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fsanitize=address")
            set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fsanitize=address")
        else()
            message(STATUS "AddressSanitizer disabled")
        endif()
    endif()
endmacro()
    
macro(if_compiled_for_windows)
    if (WIN32)
        if (MSVC)
            target_link_options(main PRIVATE "/SUBSYSTEM:CONSOLE")
        else()
            target_link_options(main PRIVATE "-mconsole")
        endif()
    endif()
endmacro()
