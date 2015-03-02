find_program(GRPC_CPP_PLUGIN_EXECUTABLE NAMES grpc_cpp_plugin)
find_path(GRPC_INCLUDE_DIRS NAMES grpc/grpc.h)
find_path(GRPCXX_INCLUDE_DIRS NAMES grpc++/channel_interface.h)
find_library(GRPC_LIBRARIES NAMES grpc)
find_library(GRPCXX_LIBRARIES NAMES grpc++)

macro(bunsan_rpc_required var descr)
    if(NOT ${var})
        message(SEND_ERROR "${descr} not found")
    endif()
endmacro()

bunsan_rpc_required(GRPC_CPP_PLUGIN_EXECUTABLE "grpc plugin")
bunsan_rpc_required(GRPC_INCLUDE_DIRS "grpc headers")
bunsan_rpc_required(GRPC_LIBRARIES "grpc library")
bunsan_rpc_required(GRPCXX_INCLUDE_DIRS "grpc++ headers")
bunsan_rpc_required(GRPCXX_LIBRARIES "grpc++ library")

macro(bunsan_add_rpc_cxx_library)
    bunsan_add_protobuf_cxx_library(
        PLUGINS "grpc_cpp=${GRPC_CPP_PLUGIN_EXECUTABLE}"
        ${ARGN}
    )
endmacro()
