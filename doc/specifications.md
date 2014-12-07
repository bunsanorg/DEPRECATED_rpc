# Description

## Transport
HTTP is used as transport.

Advantages of HTTP:
* HTTP is kinda binary RPC itself
* authentication support
* SSL support, which can be used for authentication too
* a lot of existing stable implementations
* proxy-friendly
* works well with web-apps design, web-app can implement
  RPC service as regular web-page
* can failover to HTML for human browser if required
* supports small auxiliary messages &ndash; headers
* file transmission can be implemented efficiently with existing
  libraries

Disadvantages:
* relatively big overhead for small messages

## Message
Google Protocol Buffers are used for structured data handling.

Advantages:
* strict static type system, less bug-prone then JSON or XML
* standard syntax for RPC service declaration
* fast
* cross-platform and cross-language support
* easy to extend with custom plugin

Disadvantages:
* hard to debug because of binary format
