# Copyright (c) .NET Foundation and contributors. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

cmake_minimum_required (VERSION 2.6)
project(hostpolicy)

if(WIN32)
    add_compile_options($<$<CONFIG:RelWithDebInfo>:/MT>)
    add_compile_options($<$<CONFIG:Release>:/MT>)
    add_compile_options($<$<CONFIG:Debug>:/MTd>)
else()
    add_compile_options(-fPIC)
    add_compile_options(-fvisibility=hidden)
endif()

include(../setup.cmake)

# Include directories
if(WIN32)
    include_directories("${CLI_CMAKE_RESOURCE_DIR}/hostpolicy")
endif()
include_directories(../)
include_directories(../../)
include_directories(../../common)
include_directories(../fxr)
include_directories(../json/casablanca/include)

# CMake does not recommend using globbing since it messes with the freshness checks
set(SOURCES
    ../../common/trace.cpp
    ../../common/utils.cpp
    ../libhost.cpp
    ../runtime_config.cpp
    ../json/casablanca/src/json/json.cpp
    ../json/casablanca/src/json/json_parsing.cpp
    ../json/casablanca/src/json/json_serialization.cpp
    ../json/casablanca/src/utilities/asyncrt_utils.cpp
    ../fxr/fx_ver.cpp
    ../breadcrumbs.cpp
    ../args.cpp
    ../hostpolicy.cpp
    ../host_startup_info.cpp
    ../coreclr.cpp
    ../deps_resolver.cpp
    ../deps_format.cpp
    ../deps_entry.cpp
    ../fx_definition.cpp
    ../fx_reference.cpp
    ../version.cpp
)


if(WIN32)
    list(APPEND SOURCES 
        ../../common/pal.windows.cpp
        ../../common/longfile.windows.cpp)
else()
    list(APPEND SOURCES
        ../../common/pal.unix.cpp
        ${VERSION_FILE_PATH})
endif()

add_definitions(-D_NO_ASYNCRTIMP)
add_definitions(-D_NO_PPLXIMP)
add_definitions(-DEXPORT_SHARED_API=1)

set(RESOURCES)
if(WIN32)
    list(APPEND RESOURCES ../native.rc)
endif()
add_library(hostpolicy SHARED ${SOURCES} ${RESOURCES})
set_target_properties(hostpolicy PROPERTIES MACOSX_RPATH TRUE)

# Specify the import library to link against for Arm32 build since the default set is minimal
if (WIN32 AND CLI_CMAKE_PLATFORM_ARCH_ARM)
    target_link_libraries(hostpolicy shell32.lib)
endif()

install_library_and_symbols (hostpolicy)
