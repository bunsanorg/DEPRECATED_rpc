#pragma once

#include <boost/noncopyable.hpp>

namespace bunsan{namespace rpc
{
    class global_state: private boost::noncopyable
    {
    public:
        global_state();
        ~global_state();

    private:
        static const bool registered;
    };
}}
