add_library(ruby-missing STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/setproctitle.c)
  target_link_libraries(ruby-missing
      PRIVATE
        ruby-headers)

target_link_libraries(ruby
    PRIVATE
      ruby-missing)