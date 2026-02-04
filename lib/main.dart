import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const JOSStudioApp());
}

class JOSStudioApp extends StatelessWidget {
  const JOSStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jOS Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00D9FF),
          secondary: const Color(0xFF00FF88),
          surface: const Color(0xFF1E1E1E),
          background: const Color(0xFF0D1117),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF161B22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isConnected = false;
  String _connectionType = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00D9FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'jOS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00D9FF),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Studio Mobile'),
          ],
        ),
        actions: [
          // Connection Status
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isConnected 
                  ? Colors.green.withOpacity(0.2) 
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isConnected ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isConnected ? Icons.link : Icons.link_off,
                  size: 16,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  _isConnected ? _connectionType : '연결 안됨',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboard(),
          _buildTerminal(),
          _buildDataTable(),
          _buildDevices(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: const Color(0xFF161B22),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: '대시보드',
          ),
          NavigationDestination(
            icon: Icon(Icons.terminal_outlined),
            selectedIcon: Icon(Icons.terminal),
            label: '터미널',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_chart_outlined),
            selectedIcon: Icon(Icons.table_chart),
            label: 'DataTable',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_outlined),
            selectedIcon: Icon(Icons.devices),
            label: '디바이스',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Connect
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: Color(0xFF00D9FF)),
                      const SizedBox(width: 8),
                      const Text(
                        '빠른 연결',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ConnectButton(
                          icon: Icons.usb,
                          label: 'USB OTG',
                          onTap: () => _connectUSB(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ConnectButton(
                          icon: Icons.wifi,
                          label: 'WiFi',
                          onTap: () => _connectWiFi(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick Commands
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.code, color: Color(0xFF00FF88)),
                      const SizedBox(width: 8),
                      const Text(
                        '빠른 명령',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _QuickCommand(label: 'sys', onTap: () => _sendCommand('sys')),
                      _QuickCommand(label: 'ps', onTap: () => _sendCommand('ps')),
                      _QuickCommand(label: 'wifi info', onTap: () => _sendCommand('wifi info')),
                      _QuickCommand(label: 'lora 0 status', onTap: () => _sendCommand('lora 0 status')),
                      _QuickCommand(label: 'reboot', onTap: () => _sendCommand('reboot'), danger: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // System Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFFFFD700)),
                      const SizedBox(width: 8),
                      const Text(
                        '시스템 정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(label: '상태', value: _isConnected ? '연결됨' : '연결 안됨'),
                  _InfoRow(label: '연결 방식', value: _connectionType),
                  _InfoRow(label: '디바이스', value: '-'),
                  _InfoRow(label: '펌웨어', value: '-'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminal() {
    return Column(
      children: [
        // Terminal Output
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF30363D)),
            ),
            child: const SingleChildScrollView(
              child: SelectableText(
                'jOS Shell v4.0\n'
                '연결 대기중...\n'
                '\n'
                'jOS:\$ _',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Color(0xFF00FF88),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        // Input
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFF161B22),
            border: Border(top: BorderSide(color: Color(0xFF30363D))),
          ),
          child: Row(
            children: [
              const Text(
                'jOS:\$ ',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Color(0xFF00D9FF),
                ),
              ),
              Expanded(
                child: TextField(
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '명령어 입력...',
                    hintStyle: TextStyle(color: Colors.grey),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (cmd) => _sendCommand(cmd),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF00D9FF)),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'DataTable Viewer',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '디바이스 연결 후 사용 가능',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDevices() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.usb, color: Color(0xFF00D9FF)),
            title: const Text('USB 디바이스 스캔'),
            subtitle: const Text('USB OTG로 연결된 ESP32 검색'),
            trailing: const Icon(Icons.search),
            onTap: () => _scanUSB(),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.wifi, color: Color(0xFF00FF88)),
            title: const Text('WiFi 디바이스 스캔'),
            subtitle: const Text('네트워크의 jOS 디바이스 검색'),
            trailing: const Icon(Icons.search),
            onTap: () => _scanWiFi(),
          ),
        ),
        const Divider(height: 32),
        Text(
          '저장된 디바이스',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.memory, color: Colors.orange),
            ),
            title: const Text('LoraDI Node #1'),
            subtitle: const Text('마지막 연결: -'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  void _connectUSB() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('USB OTG 연결 시도중...')),
    );
    // TODO: Implement USB Serial connection
  }

  void _connectWiFi() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('WiFi 연결 설정...')),
    );
    // TODO: Implement WebSocket connection
  }

  void _sendCommand(String cmd) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('명령 전송: $cmd')),
    );
    // TODO: Send command via transport
  }

  void _scanUSB() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('USB 디바이스 스캔중...')),
    );
  }

  void _scanWiFi() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('WiFi 디바이스 스캔중...')),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161B22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('jOS Studio Mobile'),
              subtitle: const Text('v1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('jOS 프로젝트'),
              subtitle: const Text('github.com/jujueng/jOS'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ConnectButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0D1117),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF30363D)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF00D9FF)),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickCommand extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _QuickCommand({
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: danger 
          ? Colors.red.withOpacity(0.2) 
          : const Color(0xFF00FF88).withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              color: danger ? Colors.red : const Color(0xFF00FF88),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
