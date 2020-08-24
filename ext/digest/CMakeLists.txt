add_library(ruby-ext-digest STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/digest.c
    ${CMAKE_CURRENT_SOURCE_DIR}/bubblebabble/bubblebabble.c
    ${CMAKE_CURRENT_SOURCE_DIR}/md5/md5.c
    ${CMAKE_CURRENT_SOURCE_DIR}/md5/md5init.c
    ${CMAKE_CURRENT_SOURCE_DIR}/md5/md5ossl.c
    ${CMAKE_CURRENT_SOURCE_DIR}/rmd160/rmd160.c
    ${CMAKE_CURRENT_SOURCE_DIR}/rmd160/rmd160init.c
    ${CMAKE_CURRENT_SOURCE_DIR}/rmd160/rmd160ossl.c
    ${CMAKE_CURRENT_SOURCE_DIR}/sha1/sha1.c
    ${CMAKE_CURRENT_SOURCE_DIR}/sha1/sha1init.c
    ${CMAKE_CURRENT_SOURCE_DIR}/sha1/sha1ossl.c
    ${CMAKE_CURRENT_SOURCE_DIR}/sha2/sha2.c
    ${CMAKE_CURRENT_SOURCE_DIR}/sha2/sha2init.c)
  target_include_directories(ruby-ext-digest
      PRIVATE
        ${RUBY_INCLUDE_DIRS}
        ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(ruby-ext PRIVATE ruby-ext-digest)