project(jumpnbump C)
cmake_minimum_required(VERSION 2.8)
include(FindPkgConfig)
aux_source_directory(. SRC_LIST)
aux_source_directory(sdl SRC_LIST)
pkg_check_modules(SDL REQUIRED sdl2)
pkg_check_modules(SDL_MIXER SDL2_mixer)
if(NOT SDL_MIXER_FOUND)
	add_definitions(-DNO_SDL_MIXER)
endif()
include_directories(. SYSTEM ${SDL_INCLUDE_DIRS} ${SDL_MIXER_INCLUDE_DIRS})
link_directories(${SDL_LIBRARY_DIRS} ${SDL_MIXER_LIBRARY_DIRS})
add_custom_command(OUTPUT jumpbump.dat
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/generate_jumpbump_dat.sh)
add_custom_command(OUTPUT jumpbump_dat.c
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/generate_jumpbump_dat_c.sh
  DEPENDS jumpbump.dat)
add_executable(${PROJECT_NAME} ${SRC_LIST} jumpbump_dat.c)
target_link_libraries(${PROJECT_NAME} m ${SDL_LIBRARIES} ${SDL_MIXER_LIBRARIES})

