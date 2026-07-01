/// Canonical screen path shim.
///
/// The foundation contract reserves the name `package:bisu_app/screens/<file>.dart`
/// for every screen, while each screen was implemented under
/// `lib/features/<area>/`. This file re-exports the real implementation so that
/// `import 'package:bisu_app/screens/login_screen.dart';` resolves to the
/// canonical [LoginScreen] (full-Scaffold auth flow page).
library;

export 'package:bisu_app/features/auth/login_screen.dart';
