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

// 新增：基本術語介紹頁面
class TerminologyTab extends StatelessWidget {
  const TerminologyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('車險基本術語'),

        _buildExpansionCard(
          title: '甲式車體險',
          subtitle: '帝王級的車體保障',
          children: [
            _buildListTile('保障範圍', '包含乙式的所有內容，再加上「第三人非惡意行為」與「不明原因」'),
            _buildListTile('理賠條件', '「不明原因」理賠的情況如:找不到兇手、沒錄影、沒目擊者，甲式照樣理賠，其餘狀況皆理賠'),
            _buildListTile('適用對象', '頂級豪車（千萬超跑）、極度愛車的「龜毛」車主，或者是預算非常充足、完全不想為車操心的人。'),
            _buildListTile('優缺點', '保費最昂貴(6~10萬+)，基本上包含【任意情況】都可以進行理賠。'),
          ],
        ),

        const SizedBox(height: 16),


        _buildExpansionCard(
          title: '乙式車體險',
          subtitle: '常規級的車體保障(最受歡迎)',
          children: [
            _buildListTile('保障範圍', '碰撞、擦撞、火災、閃電、雷擊、爆炸、拋擲物或掉落物'),
            _buildListTile('理賠條件', '路上所遇之常見情況基本上都有理賠，即使是自己倒車入庫撞到自家的鐵捲門，乙式也會賠'),
            _buildListTile('適用對象', '剛買新車的前 3 到 5 年、對自己技術沒把握，或是擔心停車環境有風險的人。'),
            _buildListTile('優缺點', '保費一般(3~5萬)，相較於丙式保障的更加全面(自撞or他撞)皆有理賠。'),
          ],
        ),

        const SizedBox(height: 16),



        _buildExpansionCard(
          title: '丙式車體險',
          subtitle: '最基本的車體保障',
          children: [
            _buildListTile('保障範圍', '僅限與「車」發生碰撞、擦撞所導致的損失。'),
            _buildListTile('理賠條件', '必須確認對方車輛，且需有報警紀錄（警察處理後開立三聯單）方可理賠。'),
            _buildListTile('適用對象', '車齡較老（5年以上）、預算有限，或駕駛技術純熟、僅擔心被他人撞到的車主。'),
            _buildListTile('優缺點', '保費最便宜(1~2萬)，但若自行撞牆、撞電線桿或找不到肇事車輛時，不予理賠。'),
          ],
        ),
        
        const SizedBox(height: 16),
        
        _buildExpansionCard(
          title: '超額責任險',
          subtitle: '俗稱「超跑險」',
          children: [
            _buildListTile('保障性質', '屬於「附加險」，必須先投保「第三人責任險」後才能加保。'),
            _buildListTile('核心功能', '當車禍發生，賠償對方的體傷或財損超過第三人責任險的保額時，由超額險補足差額。'),
            _buildListTile('適用情境', '不慎撞到勞斯萊斯、法拉利等高價名車，或是造成嚴重人員傷亡，理賠金額動輒數百萬甚至上千萬時。'),
            _buildListTile('建議保額', '建議至少投保 1,000 萬元，目前年保費僅約 1,000 至 2,000 元，CP值極高。'),
            _buildListTile('為什麼超額險很重要？', '一般的第三人責任險財損保額通常僅有 20-50 萬，在路上隨便擦撞到進口車就可能不夠賠。超額險能以極低的成本，換取高額的保障，是現代駕駛必備的防護。'),
          ],
        ),
        
        const SizedBox(height: 24),

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
