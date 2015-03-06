#include <bunsan/rpc/global_state.hpp>

#include <bunsan/application/global_registry.hpp>
#include <bunsan/logging/trivial.hpp>
#include <bunsan/static_initializer.hpp>

#include <grpc/grpc.h>
#include <grpc/support/log.h>

namespace bunsan{namespace rpc
{
    namespace
    {
        logging::severity get_severity(gpr_log_severity severity)
        {
            switch (severity)
            {
            case GPR_LOG_SEVERITY_DEBUG:
                return logging::severity::debug;
            case GPR_LOG_SEVERITY_INFO:
                return logging::severity::info;
            case GPR_LOG_SEVERITY_ERROR:
                return logging::severity::error;
            default:
                return logging::severity::info;
            }
        }

        void log_callback(gpr_log_func_args *args)
        {
            BOOST_LOG_STREAM_WITH_PARAMS(
                ::bunsan::logging::trivial::global::get(),
                (::boost::log::keywords::severity =
                     ::bunsan::rpc::get_severity(args->severity))
                (::bunsan::logging::keywords::file = args->file)
                (::bunsan::logging::keywords::line = args->line)
                (::bunsan::logging::keywords::function = "???")
                (::bunsan::logging::keywords::pretty_function = "???")
            ) << args->message;
        }
    }

    global_state::global_state()
    {
        BUNSAN_LOG_DEBUG << "Initializing gRPC";
        grpc_init();
        gpr_set_log_function(&log_callback);
    }

    global_state::~global_state()
    {
        BUNSAN_LOG_DEBUG << "Shutting down gRPC";
        grpc_shutdown();
    }

    BUNSAN_STATIC_INITIALIZER(bunsan_rpc_global_state,
    {
        application::global_registry::register_unique_state_factory<global_state>();
    })
}}
