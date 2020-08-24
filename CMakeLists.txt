cmake_minimum_required(VERSION 3.18)
project(ruby C)


include(cmake/FlexBison.cmake)


find_package(OpenSSL REQUIRED)


add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/config.h
    COMMAND               ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/autoconf
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/config.guess
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/config.guess
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/config.sub
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/config.sub
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/configure.in
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/configure.in
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/install-sh
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/install-sh
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/Makefile.in
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/Makefile.in
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/version.h
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/version.h
    COMMAND               ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR}/autoconf autoconf
    COMMAND               ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR}/autoconf sh ./configure CC=${CMAKE_C_COMPILER} CFLAGS=${CMAKE_C_FLAGS}
    MAIN_DEPENDENCY       ${CMAKE_CURRENT_SOURCE_DIR}/configure.in
    DEPENDS               ${CMAKE_CURRENT_SOURCE_DIR}/Makefile.in
                          ${CMAKE_CURRENT_SOURCE_DIR}/version.h)

add_library(ruby STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/array.c
    ${CMAKE_CURRENT_SOURCE_DIR}/bignum.c
    ${CMAKE_CURRENT_SOURCE_DIR}/class.c
    ${CMAKE_CURRENT_SOURCE_DIR}/compar.c
    ${CMAKE_CURRENT_BINARY_DIR}/config.h
    ${CMAKE_CURRENT_SOURCE_DIR}/dir.c
    ${CMAKE_CURRENT_SOURCE_DIR}/dln.c
    ${CMAKE_CURRENT_SOURCE_DIR}/enum.c
    ${CMAKE_CURRENT_SOURCE_DIR}/enumerator.c
    ${CMAKE_CURRENT_SOURCE_DIR}/error.c
    ${CMAKE_CURRENT_SOURCE_DIR}/eval.c
    ${CMAKE_CURRENT_SOURCE_DIR}/file.c
    ${CMAKE_CURRENT_SOURCE_DIR}/gc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hash.c
    ${CMAKE_CURRENT_SOURCE_DIR}/inits.c
    ${CMAKE_CURRENT_SOURCE_DIR}/io.c
    ${CMAKE_CURRENT_SOURCE_DIR}/marshal.c
    ${CMAKE_CURRENT_SOURCE_DIR}/object.c
    ${CMAKE_CURRENT_SOURCE_DIR}/pack.c
    ${CMAKE_CURRENT_SOURCE_DIR}/process.c
    ${CMAKE_CURRENT_SOURCE_DIR}/prec.c
    ${CMAKE_CURRENT_SOURCE_DIR}/random.c
    ${CMAKE_CURRENT_SOURCE_DIR}/range.c
    ${CMAKE_CURRENT_SOURCE_DIR}/re.c
    ${CMAKE_CURRENT_SOURCE_DIR}/regex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby.c
    ${CMAKE_CURRENT_SOURCE_DIR}/signal.c
    ${CMAKE_CURRENT_SOURCE_DIR}/sprintf.c
    ${CMAKE_CURRENT_SOURCE_DIR}/st.c
    ${CMAKE_CURRENT_SOURCE_DIR}/string.c
    ${CMAKE_CURRENT_SOURCE_DIR}/struct.c
    ${CMAKE_CURRENT_SOURCE_DIR}/time.c
    ${CMAKE_CURRENT_SOURCE_DIR}/util.c
    ${CMAKE_CURRENT_SOURCE_DIR}/variable.c
    ${CMAKE_CURRENT_SOURCE_DIR}/version.c)
  set_target_properties(ruby PROPERTIES
      C_VISIBILITY_PRESET     "hidden")
#  target_compile_definitions(ruby
#      PRIVATE
#        _GNU_SOURCE=1)
  target_include_directories(ruby
      PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_BINARY_DIR}/autoconf)
  target_bison_sources(ruby
      PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/parse.y)
  target_link_libraries(ruby
      PRIVATE
        OpenSSL::Crypto)
