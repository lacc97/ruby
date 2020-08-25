add_library(ruby-enc  STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/ascii.c
    ${CMAKE_CURRENT_SOURCE_DIR}/us_ascii.c
    ${CMAKE_CURRENT_SOURCE_DIR}/unicode.c
    ${CMAKE_CURRENT_SOURCE_DIR}/utf_8.c)
  target_include_directories(ruby-enc
      PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/..)
  target_rb_transcode_sources(ruby-enc
      PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/trans/chinese.trans
        ${CMAKE_CURRENT_SOURCE_DIR}/trans/japanese.trans
        ${CMAKE_CURRENT_SOURCE_DIR}/trans/japanese_euc.trans
        ${CMAKE_CURRENT_SOURCE_DIR}/trans/japanese_sjis.trans
        ${CMAKE_CURRENT_SOURCE_DIR}/trans/korean.trans
        ${CMAKE_CURRENT_SOURCE_DIR}/trans/newline.trans
        ${CMAKE_CURRENT_SOURCE_DIR}/trans/single_byte.trans
        ${CMAKE_CURRENT_SOURCE_DIR}/trans/utf_16_32.trans)
  target_link_libraries(ruby-enc
      PRIVATE
        ruby-headers)

target_link_libraries(ruby PRIVATE ruby-enc)