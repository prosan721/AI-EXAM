import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/network/app_cubit.dart';
import '../../core/theme/app_theme.dart';

class UploadOrganizeScreen extends StatelessWidget {
  const UploadOrganizeScreen({super.key});

  @override
  Widget build(BuildContext buildContext) {
    final primaryColor = Theme.of(buildContext).primaryColor;
    
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final filename = '${state.selectedSubExam}_${state.selectedYear}_Paper_01.pdf';

        return Scaffold(
          appBar: AppBar(
            title: Text('${state.selectedSubExam} Scanner'),
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () => context.read<AppCubit>().goBack(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Steps tracker
                _buildStepsIndicator(state),
                const SizedBox(height: 32),

                if (state.activeScreen == 'UPLOAD_ORGANIZE' && !state.isScanning && state.scanProgress == 0)
                  _buildUploadView(context, filename, primaryColor)
                else if (state.isScanning)
                  _buildScanningView(context, state, primaryColor)
                else if (state.activeScreen == 'UPLOAD_SUMMARY')
                  _buildSummaryView(context, primaryColor)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepsIndicator(AppState state) {
    int activeStep = 1;
    if (state.isScanning) activeStep = 2;
    if (state.scanProgress == 100) activeStep = 3;
    if (state.activeScreen == 'UPLOAD_SUMMARY') activeStep = 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepNode(1, 'Upload', activeStep >= 1, activeStep > 1),
        _buildStepConnector(activeStep > 1),
        _buildStepNode(2, 'Scan', activeStep >= 2, activeStep > 2),
        _buildStepConnector(activeStep > 2),
        _buildStepNode(3, 'Organize', activeStep >= 3, activeStep > 3),
        _buildStepConnector(activeStep > 3),
        _buildStepNode(4, 'Ready', activeStep >= 4, false),
      ],
    );
  }

  Widget _buildStepNode(int index, String label, bool isActive, bool isComplete) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isComplete 
              ? const Color(0xFF10B981) 
              : (isActive ? AppTheme.primary : Colors.grey.withOpacity(0.2)),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isComplete 
              ? const Icon(LucideIcons.check, color: Colors.white, size: 14)
              : Text(
                  index.toString(),
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppTheme.primary : Colors.grey,
          ),
        )
      ],
    );
  }

  Widget _buildStepConnector(bool isComplete) {
    return Expanded(
      child: Container(
        height: 2,
        color: isComplete ? const Color(0xFF10B981) : Colors.grey.withOpacity(0.2),
        margin: const EdgeInsets.only(bottom: 14),
      ),
    );
  }

  Widget _buildUploadView(BuildContext context, String filename, Color primaryColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '1. Add Previous Year Paper',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Upload PDF files of raw competitive exam question papers.',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 24),

            // Dropzone card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.03),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primaryColor.withOpacity(0.15),
                  width: 2,
                  style: BorderStyle.solid, // note: Flutter custom dashes require package
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.fileText, color: primaryColor, size: 36),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Drag & Drop or Choose File',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'PDF file format supported',
                    style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Selected File Display Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.15)),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.fileText, color: primaryColor, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filename,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                '2.45 MB',
                                style: TextStyle(color: Colors.grey, fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Change', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                context.read<AppCubit>().startPdfScanning(filename);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Upload & Scan', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(LucideIcons.arrowRight, size: 16),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScanningView(BuildContext context, AppState state, Color primaryColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              '2. AI Scanning Process',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'AI reads, OCRs, and parses questions, options, and topics in the background.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 40),

            // Scanning Radar Animation
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: state.scanProgress / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                  Icon(LucideIcons.cpu, color: primaryColor, size: 36),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Extracting questions...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text('${state.scanProgress}%', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () {
                context.read<AppCubit>().showScreen('YEAR_SELECT');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.grey[700],
                elevation: 0,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Cancel Scan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryView(BuildContext context, Color primaryColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Green success tick
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.check, color: Color(0xFF10B981), size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'AI Organization Completed!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your uploaded papers have been scanned and organized subject-wise.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 24),

            // Stats breakdown
            _buildSummaryStatRow(LucideIcons.fileText, 'Total Papers', '4'),
            const Divider(),
            _buildSummaryStatRow(LucideIcons.circleHelp, 'Total Questions', '480'),
            const Divider(),
            _buildSummaryStatRow(LucideIcons.layers, 'Detected Subjects', '6'),
            const Divider(),
            _buildSummaryStatRow(LucideIcons.squareCheck, 'Organization Accuracy', '98%'),
            
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                context.read<AppCubit>().saveScannedPaper();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('View Mock Test', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey, size: 16),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
