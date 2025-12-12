cmake_minimum_required(VERSION 3.5)

set(SDK_PATH "${CMAKE_CURRENT_LIST_DIR}/Deps/ESP8266_RTOS_SDK")
set(ENV{IDF_PATH} "${SDK_PATH}")

# Tell IDF that there is a component in ./Application
set(EXTRA_COMPONENT_DIRS "${CMAKE_CURRENT_LIST_DIR}/Application")

# Load ESP8266 RTOS SDK CMake build system + toolchain
include($ENV{IDF_PATH}/tools/cmake/project.cmake)

# Just name the project; IDF handles compilers, languages, etc.
project(wifi_moisture_sensor)