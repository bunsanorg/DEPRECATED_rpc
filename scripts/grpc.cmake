find_program(GRPC_CPP_PLUGIN_EXECUTABLE NAMES grpc_cpp_plugin)
find_path(GRPC_INCLUDE_DIRS NAMES grpc/grpc.h)
find_path(GRPCXX_INCLUDE_DIRS NAMES grpc++/channel_interface.h)
find_library(GRPC_LIBRARIES NAMES grpc)
find_library(GRPCXX_LIBRARIES NAMES grpc++)

message("Found grpc plugin at ${GRPC_CPP_PLUGIN_EXECUTABLE}")
message("Found grpc headers at ${GRPC_INCLUDE_DIRS}")
message("Found grpc library at ${GRPC_LIBRARIES}")
message("Found grpc++ headers at ${GRPCXX_INCLUDE_DIRS}")
message("Found grpc++ library at ${GRPCXX_LIBRARIES}")

macro(bunsan_add_rpc_cxx_library)
    bunsan_add_protobuf_cxx_library(
        PLUGINS "grpc_cpp=${GRPC_CPP_PLUGIN_EXECUTABLE}"
        ${ARGN}
    )
endmacro()
