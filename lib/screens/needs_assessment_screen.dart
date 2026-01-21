import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/needs_model.dart';
import '../providers/evaluation_provider.dart';

class NeedsAssessmentScreen extends StatelessWidget {
  const NeedsAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EvaluationProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, '1. 車輛用途評估'),
          const SizedBox(height: 8),
          ...UsageType.values.map((type) => RadioListTile<UsageType>(
            title: Text(provider.needs.getUsageLabel(type)),
            value: type,
            groupValue: provider.needs.selectedUsage,
            onChanged: (val) => provider.setUsage(val!),
          )),
          
          const Divider(height: 32),
          
          _buildSectionTitle(context, '2. 偏好動力類型'),
          const SizedBox(height: 8),
          ...PowertrainType.values.map((type) => RadioListTile<PowertrainType>(
            title: Text(provider.needs.getPowertrainLabel(type)),
            subtitle: provider.needs.recommendedPowertrains.contains(type) 
                ? const Text('⭐ 根據您的用途推薦', style: TextStyle(color: Colors.green, fontSize: 12))
                : null,
            value: type,
            groupValue: provider.needs.preferredPowertrain,
            onChanged: (val) => provider.setPreferredPowertrain(val!),
          )),
          
          if (provider.needs.selectedUsage != null && provider.needs.preferredPowertrain != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.tips_and_updates, color: Colors.blue),
                      const SizedBox(height: 8),
                      Text(
                        '分析建議：針對您的${provider.needs.getUsageLabel(provider.needs.selectedUsage!)}需求，選擇${provider.needs.getPowertrainLabel(provider.needs.preferredPowertrain!)}是個不錯的選擇！接下來請至「預算規劃」進行試算。',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
