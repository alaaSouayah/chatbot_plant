import 'package:flutter/material.dart';
import 'package:chaatbot_detection/utils/constants.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.eco,
                    size: 60,
                    color: Constants.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome to PlantApp',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Introduction text
            Text(
              'By using PlantApp, you agree to the following terms:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            // Terms list
            _buildTermItem(
              context,
              number: '1',
              title: 'Plant Care Guidelines',
              description:
                  'Respect and follow proper plant care guidelines provided in the app.',
            ),
            _buildTermItem(
              context,
              number: '2',
              title: 'Accurate Information',
              description:
                  'Avoid sharing false or misleading plant care information.',
            ),
            _buildTermItem(
              context,
              number: '3',
              title: 'Community Respect',
              description:
                  'Be kind and respectful to other plant enthusiasts in the community.',
            ),
            _buildTermItem(
              context,
              number: '4',
              title: 'Responsible Use',
              description:
                  'Use the app responsibly and for its intended purposes only.',
            ),

            const SizedBox(height: 24),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Thank you for growing with us!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Constants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.psychology_alt_outlined,
                    size: 40,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number circle
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
