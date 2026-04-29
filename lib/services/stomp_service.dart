import 'package:stomp_dart_client/stomp_dart_client.dart';

class StompService {
  StompClient? stompClient; // nullable
  StompFrame? stompFrame;

  // Set up and connect the STOMP client
  void connect({
    required String serverUrl,
    required String destination,
    required Function(StompFrame frame) onMessage,
  }) {
    stompClient = StompClient(
      config: StompConfig(
        url: serverUrl,
        onConnect: (frame) {
          _onConnect(frame, destination, onMessage);
        },
        onDisconnect: _onDisconnect,
        heartbeatOutgoing: Duration(seconds: 10),
        heartbeatIncoming: Duration(seconds: 10),
        onStompError: _onStompError,
      ),

    );

    stompClient!.activate();
  }

  // Handle successful STOMP connection
  void _onConnect(
      StompFrame frame,
      String destination,
      Function(StompFrame frame) callback,
      ) {
    print('STOMP connected: ${frame.body}');
    stompClient?.subscribe(
      destination: destination,
      callback: (frame) {
        callback(frame);
      },
    );
  }

  // Handle STOMP disconnection
  void _onDisconnect(StompFrame frame) {
    print('STOMP disconnected: ${frame.body}');
  }

  // Handle STOMP errors
  void _onStompError(StompFrame frame) {
    print('STOMP error: ${frame.body}');
    print('STOMP error: ${frame.headers}');
  }

  // Disconnect the STOMP client
  void disconnect() {
    if (stompClient?.isActive ?? false) {
      stompClient?.deactivate();
      stompClient = null; // reset to avoid stale references
    }
  }
}