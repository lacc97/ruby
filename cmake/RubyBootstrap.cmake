find_package(BISON REQUIRED)

find_program(RUBY_EXE ruby)

function(target_rb_erb_source target _scope _in)
  cmake_parse_arguments(ERB "" "" "ARGS;DEPENDS" ${ARGN})

  if(${_scope} STREQUAL PRIVATE)
    set(_scope PRIVATE)
  elseif(${_scope} STREQUAL PUBLIC)
    set(_scope PUBLIC)
  elseif(${_scope} STREQUAL INTERFACE)
    set(_scope INTERFACE)
  else()
    message(FATAL_ERROR "Visibility (PRIVATE, PUBLIC or INTERFACE) not specified for '${_scope}'")
  endif()

  # We process the source
  get_filename_component(_inAbsFile  ${_in} ABSOLUTE)
  get_filename_component(_inFile     ${_in} NAME)
  string(REGEX REPLACE ".tmpl$" "" _inBaseFile ${_inFile})

  set(_outDir     ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target}.dir/erb)
  set(_outFile ${_outDir}/${_inBaseFile})

  add_custom_command(OUTPUT ${_outFile}
      COMMAND               ${CMAKE_COMMAND} -E make_directory ${_outDir}
      COMMAND               ${RUBY_EXE} ${CMAKE_CURRENT_SOURCE_DIR}/tool/generic_erb.rb --output=${_outFile} ${_inAbsFile} ${ERB_ARGS}
      MAIN_DEPENDENCY       ${_inAbsFile}
      DEPENDS               ${CMAKE_CURRENT_SOURCE_DIR}/tool/generic_erb.rb ${ERB_DEPENDS}
      COMMENT               "Generating ${_inBaseFile}")
  target_include_directories(${target} ${_scope} ${_outDir})
  target_sources(${target} ${_scope} ${_outFile})
endfunction()

function(target_rb_insns_sources target)
  cmake_parse_arguments(INSNS "" "SRCDIR" "PRIVATE;PUBLIC;INTERFACE" ${ARGN})

  if(NOT INSNS_SRCDIR)
    set(INSNS_SRCDIR ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  if(INSNS_KEYWORDS_MISSING_VALUES)
    message(FATAL_ERROR "Must provide sources with some scope (PRIVATE, PUBLIC, INTERFACE)")
  endif()

  set(_outDir     ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target}.dir/insns)

  # We process the source
  function(add_insns_source _scope _in)
    get_filename_component(_inAbsFile  ${_in} ABSOLUTE)
    get_filename_component(_inFile     ${_in} NAME)
    string(REGEX REPLACE ".tmpl$" "" _inBaseFile ${_inFile})

    set(_outFile ${_outDir}/${_inBaseFile})

    add_custom_command(OUTPUT ${_outFile}
        COMMAND               ${CMAKE_COMMAND} -E make_directory ${_outDir}
        COMMAND               ${RUBY_EXE} -Ks ${CMAKE_CURRENT_SOURCE_DIR}/tool/insns2vm.rb --srcdir=${INSNS_SRCDIR} --output-directory=${_outDir} ${_inBaseFile}
        MAIN_DEPENDENCY       ${_inAbsFile}
        DEPENDS               ${CMAKE_CURRENT_SOURCE_DIR}/tool/insns2vm.rb
        COMMENT               "Generating ${_inBaseFile}")
    target_include_directories(${target} ${_scope} ${_outDir})
    target_sources(${target} ${_scope} ${_outFile})
  endfunction()

  foreach(_in ${INSNS_PRIVATE})
    add_insns_source(PRIVATE ${_in})
  endforeach()

  foreach(_in ${INSNS_PUBLIC})
    add_insns_source(PUBLIC ${_in})
  endforeach()

  foreach(_in ${INSNS_INTERFACE})
    add_insns_source(INTERFACE ${_in})
  endforeach()
endfunction()

function(target_rb_node_name target _nodeH)
  get_filename_component(_inAbsFile  ${_nodeH} ABSOLUTE)
  get_filename_component(_inFile     ${_nodeH} NAME)

  set(_outDir ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target}.dir/node_name)
  set(_outFile ${_outDir}/node_name.inc)

  set(_rubyCmd "'${RUBY_EXE}' -n '${CMAKE_CURRENT_SOURCE_DIR}/tool/node_name.rb'")

  add_custom_command(OUTPUT ${_outFile}
      COMMAND               ${CMAKE_COMMAND} -E make_directory ${_outDir}
      COMMAND               sh -c "${_rubyCmd}" < ${_inAbsFile} > ${_outFile}
      MAIN_DEPENDENCY       ${_inAbsFile}
      DEPENDS               ${CMAKE_CURRENT_SOURCE_DIR}/tool/node_name.rb
      COMMENT               "Generating ${_inFile}")
  target_include_directories(${target} PRIVATE ${_outDir})
  target_sources(${target} PRIVATE ${_outFile})
endfunction()

function(target_rb_parse_source target _parseY)
  get_filename_component(_inAbsFile  ${_parseY} ABSOLUTE)
  get_filename_component(_inFile     ${_parseY} NAME)
  string(REGEX REPLACE ".y$" "" _inBaseFile ${_inFile})

  set(_outDir     ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target}.dir/bison)
  set(_outFileSrc ${_outDir}/${_inBaseFile}.c)
  set(_outFileHdr ${_outDir}/${_inBaseFile}.h)

  add_custom_command(OUTPUT ${_outFileSrc} ${_outFileHdr}
      COMMAND               ${CMAKE_COMMAND} -E make_directory ${_outDir}
      COMMAND               ${BISON_EXECUTABLE} --defines=${_outFileHdr} --output=${_outFileSrc} ${_inAbsFile}
      COMMAND               sed -i -f ${CMAKE_CURRENT_SOURCE_DIR}/tool/ytab.sed ${_outFileSrc}
      MAIN_DEPENDENCY       ${_inAbsFile}
      DEPENDS               ${CMAKE_CURRENT_SOURCE_DIR}/tool/ytab.sed
      COMMENT               "Generating bison parser from ${_inFile}")
  target_include_directories(${target} PRIVATE ${_outDir})
  target_sources(${target} PRIVATE ${_outFileSrc} ${_outFileHdr})
endfunction()

function(target_rb_prelude_source target _prelude)
  cmake_parse_arguments(PRELUDE "" "" "SCRIPTS" ${ARGN})

  if(PRELUDE_KEYWORDS_MISSING_VALUES)
    message(FATAL_ERROR "Must provide prelude scripts (with SCRIPTS)")
  endif()

  set(MINIRUBY_COMMAND ${RUBY_EXE} -I${CMAKE_CURRENT_SOURCE_DIR})
  set(COMPILE_PRELUDE_COMMAND ${MINIRUBY_COMMAND} -I${PROJECT_SOURCE_DIR} ${PROJECT_SOURCE_DIR}/tool/compile_prelude.rb)

  set(_outDir     ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target}.dir/prelude)
  set(_outFile    ${_outDir}/${_prelude}.c)

  add_custom_command(OUTPUT ${_outFile}
      COMMAND               ${CMAKE_COMMAND} -E make_directory ${_outDir}
      COMMAND               ${COMPILE_PRELUDE_COMMAND} ${PRELUDE_SCRIPTS} ${_outFile}
      DEPENDS               ${PROJECT_SOURCE_DIR}/tool/compile_prelude.rb
                            ${PRELUDE_SCRIPTS}
      COMMENT               "Generating prelude ${_prelude}.c")
  target_include_directories(${target} PRIVATE ${_outDir})
  target_sources(${target} PRIVATE ${_outFile})
endfunction()

function(target_rb_transcode_sources target)
  cmake_parse_arguments(TRANSCODE "" "" "PRIVATE;PUBLIC;INTERFACE" ${ARGN})

  if(TRANSCODE_KEYWORDS_MISSING_VALUES)
    message(FATAL_ERROR "Must provide sources with some scope (PRIVATE, PUBLIC, INTERFACE)")
  endif()

  set(_outDir     ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target}.dir/transcode)

  # We process the source
  function(add_transcode_source _scope _in)
    get_filename_component(_inAbsFile  ${_in} ABSOLUTE)
    get_filename_component(_inFile     ${_in} NAME)
    string(REGEX REPLACE ".trans$" "" _inBaseFile ${_inFile})

    set(_outFile ${_outDir}/${_inBaseFile}.c)

    add_custom_command(OUTPUT ${_outFile}
        COMMAND               ${CMAKE_COMMAND} -E make_directory ${_outDir}
        COMMAND               ${RUBY_EXE} ${PROJECT_SOURCE_DIR}/tool/transcode-tblgen.rb -vo ${_outFile} ${_inAbsFile}
        MAIN_DEPENDENCY       ${_inAbsFile}
        DEPENDS               ${PROJECT_SOURCE_DIR}/tool/transcode-tblgen.rb
        COMMENT               "Generating transcode table ${_inBaseFile}.c")
    target_include_directories(${target} ${_scope} ${_outDir})
    target_sources(${target} ${_scope} ${_outFile})
  endfunction()

  foreach(_in ${TRANSCODE_PRIVATE})
    add_transcode_source(PRIVATE ${_in})
  endforeach()

  foreach(_in ${TRANSCODE_PUBLIC})
    add_transcode_source(PUBLIC ${_in})
  endforeach()

  foreach(_in ${TRANSCODE_INTERFACE})
    add_transcode_source(INTERFACE ${_in})
  endforeach()
endfunction()