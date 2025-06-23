import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleAuthClient extends http.BaseClient {
  final String _accessToken;
  final http.Client _inner = http.Client();

    final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/calendar'],
        clientId: '424765658032-f8itgc6sq26kaiuue3tki816vgv5euth.apps.googleusercontent.com', // optional if meta is set
    );

  GoogleAuthClient(this._accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _inner.send(request);
  }
}

Future<http.Client?> getGoogleAuthClient() async {
  final googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/calendar'],
  );

  final account = await googleSignIn.signIn();
  if (account == null) return null;

  final auth = await account.authentication;
  return GoogleAuthClient(auth.accessToken!);
}
