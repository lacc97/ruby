find_package(Iconv REQUIRED)

target_sources(ruby-ext
    PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}/iconv.c)
target_link_libraries(ruby-ext
    PRIVATE
      Iconv::Iconv)