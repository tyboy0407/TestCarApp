import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../models/vehicle_model.dart';
import 'package:intl/intl.dart';
import 'add_custom_vehicle_screen.dart';

class CarComparisonScreen extends StatefulWidget {
  const CarComparisonScreen({super.key});

  @override
  State<CarComparisonScreen> createState() => _CarComparisonScreenState();
}

class _CarComparisonScreenState extends State<CarComparisonScreen> {
  String? _selectedBrand1;
  Vehicle? _selectedVehicle1;
  
  String? _selectedBrand2;
  Vehicle? _selectedVehicle2;

  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'zh_TW', symbol: '\$', decimalDigits: 0);

  List<String> _getUniqueBrands(List<Vehicle> vehicles) {
    return vehicles.map((v) => v.brand).toSet().toList()..sort();
  }

  List<Vehicle> _getVehiclesByBrand(List<Vehicle> vehicles, String? brand) {
    if (brand == null) return [];
    return vehicles.where((v) => v.brand == brand).toList();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final vehicles = vehicleProvider.vehicles;
    final brands = _getUniqueBrands(vehicles);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomVehicleScreen()),
          );
        },
        label: const Text('自訂'),
        icon: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '車輛規格與成本比較',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Selection Area
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildVehicleSelectorGroup(
                    label: '車輛 A',
                    allVehicles: vehicles,
                    brands: brands,
                    selectedBrand: _selectedBrand1,
                    selectedVehicle: _selectedVehicle1,
                    onBrandChanged: (val) {
                      setState(() {
                        _selectedBrand1 = val;
                        _selectedVehicle1 = null;
                      });
                    },
                    onVehicleChanged: (val) {
                      setState(() {
                        _selectedVehicle1 = val;
                      });
                    },
                  ),
                ),
                
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: const Icon(Icons.compare_arrows, color: Colors.grey),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: _buildVehicleSelectorGroup(
                    label: '車輛 B',
                    allVehicles: vehicles,
                    brands: brands,
                    selectedBrand: _selectedBrand2,
                    selectedVehicle: _selectedVehicle2,
                    onBrandChanged: (val) {
                      setState(() {
                        _selectedBrand2 = val;
                        _selectedVehicle2 = null;
                      });
                    },
                    onVehicleChanged: (val) {
                      setState(() {
                        _selectedVehicle2 = val;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Comparison Table
            if (_selectedVehicle1 != null && _selectedVehicle2 != null)
              _buildComparisonTable(_selectedVehicle1!, _selectedVehicle2!)
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    '請完整選擇兩台車輛以進行比較',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelectorGroup({
    required String label,
    required List<Vehicle> allVehicles,
    required List<String> brands,
    required String? selectedBrand,
    required Vehicle? selectedVehicle,
    required ValueChanged<String?> onBrandChanged,
    required ValueChanged<Vehicle?> onVehicleChanged,
  }) {
    final availableModels = _getVehiclesByBrand(allVehicles, selectedBrand);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: selectedBrand,
          decoration: const InputDecoration(
            labelText: '選擇廠牌',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          items: brands.map((b) {
            return DropdownMenuItem(value: b, child: Text(b));
          }).toList(),
          onChanged: onBrandChanged,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Vehicle>(
          isExpanded: true,
          value: selectedVehicle,
          decoration: const InputDecoration(
            labelText: '選擇車型',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          items: availableModels.isEmpty 
              ? [] 
              : availableModels.map((v) {
                  return DropdownMenuItem(
                    value: v,
                    child: Text(
                      v.model, 
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
          onChanged: selectedBrand == null ? null : onVehicleChanged,
          disabledHint: const Text('請先選廠牌'),
        ),
        if (selectedVehicle != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context, // Use local context
                  MaterialPageRoute(
                    builder: (ctx) => AddCustomVehicleScreen(vehicleToEdit: selectedVehicle),
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('編輯此車輛'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildComparisonTable(Vehicle v1, Vehicle v2) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildRow('車型', v1.model, v2.model, isHeader: true),
            const Divider(),
            
            _buildSectionHeader('a. 引擎與稅金'),
            _buildRow('排氣量', '${v1.displacement} cc', '${v2.displacement} cc'),
            _buildRow('年度稅金', 
              _currencyFormat.format(v1.totalTax), 
              _currencyFormat.format(v2.totalTax),
              highlightWinner: true, 
              winnerLow: true,
              v1Val: v1.totalTax.toDouble(),
              v2Val: v2.totalTax.toDouble()
            ),

            _buildSectionHeader('b. 動力與油耗'),
            _buildRow('最大馬力', '${v1.horsepower} hp', '${v2.horsepower} hp', 
              highlightWinner: true, v1Val: v1.horsepower, v2Val: v2.horsepower),
            _buildRow('平均油耗', '${v1.avgFuelConsumption} km/L', '${v2.avgFuelConsumption} km/L',
              highlightWinner: true, v1Val: v1.avgFuelConsumption, v2Val: v2.avgFuelConsumption),

            _buildSectionHeader('c. 持有成本分析 (新功能)'),
            _buildRow('定期保養(6萬km)', 
              _currencyFormat.format(v1.maintenanceCost60k), 
              _currencyFormat.format(v2.maintenanceCost60k),
              highlightWinner: true, winnerLow: true,
              v1Val: v1.maintenanceCost60k.toDouble(),
              v2Val: v2.maintenanceCost60k.toDouble()
            ),
             _buildRow('前保桿(副/原)', 
              _currencyFormat.format(v1.partsPrices['前保桿'] ?? 0), 
              _currencyFormat.format(v2.partsPrices['前保桿'] ?? 0),
              highlightWinner: true, winnerLow: true,
              v1Val: (v1.partsPrices['前保桿'] ?? 0).toDouble(),
              v2Val: (v2.partsPrices['前保桿'] ?? 0).toDouble()
            ),
             _buildRow('頭燈總成(單邊)', 
              _currencyFormat.format(v1.partsPrices['頭燈總成'] ?? 0), 
              _currencyFormat.format(v2.partsPrices['頭燈總成'] ?? 0),
              highlightWinner: true, winnerLow: true,
              v1Val: (v1.partsPrices['頭燈總成'] ?? 0).toDouble(),
              v2Val: (v2.partsPrices['頭燈總成'] ?? 0).toDouble()
            ),
             _buildRow('妥善率口碑指數', 
              '${v1.reliabilityScore} 分', 
              '${v2.reliabilityScore} 分',
              highlightWinner: true, winnerLow: false,
              v1Val: v1.reliabilityScore.toDouble(),
              v2Val: v2.reliabilityScore.toDouble()
            ),

            const Divider(),
            _buildSectionHeader('建議售價'),
            _buildRow('價格', _currencyFormat.format(v1.price), _currencyFormat.format(v2.price),
             highlightWinner: true, winnerLow: true, v1Val: v1.price.toDouble(), v2Val: v2.price.toDouble()),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildRow(
    String label, 
    String val1, 
    String val2, 
    {
      bool isHeader = false, 
      bool highlightWinner = false,
      bool winnerLow = false,
      double? v1Val,
      double? v2Val
    }
  ) {
    TextStyle style = isHeader 
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16) 
        : const TextStyle(fontSize: 14);

    Color? color1;
    Color? color2;

    if (highlightWinner && v1Val != null && v2Val != null && v1Val != v2Val) {
      bool v1Better = winnerLow ? v1Val < v2Val : v1Val > v2Val;
      if (v1Better) {
        color1 = Colors.green.shade700;
        color2 = Colors.black87; 
      } else {
        color2 = Colors.green.shade700;
        color1 = Colors.black87;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13))),
          Expanded(
            flex: 3, 
            child: Text(
              val1, 
              style: style.copyWith(color: color1 ?? (isHeader ? Colors.black : Colors.black87)), 
              textAlign: TextAlign.center
            )
          ),
          Expanded(
            flex: 3, 
            child: Text(
              val2, 
              style: style.copyWith(color: color2 ?? (isHeader ? Colors.black : Colors.black87)), 
              textAlign: TextAlign.center
            )
          ),
        ],
      ),
    );
  }
}
