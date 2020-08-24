cmake_minimum_required(VERSION 3.18)
project(ruby C)


include(cmake/FlexBison.cmake)


find_program(GPERF gperf REQUIRED)


add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/lex.h
    COMMAND               ${GPERF} -p -j1 -i 1 -g -o -t -N rb_reserved_word -k1,3,$$ --output-file=${CMAKE_CURRENT_BINARY_DIR}/lex.h ${CMAKE_CURRENT_SOURCE_DIR}/keywords
    MAIN_DEPENDENCY       ${CMAKE_CURRENT_SOURCE_DIR}/keywords)

add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/autoconf/config.h
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
    ${CMAKE_CURRENT_BINARY_DIR}/autoconf/config.h
    ${CMAKE_CURRENT_SOURCE_DIR}/dir.c
    ${CMAKE_CURRENT_SOURCE_DIR}/dln.c
    ${CMAKE_CURRENT_SOURCE_DIR}/dmyext.c
    ${CMAKE_CURRENT_SOURCE_DIR}/enum.c
    ${CMAKE_CURRENT_SOURCE_DIR}/enumerator.c
    ${CMAKE_CURRENT_SOURCE_DIR}/error.c
    ${CMAKE_CURRENT_SOURCE_DIR}/eval.c
    ${CMAKE_CURRENT_SOURCE_DIR}/file.c
    ${CMAKE_CURRENT_SOURCE_DIR}/gc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hash.c
    ${CMAKE_CURRENT_SOURCE_DIR}/inits.c
    ${CMAKE_CURRENT_SOURCE_DIR}/io.c
    ${CMAKE_CURRENT_BINARY_DIR}/lex.h
    ${CMAKE_CURRENT_SOURCE_DIR}/marshal.c
    ${CMAKE_CURRENT_SOURCE_DIR}/math.c
    ${CMAKE_CURRENT_SOURCE_DIR}/numeric.c
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
  target_compile_features(ruby
      PRIVATE
        c_std_99)
  target_include_directories(ruby
      INTERFACE
        ${CMAKE_CURRENT_BINARY_DIR}/include
      PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}/autoconf
        ${CMAKE_CURRENT_SOURCE_DIR})
  target_bison_sources(ruby
      PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/parse.y)
  target_link_libraries(ruby
      PRIVATE
        ${CMAKE_DL_LIBS}
        OpenSSL::Crypto)

add_custom_command(TARGET ruby POST_BUILD
    COMMAND               ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/include/ruby
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/autoconf/config.h
                                                   ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/config.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/defines.h
                                                   ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/defines.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/dln.h
                                                   ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/dln.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/env.h
                                                   ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/env.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/intern.h
                                                   ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/intern.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/missing.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/missing.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/node.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/node.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/re.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/re.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/regex.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/regex.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/ruby.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/ruby.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/rubyio.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/rubyio.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/rubysig.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/sig.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/st.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/st.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/util.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/util.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/version.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby/version.h
    COMMAND               ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/ruby_top.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/ruby.h)