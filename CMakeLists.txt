project(bunsan_rpc)

include(${CMAKE_SOURCE_DIR}/system-config.cmake OPTIONAL)

cmake_minimum_required(VERSION 3.0)

find_package(BunsanCMake CONFIG REQUIRED)

bunsan_install_module(NAME BunsanRpc
                      DIRECTORIES scripts/)

bunsan_add_shared_library(${PROJECT_NAME}
    src/lib/global_state.cpp
)
bunsan_use_bunsan_package(${PROJECT_NAME} bunsan_common bunsan_common)
target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
        ${GRPC_INCLUDE_DIRS}
        ${GRPCXX_INCLUDE_DIRS}
)
target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC
        ${GRPC_LIBRARIES}
        ${GRPCXX_LIBRARIES}
)

bunsan_install_headers()
bunsan_install_targets(${PROJECT_NAME})
bunsan_install_project()

bunsan_include_tests()
