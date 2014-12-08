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

# Specifications
Protocol has two layers: transport and message.
From the transport's point of view message is a binary string.

## Message
RPC is declared with standard Google Protobuf syntax

    service Rpc {
        rpc Call (Request) returns (Response);
    }

Each RPC has Request and Response messages.

### File transfer
For file transfer special system class is provided:
`bunsan.rpc.FileHandle` which behaves as file handle.
For each file to be sent user should allocate handle
by library call specifying path to file.
For each received file user can use this handle
to get its path on filesystem.

FileHandle is implementation-defined message,
user should not rely on its contents.

## Transport
### Data format
HTTP is used with special data format `multipart/bunsan-rpc`,
which allows sending named blobs of known length.
Using this data format proto messages as well as files
can be sent over HTTP.

`multipart/bunsan-rpc` is defined by EBNF

    bunsan-rpc = { entry };
    entry = id, separator, size, separator, data, separator;
    id = base64 encoded data; (* it is assumed to be reasonably small *)
    separator = CRLF;
    size = HEX number of bytes;
    data = raw data of specified size;

### Transfer encoding
Implementation is allowed to use any wide-supported transfer encoding.
