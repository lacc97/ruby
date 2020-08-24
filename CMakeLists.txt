cmake_minimum_required(VERSION 3.18)
project(ruby C)


include(cmake/FlexBison.cmake)


find_program(GPERF gperf REQUIRED)


add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/autoconf/include/ruby/config.h
    COMMAND               ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/autoconf
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/common.mk
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/common.mk
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/configure.in
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/configure.in
    COMMAND               ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/include
                                                             ${CMAKE_CURRENT_BINARY_DIR}/autoconf/include
    COMMAND               ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/enc
                                                             ${CMAKE_CURRENT_BINARY_DIR}/autoconf/enc
    COMMAND               ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/tool
                                                             ${CMAKE_CURRENT_BINARY_DIR}/autoconf/tool
    COMMAND               ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/template
                                                             ${CMAKE_CURRENT_BINARY_DIR}/autoconf/template
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/Makefile.in
                                                   ${CMAKE_CURRENT_BINARY_DIR}/autoconf/Makefile.in
    COMMAND               ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR}/autoconf autoconf
    COMMAND               ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR}/autoconf sh ./configure CC=${CMAKE_C_COMPILER} CFLAGS=${CMAKE_C_FLAGS}
    MAIN_DEPENDENCY       ${CMAKE_CURRENT_SOURCE_DIR}/configure.in
                          ${CMAKE_CURRENT_SOURCE_DIR}/enc
                          ${CMAKE_CURRENT_SOURCE_DIR}/include
                          ${CMAKE_CURRENT_SOURCE_DIR}/Makefile.in
                          ${CMAKE_CURRENT_SOURCE_DIR}/tool)

add_library(ruby-headers STATIC
    ${CMAKE_CURRENT_BINARY_DIR}/autoconf/include/ruby/config.h)
  set_target_properties(ruby-headers PROPERTIES
      LINKER_LANGUAGE           "C")
  target_include_directories(ruby-headers
      PUBLIC
        ${CMAKE_CURRENT_BINARY_DIR}/autoconf/include)


add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/lex.h
    COMMAND               ${GPERF} -C -p -j1 -i 1 -g -o -t -N rb_reserved_word -k1,3,$$ --output-file=${CMAKE_CURRENT_BINARY_DIR}/lex.h ${CMAKE_CURRENT_SOURCE_DIR}/defs/keywords
    MAIN_DEPENDENCY       ${CMAKE_CURRENT_SOURCE_DIR}/defs/keywords)

add_library(ruby STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/array.c
    ${CMAKE_CURRENT_SOURCE_DIR}/bignum.c
    ${CMAKE_CURRENT_SOURCE_DIR}/class.c
    ${CMAKE_CURRENT_SOURCE_DIR}/compar.c
    ${CMAKE_CURRENT_SOURCE_DIR}/compile.c
    ${CMAKE_CURRENT_SOURCE_DIR}/complex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/cont.c
    ${CMAKE_CURRENT_SOURCE_DIR}/dir.c
    ${CMAKE_CURRENT_SOURCE_DIR}/debug.c
#    ${CMAKE_CURRENT_SOURCE_DIR}/dln.c
    ${CMAKE_CURRENT_SOURCE_DIR}/dln_find.c
    ${CMAKE_CURRENT_SOURCE_DIR}/dmyext.c
#    ${CMAKE_CURRENT_SOURCE_DIR}/dmyversion.c
#    ${CMAKE_CURRENT_SOURCE_DIR}/encoding.c
    ${CMAKE_CURRENT_SOURCE_DIR}/enum.c
    ${CMAKE_CURRENT_SOURCE_DIR}/enumerator.c
    ${CMAKE_CURRENT_SOURCE_DIR}/error.c
    ${CMAKE_CURRENT_SOURCE_DIR}/eval.c
#    ${CMAKE_CURRENT_SOURCE_DIR}/eval_error.c
    ${CMAKE_CURRENT_SOURCE_DIR}/file.c
    ${CMAKE_CURRENT_SOURCE_DIR}/gc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hash.c
#    ${CMAKE_CURRENT_SOURCE_DIR}/id.c
    ${CMAKE_CURRENT_SOURCE_DIR}/inits.c
    ${CMAKE_CURRENT_SOURCE_DIR}/io.c
    ${CMAKE_CURRENT_SOURCE_DIR}/iseq.c
    ${CMAKE_CURRENT_BINARY_DIR}/lex.h
    ${CMAKE_CURRENT_SOURCE_DIR}/load.c
    ${CMAKE_CURRENT_SOURCE_DIR}/marshal.c
    ${CMAKE_CURRENT_SOURCE_DIR}/math.c
    ${CMAKE_CURRENT_SOURCE_DIR}/node.c
    ${CMAKE_CURRENT_SOURCE_DIR}/numeric.c
    ${CMAKE_CURRENT_SOURCE_DIR}/object.c
    ${CMAKE_CURRENT_SOURCE_DIR}/pack.c
    ${CMAKE_CURRENT_SOURCE_DIR}/proc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/process.c
    ${CMAKE_CURRENT_SOURCE_DIR}/random.c
    ${CMAKE_CURRENT_SOURCE_DIR}/range.c
    ${CMAKE_CURRENT_SOURCE_DIR}/re.c
    ${CMAKE_CURRENT_SOURCE_DIR}/regcomp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/regenc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/regerror.c
    ${CMAKE_CURRENT_SOURCE_DIR}/regexec.c
    ${CMAKE_CURRENT_SOURCE_DIR}/regparse.c
    ${CMAKE_CURRENT_SOURCE_DIR}/regsyntax.c
    ${CMAKE_CURRENT_SOURCE_DIR}/ruby.c
    ${CMAKE_CURRENT_SOURCE_DIR}/signal.c
    ${CMAKE_CURRENT_SOURCE_DIR}/sprintf.c
    ${CMAKE_CURRENT_SOURCE_DIR}/st.c
    ${CMAKE_CURRENT_SOURCE_DIR}/strftime.c
    ${CMAKE_CURRENT_SOURCE_DIR}/string.c
    ${CMAKE_CURRENT_SOURCE_DIR}/struct.c
    ${CMAKE_CURRENT_SOURCE_DIR}/thread.c
    ${CMAKE_CURRENT_SOURCE_DIR}/time.c
    ${CMAKE_CURRENT_SOURCE_DIR}/transcode.c
    ${CMAKE_CURRENT_SOURCE_DIR}/util.c
    ${CMAKE_CURRENT_SOURCE_DIR}/variable.c
    ${CMAKE_CURRENT_SOURCE_DIR}/vm.c
    ${CMAKE_CURRENT_SOURCE_DIR}/vm_dump.c)
  set_target_properties(ruby PROPERTIES
      C_VISIBILITY_PRESET     "hidden")
#  target_compile_definitions(ruby
#      PRIVATE
#        _GNU_SOURCE=1)
  target_compile_features(ruby
      PRIVATE
        c_std_99)
  target_include_directories(ruby
      PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR})
  target_bison_sources(ruby
      PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/parse.y)
  target_link_libraries(ruby
      PRIVATE
        ruby-headers
        ${CMAKE_DL_LIBS}
        crypt)

add_subdirectory(ext)