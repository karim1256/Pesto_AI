import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';

// Add these helper functions at the top of your file

void showPredictionDialog(
  BuildContext context,
  Map<String, dynamic> predictionData,
) {
  // Safely extract data with null checks
  final allProbs =
      predictionData["all_probabilities"] as Map<String, dynamic>? ?? {};
  final highestClass = predictionData['class']?.toString() ?? 'Unknown';
  final highestConfidence =
      double.tryParse(predictionData['confidence']?.toString() ?? '0') ?? 0;

  // Sort probabilities from highest to lowest
  final sortedProbs =
      allProbs.entries.toList()
        ..sort((a, b) => (b.value as num).compareTo(a.value as num));

  showDialog(
    context: context,
    builder:
        (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth(context) * 0.04),
          ),
          elevation: 4,
          child: Container(
            width: screenWidth(context) * 0.9,
            constraints: BoxConstraints(maxHeight: screenHeight(context) * 0.8),
            padding: EdgeInsets.all(screenWidth(context) * 0.05),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Diagnosis Results',
                    style: TextStyle(
                      fontSize: screenWidth(context) * 0.055,
                      fontWeight: FontWeight.bold,
                      color: MainColor,
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.close, color: Colors.grey),
                  //   iconSize: screenWidth(context) * 0.06,
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  SizedBox(height: screenHeight(context) * 0.02),

                  // Top prediction card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth(context) * 0.04),
                    decoration: BoxDecoration(
                      color: MainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        screenWidth(context) * 0.03,
                      ),
                      border: Border.all(color: MainColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              color: MainColor,
                              size: screenWidth(context) * 0.06,
                            ),
                            SizedBox(width: screenWidth(context) * 0.02),
                            Text(
                              'PRIMARY DIAGNOSIS',
                              style: TextStyle(
                                fontSize: screenWidth(context) * 0.035,
                                fontWeight: FontWeight.bold,
                                color: MainColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight(context) * 0.015),
                        Text(
                          highestClass.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            fontSize: screenWidth(context) * 0.05,
                            fontWeight: FontWeight.bold,
                            color: MainColor,
                          ),
                        ),
                        SizedBox(height: screenHeight(context) * 0.01),
                        LinearProgressIndicator(
                          value: highestConfidence / 100,
                          backgroundColor: Colors.grey[200],
                          color: MainColor,
                          minHeight: screenHeight(context) * 0.01,
                          borderRadius: BorderRadius.circular(
                            screenWidth(context) * 0.01,
                          ),
                        ),
                        SizedBox(height: screenHeight(context) * 0.01),
                        Text(
                          '${highestConfidence.toStringAsFixed(1)}% confidence',
                          style: TextStyle(
                            fontSize: screenWidth(context) * 0.035,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight(context) * 0.03),

                  // All probabilities section
                  Text(
                    'OTHER POSSIBILITIES',
                    style: TextStyle(
                      fontSize: screenWidth(context) * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: screenHeight(context) * 0.015),

                  ...sortedProbs.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: screenHeight(context) * 0.015,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  entry.key.replaceAll('_', ' '),
                                  style: TextStyle(
                                    fontSize: screenWidth(context) * 0.038,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '${(entry.value as num).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: screenWidth(context) * 0.038,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight(context) * 0.007),
                          LinearProgressIndicator(
                            value: (entry.value as num) / 100,
                            backgroundColor: Colors.grey[200],
                            color:
                                entry.key == highestClass
                                    ? MainColor
                                    : Colors.blue[300],
                            minHeight: screenHeight(context) * 0.007,
                            borderRadius: BorderRadius.circular(
                              screenWidth(context) * 0.007,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: screenHeight(context) * 0.02),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth(context) * 0.02,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight(context) * 0.015,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'UNDERSTOOD',
                        style: TextStyle(
                          fontSize: screenWidth(context) * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
