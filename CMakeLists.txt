project(jumpnbump C)
cmake_minimum_required(VERSION 2.8)
include(FindPkgConfig)
aux_source_directory(. SRC_LIST)
aux_source_directory(sdl SRC_LIST)
pkg_check_modules(SDL REQUIRED sdl2)
pkg_check_modules(SDL_MIXER REQUIRED SDL2_mixer)
include_directories(SYSTEM . ${SDL_INCLUDE_DIRS} ${SDL_MIXER_INCLUDE_DIRS})
link_directories(${SDL_LIBRARY_DIRS} ${SDL_MIXER_LIBRARY_DIRS})
add_custom_command(OUTPUT numbers.gob
	COMMAND tcc -run ${CMAKE_SOURCE_DIR}/modify/gobpack.c
		${CMAKE_SOURCE_DIR}/data/numbers)
add_custom_command(OUTPUT objects.gob
	COMMAND tcc -run ${CMAKE_SOURCE_DIR}/modify/gobpack.c
		${CMAKE_SOURCE_DIR}/data/objects)
add_custom_command(OUTPUT rabbit.gob
	COMMAND tcc -run ${CMAKE_SOURCE_DIR}/modify/gobpack.c
		${CMAKE_SOURCE_DIR}/data/rabbit)
add_custom_command(OUTPUT font.gob
	COMMAND tcc -run ${CMAKE_SOURCE_DIR}/modify/gobpack.c
		${CMAKE_SOURCE_DIR}/data/font)
add_custom_command(OUTPUT jumpbump.dat
	COMMAND tcc -run ${CMAKE_SOURCE_DIR}/modify/jnbpack.c
		-o jumpbump.dat
		${CMAKE_SOURCE_DIR}/data/bump.mod
		${CMAKE_SOURCE_DIR}/data/calib.dat
		${CMAKE_SOURCE_DIR}/data/death.smp
		${CMAKE_SOURCE_DIR}/data/fly.smp
		${CMAKE_SOURCE_DIR}/data/jump.mod
		${CMAKE_SOURCE_DIR}/data/jump.smp
		${CMAKE_SOURCE_DIR}/data/levelmap.txt
		${CMAKE_SOURCE_DIR}/data/level.pcx
		${CMAKE_SOURCE_DIR}/data/mask.pcx
		${CMAKE_SOURCE_DIR}/data/menu.pcx
		${CMAKE_SOURCE_DIR}/data/menumask.pcx
		${CMAKE_SOURCE_DIR}/data/scores.mod
		${CMAKE_SOURCE_DIR}/data/splash.smp
		${CMAKE_SOURCE_DIR}/data/spring.smp
		numbers.gob
		objects.gob
		rabbit.gob
		font.gob
	DEPENDS
		numbers.gob
		objects.gob
		rabbit.gob
		font.gob)
add_executable(${PROJECT_NAME} ${SRC_LIST} jumpbump.dat)
target_link_libraries(${PROJECT_NAME} m ${SDL_LIBRARIES} ${SDL_MIXER_LIBRARIES})

