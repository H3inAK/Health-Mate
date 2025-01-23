import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MindfulnessStep {
  final String title;
  final String description;

  MindfulnessStep({required this.title, required this.description});
}

class MindfulnessStepsWidget extends StatelessWidget {
  final List<MindfulnessStep> steps = [
    MindfulnessStep(
      title: 'Meditation',
      description: 'Spend 10 minutes meditating to clear your mind.',
    ),
    MindfulnessStep(
      title: 'Deep Breathing',
      description: 'Practice deep breathing exercises for relaxation.',
    ),
    MindfulnessStep(
      title: 'Journaling',
      description: 'Write down your thoughts and feelings.',
    ),
    // Add more steps as needed
  ];

  MindfulnessStepsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mindfulness Activities',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Stepper(
            currentStep: 0,
            onStepTapped: (index) {},
            onStepContinue: () {},
            onStepCancel: () {},
            steps: steps
                .map((step) => Step(
                      title: Text(
                        step.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: Text(
                        step.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      isActive: true,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
