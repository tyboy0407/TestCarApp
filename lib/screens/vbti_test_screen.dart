import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VBTITestScreen extends StatefulWidget {
  const VBTITestScreen({super.key});

  @override
  State<VBTITestScreen> createState() => _VBTITestScreenState();
}

class _VBTITestScreenState extends State<VBTITestScreen> {
  late VideoPlayerController _controller;
  bool _hasStarted = false;
  int _currentQuestionIndex = 0;
  
  // Scores for each axis
  int _pScore = 0; 
  int _eScore = 0; 
  int _sScore = 0; 
  int _iScore = 0; 
  int _bScore = 0; 
  int _hScore = 0; 
  int _uScore = 0; 
  int _dScore = 0; 

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '1. 當您看中一台車時，第一眼會注意什麼？',
      'options': [
        {'text': '空間表現與油耗數據', 'axis': 'P'},
        {'text': '車身線條與品牌魅力', 'axis': 'E'},
      ],
    },
    {
      'question': '2. 關於車內配備，哪一項對您來說是必備的？',
      'options': [
        {'text': '完整的主被動安全系統 (如 7 氣囊)', 'axis': 'S'},
        {'text': '超大觸控螢幕與聯網智慧功能', 'axis': 'I'},
      ],
    },
    {
      'question': '3. 在購車預算上，您的態度傾向是？',
      'options': [
        {'text': '嚴格守住預算，追求極致 CP 值', 'axis': 'B'},
        {'text': '願意為更好的質感與配備稍微超支', 'axis': 'H'},
      ],
    },
    {
      'question': '4. 您主要的用車場景大多在？',
      'options': [
        {'text': '市區通勤，好停車與靈活性最重要', 'axis': 'U'},
        {'text': '假日郊遊，上山下海與探險能力不可少', 'axis': 'D'},
      ],
    },
    {
      'question': '5. 朋友問您為什麼買這台車，您的回答會是？',
      'options': [
        {'text': '因為它保值、耐用且養護成本低', 'axis': 'P'},
        {'text': '因為它讓我開出去有面子，心情愉快', 'axis': 'E'},
      ],
    },
    {
      'question': '6. 面對最新的自動駕駛輔助技術，您的看法是？',
      'options': [
        {'text': '穩定最重要，我更相信成熟的機械結構', 'axis': 'S'},
        {'text': '非常興奮，我喜歡嘗試最尖端的黑科技', 'axis': 'I'},
      ],
    },
    {
      'question': '7. 關於車室內裝的材質，您的要求是？',
      'options': [
        {'text': '耐髒、易清潔、實用性高即可', 'axis': 'B'},
        {'text': '軟質塑料、真皮縫線與優異的隔音', 'axis': 'H'},
      ],
    },
    {
      'question': '8. 您理想中的假日生活是？',
      'options': [
        {'text': '在城市間穿梭，探訪巷弄美食與百貨', 'axis': 'U'},
        {'text': '載著裝備去露營或前往未知的林道', 'axis': 'D'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/highway.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0); // 靜音
        _controller.play();
        setState(() {}); // 確保影片初始化後刷新 UI
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _answerQuestion(String axis) {
    setState(() {
      switch (axis) {
        case 'P': _pScore++; break;
        case 'E': _eScore++; break;
        case 'S': _sScore++; break;
        case 'I': _iScore++; break;
        case 'B': _bScore++; break;
        case 'H': _hScore++; break;
        case 'U': _uScore++; break;
        case 'D': _dScore++; break;
      }
      _currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasStarted) {
      return _buildIntroPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('VBTI 購車性格測驗', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _currentQuestionIndex < _questions.length
          ? _buildQuiz()
          : _buildResult(),
    );
  }

  Widget _buildIntroPage() {
    return Scaffold(
      body: Stack(
        children: [
          // 影片背景
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Container(color: Colors.black), // 載入中背景色

          // 深色濾鏡遮罩
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // 內容
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.psychology, size: 100, color: Colors.white),
                  const SizedBox(height: 32),
                  const Text(
                    'VBTI',
                    style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 8),
                  ),
                  const Text(
                    'Vehicle Buying Type Indicator',
                    style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      '透過 8 個簡單的問題，分析您的購車潛意識，找出最契合您的性格代碼與建議車款。',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 64),
                  ElevatedButton(
                    onPressed: () => setState(() => _hasStarted = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('開始測驗', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('先不用，謝謝', style: TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuiz() {
    final q = _questions[_currentQuestionIndex];
    double progress = (_currentQuestionIndex + 1) / _questions.length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: Colors.black,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 48),
          Text(
            '問題 ${_currentQuestionIndex + 1}',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            q['question'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
          ),
          const Spacer(),
          ... (q['options'] as List).map((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () => _answerQuestion(opt['axis']),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black12, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(opt['text'], style: const TextStyle(fontSize: 18)),
            ),
          )),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildResult() {
    String res1 = _pScore >= _eScore ? 'P' : 'E';
    String res2 = _sScore >= _iScore ? 'S' : 'I';
    String res3 = _bScore >= _hScore ? 'B' : 'H';
    String res4 = _uScore >= _dScore ? 'U' : 'D';
    String resultType = res1 + res2 + res3 + res4;

    Map<String, String> typeNames = {
      'P': 'Practical (實用派)',
      'E': 'Emotional (感性派)',
      'S': 'Safety (安全守護)',
      'I': 'Innovation (科技控)',
      'B': 'Budget (精打細算)',
      'H': 'High-quality (品質追求)',
      'U': 'Urban (都市穿梭)',
      'D': 'Discovery (冒險探險)',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            const Text('您的購車性格是', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              resultType,
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, letterSpacing: 4),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildResultRow(res1, typeNames[res1]!),
                  const Divider(height: 24),
                  _buildResultRow(res2, typeNames[res2]!),
                  const Divider(height: 24),
                  _buildResultRow(res3, typeNames[res3]!),
                  const Divider(height: 24),
                  _buildResultRow(res4, typeNames[res4]!),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('完成並返回', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String code, String label) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 18,
          child: Text(code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
