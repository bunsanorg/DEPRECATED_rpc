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
* strict static type system, less bug-prone than JSON or XML
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

    service Service {
        rpc Call1 (Request) returns (Response);
        rpc Call2 (Request) returns (Response);
    }

Each RPC has Request and Response messages.

### Handles
User defined messages can contain special handle objects
defined in [`bunsan.rpc.handle`](../include/bunsan/rpc/handle.proto) package.
Handle objects link data from different entry into message
via special interface provided by RPC implementation.
User can access this data via handle in a way most suitable for that.

`bunsan.rpc.handle.Handle` is implementation defined. For each handled type
separate class is provided, such as `FileHandle`. In these classes all fields
except `handle` are considered public. These fields may be set by implementation
at handle creation time, but later they remain unchanged.
See documentation for specified handle for additional details.

#### File handle
`bunsan.rpc.handle.FileHandle` is used for file transmission.
File is specified by filesystem path upon send
and at the destination point is stored into file.
User can access it via filesystem path.
RAM usage for file transmission does not depend on file size.
Implementation provides no guarantees regarding file location and name.

## Remote call
Service handles RPCs on specified URL, e.g. `http://example.com/service`.
Method names is transmitted as part of request header.
Service does not forward invalid RPCs to user's implementation.
Transport error is reported by transport itself (e.g. HTTP404).
Otherwise error is reported by RPC.

### RPC errors
RPC handles the following error conditions during request:
* Unknown RPC &ndash; there is no remote procedure with specified name
* Invalid request &ndash; unable to parse request

Also remote procedure can fail, in that case:
* Unhandled exception &ndash; remote procedure returned exception

## Transport

### Request
Only POST method is used for RPC.
Other methods are never used by RPC
and allowed to be used for extensions,
such as HTML interface.

### Data format
HTTP is used with special data types `multipart/bunsan-rpc-request`
and `multipart/bunsan-rpc-response` which allows sending
named blobs of known length. Using this data format
proto messages as well as files or other data can be sent over HTTP.

`multipart/bunsan-rpc-request` is defined by EBNF

    bunsan-rpc-request = request header, separator, { entry };
    request header = base64 encoded bunsan.rpc.header.RequestHeader;

`multipart/bunsan-rpc-response` is defined by EBNF

    bunsan-rpc-response = response header, separator, { entry };
    response header = base64 encoded bunsan.rpc.header.ResponseHeader;

Common EBNF

    entry = entry header, separator, data, separator;
    entry header = base64 encoded bunsan.rpc.header.EntryHeader;
    separator = CRLF;
    data = raw data of specified size;

See [`bunsan.rpc.header`](../include/bunsan/rpc/header.proto) for details.

### Transfer encoding
Implementation is allowed to use any wide-supported transfer encoding.

# Examples

## Example 1

### Declarations

    message MyRequest {
        required string question = 1;
        required bunsan.rpc.handle.FileHandle file = 2;
    }
    message MyResponse {
        required string answer = 1;
        required bunsan.rpc.handle.FileHandle file1 = 2;
        required bunsan.rpc.handle.FileHandle file2 = 3;
    }
    rpc MyService {
        rpc MyQuestion (MyRequest) returns (MyResponse);
    }

### Client

    channel = bunsan.rpc.http.NewChannel("http://host:port/script")
    stub = MyService(channel)
    file = stub.register(bunsan.rpc.FileHandle, path="/my/file")
    file.name = "picture.png"
    request = MyRequest(question="What is displayed here?", file=file)
    response = stub.MyQuestion(request)
    print(response.answer)
    received_file1 = response.file1
    received_file2 = response.file2
    for i in [received_file1, received_file2]:
      print("Name =", i.name)
      print("mime-type =", i.mime_type)
      print("Location =", stub.handle_file(i))

### Server

    class Rpc(RpcStub):
        def MyQuestion(request):
            print(request.question)
            path1 = self.handle_file(response.file)
            file1 = self.register(bunsan.rpc.FileHandle, path1)
            path2 = transform(path1)
            file2 = self.register(bunsan.rpc.FileHandle, path2)
            return MyResponse(answer="I don't know.", file1=file1, file2=file2)
