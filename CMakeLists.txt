project(jumpnbump C)
cmake_minimum_required(VERSION 2.8)
include(FindPkgConfig)
aux_source_directory(. SRC_LIST)
aux_source_directory(sdl SRC_LIST)
pkg_check_modules(SDL REQUIRED sdl2)
pkg_check_modules(SDL_MIXER SDL2_mixer)
pkg_check_modules(SDL_NET SDL2_net)
if(NOT SDL_MIXER_FOUND)
	add_definitions(-DNO_SDL_MIXER)
endif()
if(NOT SDL_NET_FOUND)
	add_definitions(-DNO_SDL_NET)
endif()
include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} SYSTEM ${SDL_INCLUDE_DIRS} ${SDL_MIXER_INCLUDE_DIRS})
link_directories(${SDL_LIBRARY_DIRS} ${SDL_MIXER_LIBRARY_DIRS})
add_custom_command(OUTPUT version.h
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/generate_version_h.sh
  DEPENDS VERSION)
add_custom_command(OUTPUT jumpbump.dat
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/generate_jumpbump_dat.sh)
add_custom_command(OUTPUT jumpbump_dat.c
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/generate_jumpbump_dat_c.sh
  DEPENDS jumpbump.dat)
string (REPLACE ";" " " SDL_STATIC_LDFLAGS_STR "${SDL_STATIC_LDFLAGS} ${SDL_MIXER_STATIC_LDFLAGS} ${SDL_NET_STATIC_LDFLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${SDL_STATIC_LDFLAGS_STR}")
add_executable(${PROJECT_NAME} ${SRC_LIST} jumpbump_dat.c version.h)
target_link_libraries(${PROJECT_NAME} m ${SDL_LIBRARIES} ${SDL_MIXER_LIBRARIES})

