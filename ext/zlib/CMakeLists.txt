find_package(ZLIB REQUIRED)

target_sources(ruby-ext
    PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}/zlib.c)
target_link_libraries(ruby-ext
    PRIVATE
      ZLIB::ZLIB)