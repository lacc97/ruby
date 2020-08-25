target_sources(ruby-ext
    PRIVATE
      ${CMAKE_CURRENT_SOURCE_DIR}/date_core.c
      ${CMAKE_CURRENT_SOURCE_DIR}/date_parse.c
      ${CMAKE_CURRENT_SOURCE_DIR}/date_strftime.c
      ${CMAKE_CURRENT_SOURCE_DIR}/date_strptime.c)