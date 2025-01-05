part of 'dashboard_screen.dart';

abstract class DashboardController extends State<DashboardScreen> {

  final TextEditingController _messageTextController = TextEditingController();

  @override
  void dispose() {
    _messageTextController.dispose();
    manager.disconnect();
    super.dispose();
  }
}