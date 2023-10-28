import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart';

late Socket socket;
String? firstName, lastName;

class SignallingService {
  static init() {
    // init Socket

    String webSocketUrl = "https://gabbi-api.enyata.com/";
    String roomName = "743f7074-5190-474f-a54e-e4322e2fd907";
    String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTMwMjViNjlhNWYwYmYyOWI3NWQ1N2MiLCJlbWFpbEFkZHJlc3MiOiJ1c2Vyb25lQHlvcG1haWwuY29tIiwiaWF0IjoxNjk4NDIyMDQwLCJleHAiOjE2OTg0MjM4NDB9.IKdQYo4a5SyB7oKy0fAJkAiy2sFApQV6mptPYcy5Y7o";

    socket = io(
      webSocketUrl,
      OptionBuilder()
          .setTransports(["websocket"])
          .setAuth({
            "auth": {"token": token}
          })
          .setAuth({"token": token})
          .setExtraHeaders({"Connection": "Upgrade", "Upgrade": "websocket"})
          .setTimeout(30000)
          .enableReconnection()
          .enableForceNew()
          .build(),
    );
    socket.onAny((event, data) {
      log("Socket $event: $data");
      if (event == "new-user") {
        firstName = data["user"]["firstName"];
        lastName = data["user"]["lastName"];
      }
    });

    socket.on("connection-success", (data) {
      log("Socket id: ${data["socketId"]}");
    });

    // listen onConnect event
    socket.onConnect((data) {
      log("Socket connected: $data");
    });

    socket.emitWithAck("joinRoom", {"roomName": roomName}, ack: (res) {
      log("Join: $res");
      // mediaRtpCapabilities = res["rtpCapabilities"];

      // createDevice();
    });

    // listen onConnectError event
    socket.onConnectError((data) {
      log("Connect Error $data");
    });
  }
}
