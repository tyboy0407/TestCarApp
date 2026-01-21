import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vehicle_model.dart';
import '../providers/vehicle_provider.dart';

class AddCustomVehicleScreen extends StatefulWidget {
  final Vehicle? vehicleToEdit;

  const AddCustomVehicleScreen({super.key, this.vehicleToEdit});

  @override
  State<AddCustomVehicleScreen> createState() => _AddCustomVehicleScreenState();
}

class _AddCustomVehicleScreenState extends State<AddCustomVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String _brand = '';
  String _model = '';
  int _price = 0;
  int _displacement = 0;
  double _horsepower = 0;
  double _torque = 0;
  double _avgFuelConsumption = 0;
  String _transmission = '';
  String _frontSuspension = '';
  String _rearSuspension = '';
  String _engineType = '';
  
  // Cost Analysis Fields
  int _maintenanceCost60k = 0;
  int _bumperPrice = 0;
  int _headlightPrice = 0;
  int _mirrorPrice = 0;
  int _reliabilityScore = 0;

  @override
  void initState() {
    super.initState();
    if (widget.vehicleToEdit != null) {
      final v = widget.vehicleToEdit!;
      _brand = v.brand;
      _model = v.model;
      _price = v.price;
      _displacement = v.displacement;
      _horsepower = v.horsepower;
      _torque = v.torque;
      _avgFuelConsumption = v.avgFuelConsumption;
      _transmission = v.transmission;
      _frontSuspension = v.frontSuspension;
      _rearSuspension = v.rearSuspension;
      _engineType = v.engineType;
      _maintenanceCost60k = v.maintenanceCost60k;
      _bumperPrice = v.partsPrices['前保桿'] ?? 0;
      _headlightPrice = v.partsPrices['頭燈總成'] ?? 0;
      _mirrorPrice = v.partsPrices['照後鏡'] ?? 0;
      _reliabilityScore = v.reliabilityScore;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // If editing, use existing ID, otherwise generate new one
      final id = widget.vehicleToEdit?.id ?? DateTime.now().toString();

      final newVehicle = Vehicle(
        id: id,
        brand: _brand,
        model: _model,
        price: _price,
        displacement: _displacement,
        horsepower: _horsepower,
        torque: _torque,
        avgFuelConsumption: _avgFuelConsumption,
        transmission: _transmission,
        frontSuspension: _frontSuspension,
        rearSuspension: _rearSuspension,
        engineType: _engineType,
        maintenanceCost60k: _maintenanceCost60k,
        partsPrices: {
          '前保桿': _bumperPrice,
          '頭燈總成': _headlightPrice,
          '照後鏡': _mirrorPrice,
        },
        reliabilityScore: _reliabilityScore,
      );

      final provider = Provider.of<VehicleProvider>(context, listen: false);
      if (widget.vehicleToEdit != null) {
        provider.updateVehicle(newVehicle);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('車輛資訊已更新！')),
        );
      } else {
        provider.addVehicle(newVehicle);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已新增自訂車輛！')),
        );
      }

      Navigator.of(context).pop(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vehicleToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '編輯車輛資訊' : '新增自訂車輛'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('基本資訊'),
              Row(
                children: [
                  Expanded(child: _buildTextField('廠牌', _brand, (val) => _brand = val)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField('車型', _model, (val) => _model = val)),
                ],
              ),
              _buildNumberField('建議售價 (NTD)', _price, (val) => _price = int.parse(val)),

              const SizedBox(height: 20),
              _buildSectionTitle('動力與規格'),
              Row(
                children: [
                  Expanded(child: _buildNumberField('排氣量 (cc)', _displacement, (val) => _displacement = int.parse(val))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField('引擎型式 (如: 渦輪)', _engineType, (val) => _engineType = val)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildNumberField('馬力 (hp)', _horsepower, (val) => _horsepower = double.parse(val))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildNumberField('扭力 (kgm)', _torque, (val) => _torque = double.parse(val))),
                ],
              ),
              _buildNumberField('平均油耗 (km/L)', _avgFuelConsumption, (val) => _avgFuelConsumption = double.parse(val)),
              _buildTextField('變速箱', _transmission, (val) => _transmission = val),
              Row(
                children: [
                  Expanded(child: _buildTextField('前懸吊', _frontSuspension, (val) => _frontSuspension = val)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField('後懸吊', _rearSuspension, (val) => _rearSuspension = val)),
                ],
              ),

              const SizedBox(height: 20),
              _buildSectionTitle('持有成本 (選填)'),
              _buildNumberField('6萬公里保養費 (NTD)', _maintenanceCost60k, (val) => _maintenanceCost60k = int.tryParse(val) ?? 0, required: false),
              Row(
                children: [
                  Expanded(child: _buildNumberField('前保桿價格', _bumperPrice, (val) => _bumperPrice = int.tryParse(val) ?? 0, required: false)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildNumberField('頭燈價格', _headlightPrice, (val) => _headlightPrice = int.tryParse(val) ?? 0, required: false)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildNumberField('照後鏡價格', _mirrorPrice, (val) => _mirrorPrice = int.tryParse(val) ?? 0, required: false)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildNumberField('妥善率 (0-100)', _reliabilityScore, (val) => _reliabilityScore = int.tryParse(val) ?? 0, required: false)),
                ],
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _submitForm,
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(isEditing ? '儲存變更' : '加入比較清單'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onSaved, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        validator: required ? (value) {
          if (value == null || value.isEmpty) {
            return '請輸入$label';
          }
          return null;
        } : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildNumberField(String label, num initialValue, Function(String) onSaved, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: initialValue == 0 && !required ? '' : initialValue.toString(), // Don't show 0 for optional fields if not set
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        keyboardType: TextInputType.number,
        validator: required ? (value) {
          if (value == null || value.isEmpty) {
            return '請輸入$label';
          }
          if (double.tryParse(value) == null) {
            return '請輸入有效數字';
          }
          return null;
        } : null,
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            onSaved(value);
          } else if (!required) {
             // Handle empty optional field save if needed, though int.tryParse handles it in parent
          }
        },
      ),
    );
  }
}