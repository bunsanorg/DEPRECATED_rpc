find_program(GRPC_CPP_PLUGIN_EXECUTABLE NAMES grpc_cpp_plugin)
find_library(GRPC_LIBRARY NAMES grpc)
find_library(GRPCXX_LIBRARY NAMES grpc++)

message("Found grpc plugin at ${GRPC_CPP_PLUGIN_EXECUTABLE}")
message("Found grpc library at ${GRPC_LIBRARY}")
message("Found grpc++ library at ${GRPCXX_LIBRARY}")

macro(bunsan_add_rpc_cxx_library)
    bunsan_add_protobuf_cxx_library(
        PLUGINS "grpc_cpp=${GRPC_CPP_PLUGIN_EXECUTABLE}"
        ${ARGN}
    )
endmacro()
