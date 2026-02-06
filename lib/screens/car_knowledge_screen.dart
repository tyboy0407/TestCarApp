import 'package:flutter/material.dart';
import '../widgets/knowledge_interactive_widgets.dart';

class CarKnowledgeScreen extends StatelessWidget {
  const CarKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('購車知識庫', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: '市場概況'),
              Tab(text: '技術解析'),
              Tab(text: '規格比較'),
              Tab(text: '購車建議'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MarketOverviewTab(),
            TechAnalysisTab(),
            ComparisonTableTab(),
            RecommendationsTab(),
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
      height: 180, // Fixed height for flip card
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

class ComparisonTableTab extends StatefulWidget {
  const ComparisonTableTab({super.key});

  @override
  State<ComparisonTableTab> createState() => _ComparisonTableTabState();
}

class _ComparisonTableTabState extends State<ComparisonTableTab> {
  int _selectedChart = 0; // 0: Fuel, 1: Price, 2: Torque

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('可視化數據對比'),
                // Toggle Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('平均油耗 (km/L)', 0),
                      const SizedBox(width: 8),
                      _buildFilterChip('入手門檻 (萬)', 1),
                      const SizedBox(width: 8),
                      _buildFilterChip('最大扭力 (kg-m)', 2),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildChartContent(),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('完整規格表'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
                    columns: const [
                      DataColumn(label: Text('車款', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('動力形式', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('排氣量', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('油耗 (km/L)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('價格 (萬)', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('核心優勢', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      _buildDataRow('Honda HR-V', 'Full Hybrid', '1.5L', '23.5', '90.9-98.9', '空間機能、類電動感'),
                      _buildDataRow('Toyota CC', 'Full Hybrid', '1.8L', '23.5', '98.5-98.9', '舒適、高保值'),
                      _buildDataRow('Nissan Kicks', 'Series Hybrid', '1.2L', '22.0', '104.9', '純電驅動感、e-Pedal'),
                      _buildDataRow('Hyundai Kona', 'Full Hybrid', '1.6L', '24-26', '96-102', 'DCT變速箱、歐系操控'),
                      _buildDataRow('Suzuki S-Cross', '48V Mild', '1.4T', '19.4', '98-114', '四驅、歐製剛性'),
                      _buildDataRow('Lexus LBX', 'Full Hybrid', '1.5L', '26.4', '129.9+', '豪華質感、油耗王者'),
                      _buildDataRow('Yaris Cross', '汽油', '1.5L', '17.5', '72.5-83.5', '價格親民、大空間'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    return FilterChip(
      label: Text(label),
      selected: _selectedChart == index,
      onSelected: (bool selected) {
        setState(() {
          _selectedChart = index;
        });
      },
      selectedColor: Colors.black,
      labelStyle: TextStyle(
        color: _selectedChart == index ? Colors.white : Colors.black,
        fontWeight: _selectedChart == index ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildChartContent() {
    switch (_selectedChart) {
      case 0:
        return InteractiveBarChart(
          title: '平均油耗表現',
          unit: 'km/L',
          maxValue: 30,
          items: [
            BarChartItem(label: 'Lexus LBX', value: 26.4, displayValue: '26.4', color: Colors.green.shade700),
            BarChartItem(label: 'Hyundai Kona', value: 25.0, displayValue: '25.0 (est)', color: Colors.green.shade600),
            BarChartItem(label: 'Honda HR-V', value: 23.5, displayValue: '23.5', color: Colors.green),
            BarChartItem(label: 'Toyota CC', value: 23.5, displayValue: '23.5', color: Colors.green),
            BarChartItem(label: 'Nissan Kicks', value: 22.0, displayValue: '22.0', color: Colors.green.shade400),
            BarChartItem(label: 'Suzuki S-Cross', value: 19.4, displayValue: '19.4', color: Colors.green.shade300),
            BarChartItem(label: 'Yaris Cross', value: 17.5, displayValue: '17.5', color: Colors.orange.shade300),
          ],
        );
      case 1:
        return InteractiveBarChart(
          title: '入手門檻',
          unit: '萬 (TWD)',
          maxValue: 140,
          items: [
            BarChartItem(label: 'Yaris Cross', value: 72.5, displayValue: '72.5', color: Colors.blue.shade300),
            BarChartItem(label: 'Honda HR-V', value: 90.9, displayValue: '90.9', color: Colors.blue.shade400),
            BarChartItem(label: 'Hyundai Kona', value: 96.0, displayValue: '96.0', color: Colors.blue.shade500),
            BarChartItem(label: 'Suzuki S-Cross', value: 98.0, displayValue: '98.0', color: Colors.blue.shade600),
            BarChartItem(label: 'Toyota CC', value: 98.5, displayValue: '98.5', color: Colors.blue.shade700),
            BarChartItem(label: 'Nissan Kicks', value: 104.9, displayValue: '104.9', color: Colors.indigo.shade400),
            BarChartItem(label: 'Lexus LBX', value: 129.9, displayValue: '129.9', color: Colors.indigo.shade900),
          ],
        );
      case 2:
        return InteractiveBarChart(
          title: '最大扭力表現',
          unit: 'kg-m',
          maxValue: 30,
          items: [
            BarChartItem(label: 'Nissan Kicks', value: 28.5, displayValue: '28.5', color: Colors.red.shade900),
            BarChartItem(label: 'Hyundai Kona', value: 27.0, displayValue: '27.0', color: Colors.red.shade700),
            BarChartItem(label: 'Honda HR-V', value: 25.8, displayValue: '25.8', color: Colors.red.shade600),
            BarChartItem(label: 'Suzuki S-Cross', value: 23.9, displayValue: '23.9', color: Colors.red.shade400),
            BarChartItem(label: 'Lexus LBX', value: 18.8, displayValue: '18.8', color: Colors.orange.shade800),
            BarChartItem(label: 'Yaris Cross', value: 14.1, displayValue: '14.1', color: Colors.grey),
            // Toyota CC torque data is complex (engine + motor), using system or primary source approximation
            BarChartItem(label: 'Toyota CC', value: 16.6, displayValue: '16.6 (引擎)', color: Colors.grey),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  DataRow _buildDataRow(String car, String type, String cc, String eff, String price, String pros) {
    return DataRow(cells: [
      DataCell(Text(car, style: const TextStyle(fontWeight: FontWeight.w600))),
      DataCell(Text(type)),
      DataCell(Text(cc)),
      DataCell(Text(eff)),
      DataCell(Text(price)),
      DataCell(Text(pros)),
    ]);
  }
}

class RecommendationsTab extends StatelessWidget {
  const RecommendationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('兩大核心軸向'),
        const SizedBox(height: 10),
        _buildStrategyCard(
          title: '軸向 A：駕馭靈活與空間機能',
          targetAudience: '重視「以人為本」的機械極小化、空間極大化，以及線性加速與駕駛樂趣。',
          recommendations: [
            '首選：Honda HR-V e:HEV (空間魔術師)',
            '激進派：Nissan Kicks e-POWER (純電驅動感)',
            '熱血派：Hyundai Kona Hybrid (DCT 雙離合器)',
            '戶外派：Suzuki S-Cross (AllGrip 四驅)',
          ],
          color: Colors.indigo.shade50,
          borderColor: Colors.indigo,
        ),
        const SizedBox(height: 16),
        _buildStrategyCard(
          title: '軸向 B：穩定務實與都會通勤',
          targetAudience: '重視經濟效益、家庭乘坐舒適度、長期持有成本與品牌信賴感。',
          recommendations: [
            '首選：Toyota Corolla Cross Hybrid (國民神車)',
            '升級選：Lexus LBX (豪華質感)',
            '經濟選：Kia Stonic 1.0T (高CP值)',
            '入門選：Toyota Yaris Cross (預算先決)',
          ],
          color: Colors.amber.shade50,
          borderColor: Colors.amber,
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('結論'),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '消費者應根據自身生活型態選擇。若追求駕駛樂趣與靈活空間，Honda 與 Nissan 是首選；若重視長期持有成本、保值性與舒適度，Toyota 與 Lexus 則是無可撼動的王者。',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        )
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

Widget _buildStrategyCard({
  required String title,
  required String targetAudience,
  required List<String> recommendations,
  required Color color,
  required Color borderColor,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor.withOpacity(0.5), width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: borderColor)),
        const SizedBox(height: 8),
        Text('適合對象：$targetAudience', style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
        const Divider(height: 24),
        ...recommendations.map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.arrow_right, color: borderColor),
                  Expanded(child: Text(rec, style: const TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
            )),
      ],
    ),
  );
}