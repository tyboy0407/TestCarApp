import 'package:flutter/material.dart';
import '../widgets/knowledge_interactive_widgets.dart';

class CarKnowledgeScreen extends StatelessWidget {
  const CarKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 增加為 3 個 Tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('購車知識庫', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            isScrollable: false,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: '市場概況'),
              Tab(text: '技術解析'),
              Tab(text: '基本術語'), // 新增 Tab
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MarketOverviewTab(),
            TechAnalysisTab(),
            TerminologyTab(), // 新增 頁面
          ],
        ),
      ),
    );
  }
}

class MarketOverviewTab extends StatelessWidget {
  const MarketOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('2025-2026 台灣小型油電休旅市場'),
        _buildCard(
          title: '執行摘要',
          content: '隨著全球汽車產業加速邁向電氣化，台灣汽車市場在 2025 年迎來了關鍵轉折點。小型休旅車 (Compact SUV / CUV) 憑藉靈活車身與高機能性，已取代中型房車成為市場主流.\n\n在能源轉型下，油電混合動力 (HEV) 與類電動系統 (Series Hybrid) 成為最佳解決方案。',
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('混合動力技術路徑 (點擊翻牌)'),
        _buildInteractiveTechCard(
          title: 'Full Hybrid (HEV)',
          subtitle: '如 Toyota THS-II、Honda i-MMD',
          description: '具備純電行駛能力，節能效果最顯著。引擎與馬達可獨立或協同工作，是目前最成熟的油電技術。',
          icon: Icons.battery_charging_full,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildInteractiveTechCard(
          title: 'Series Hybrid (增程型)',
          subtitle: '如 Nissan e-POWER',
          description: '引擎僅作為發電機，不直接驅動車輪。駕駛感受與電動車完全相同，擁有強勁且線性的扭力輸出。',
          icon: Icons.electric_car,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildInteractiveTechCard(
          title: 'Mild Hybrid (MHEV)',
          subtitle: '如 Suzuki 48V、Kia 48V',
          description: '結構簡單，馬達僅輔助起步與滑行熄火，無法純電行駛。主要優勢在於成本較低且能改善市區油耗。',
          icon: Icons.energy_savings_leaf,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildInteractiveTechCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      height: 180,
      child: KnowledgeFlipCard(
        front: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color.withOpacity(0.8))),
              const SizedBox(height: 4),
              Text('點擊查看詳情', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        back: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 20),
              Text(subtitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
              const SizedBox(height: 8),
              Expanded(
                child: Text(description, style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TechAnalysisTab extends StatelessWidget {
  const TechAnalysisTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('雙強鼎立：技術護城河'),
        _buildExpansionCard(
          title: 'Honda HR-V e:HEV',
          subtitle: '駕馭靈活與空間機能的標竿',
          children: [
            _buildListTile('e:HEV 系統', '以電為主，以油為輔。市區行駛時引擎發電供馬達驅動 (類電動車)，高速巡航時離合器接合引擎直驅。'),
            _buildListTile('強大扭力', '25.8 kg-m 扭力，輸出線性無頓挫。'),
            _buildListTile('Magic Seat', '獨家油箱前移設計，具備 Tally Mode (增高)、Long Mode (長形)、Utility Mode (全平) 三種模式。'),
            _buildListTile('操控基因', '強化車身剛性與重新設計襯套，過彎側傾抑制佳。'),
          ],
        ),
        const SizedBox(height: 16),
        _buildExpansionCard(
          title: 'Toyota Corolla Cross Hybrid',
          subtitle: '穩定務實與都會通勤的標竿',
          children: [
            _buildListTile('THS II 系統', '行星齒輪組無段變速，追求極致熱效率與舒適平穩。'),
            _buildListTile('鋰電池升級', '2025/2026 年式全面換裝鋰離子電池，重量更輕、充放電效率更高。'),
            _buildListTile('TNGA-C 平台', '低重心與高剛性，懸吊設定偏軟，適合台灣道路坑洞過濾。'),
            _buildListTile('持有成本', '極高的市場保有量，維修保養便宜，二手殘值高。'),
          ],
        ),
        const SizedBox(height: 16),
        _buildExpansionCard(
          title: 'Nissan Kicks e-POWER',
          subtitle: '最接近電動車的激進派',
          children: [
            _buildListTile('100% 純電驅動', '引擎完全斷開車輪，僅作發電機。'),
            _buildListTile('e-Pedal', '單踏板模式，利用動能回收煞車力道，減少踩踏煞車頻率。'),
            _buildListTile('靜謐性', '引擎僅在電池低電量或大動力需求時啟動。'),
          ],
        ),
      ],
    );
  }
}

// 基本術語介紹頁面
class TerminologyTab extends StatelessWidget {
  const TerminologyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('常見保險種類'),

        _buildExpansionCard(
          title: '強制汽車責任保險(強制險)',
          subtitle: '法律規定一定要保，沒保不能領牌上路',
          children: [
            _buildListTile('保障範圍', '只有「人」，不賠「車」。'),
            _buildListTile('理賠條件', '賠「對方」的人傷，以及「我方乘客」的人傷，我方駕駛（駕駛人自己）受傷是不賠的'),
          ],
        ),

        const SizedBox(height: 12),

        _buildExpansionCard(
          title: '第三人責任險',
          subtitle: '你的「資產的防火牆」',
          children: [
            _buildListTile('保障性質', '這張保單由兩個部分組成，額度是分開計算的。'),
            _buildListTile('(1)傷害責任', '包含對方的醫療費、看護費、薪資損失、精神慰撫金等。'),
            _buildListTile('(2)財損責任', '對方的車子維修費、路燈、招牌、甚至名貴寵物的醫療費。'),
          ],
        ),

        const SizedBox(height: 12),

        _buildExpansionCard(
          title: '超額責任險',
          subtitle: '俗稱「超跑險」',
          children: [
            _buildListTile('保障性質', '屬於「附加險」，必須先投保「第三人責任險」後才能加保。'),
            _buildListTile('核心功能', '當前兩層保額賠不夠時（如撞到豪車或嚴重傷亡），由超額險補足。'),
            _buildListTile('建議保額', '建議至少投保 1,000 萬元，目前年保費僅約 1,000 至 2,000 元。'),
          ],
        ),

        const SizedBox(height: 24),
        _buildSectionTitle('車體險分類 (賠自己的車)'),

        _buildExpansionCard(
          title: '甲式車體險',
          subtitle: '帝王級的保障',
          children: [
            _buildListTile('保障範圍', '包含乙式內容，再加上「第三人非惡意行為」與「不明原因」損壞。'),
            _buildListTile('適用對象', '頂級豪車或極度愛車、預算非常充足的車主。'),
          ],
        ),

        const SizedBox(height: 12),

        _buildExpansionCard(
          title: '乙式車體險',
          subtitle: '常規級保障 (最受歡迎)',
          children: [
            _buildListTile('保障範圍', '碰撞、擦撞、火災、閃電、雷擊、拋擲物或掉落物等。'),
            _buildListTile('適用對象', '新車前 3 到 5 年、對自己技術沒把握或環境風險高者。'),
          ],
        ),

        const SizedBox(height: 12),

        _buildExpansionCard(
          title: '丙式車體險',
          subtitle: '最基本的保障',
          children: [
            _buildListTile('保障範圍', '僅限「車碰車」。'),
            _buildListTile('關鍵條件', '必須確認對方車輛，且需有警察開立之三聯單。'),
          ],
        ),

        const SizedBox(height: 32),
        _buildSectionTitle('第三人責任理賠順序圖'),
        _buildInsuranceLayerFlow(),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildInsuranceLayerFlow() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildFlowStep(
            step: '1',
            title: '第一層：強制險',
            desc: '優先賠付人身傷害\n(上限 20萬醫療 / 200萬死殘)',
            color: Colors.red.shade600,
            isLast: false,
          ),
          _buildFlowStep(
            step: '2',
            title: '第二層：第三人責任險',
            desc: '補足強制險不足的人身部分\n並負擔所有「財損」賠償',
            color: Colors.orange.shade600,
            isLast: false,
          ),
          _buildFlowStep(
            step: '3',
            title: '第三層：超額責任險',
            desc: '【最後防線】當前兩層保額全數賠完時才啟動\n(應付超高額賠償如撞超跑)',
            color: Colors.yellow.shade700,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFlowStep({
    required String step,
    required String title,
    required String desc,
    required Color color,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Text(
                step,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: color.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

// Helper Widgets

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    ),
  );
}

Widget _buildCard({required String title, required String content}) {
  return Card(
    elevation: 2,
    surfaceTintColor: Colors.white,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black54)),
        ],
      ),
    ),
  );
}

Widget _buildExpansionCard({
  required String title,
  required String subtitle,
  required List<Widget> children,
}) {
  return Card(
    elevation: 2,
    surfaceTintColor: Colors.white,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      childrenPadding: const EdgeInsets.all(16),
      children: children,
    ),
  );
}

Widget _buildListTile(String title, String content) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
              children: [
                TextSpan(text: '$title：', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: content),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
