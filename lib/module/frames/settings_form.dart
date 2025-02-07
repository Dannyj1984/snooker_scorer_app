// This should be a now component. It should allow a user to update the frame details. The fields should allow the user to enter reds remaining as a number, player 1 score, player 2 score. When submited it should send this data back to the new_frame component

import 'package:flutter/material.dart';

class SettingsForm extends StatefulWidget {
  final Function(int, int, int, bool) updateSettings;
  final int p1Score;
  final int p2Score;
  final int redsRemaining;
  final bool endFrame;

  const SettingsForm({
    super.key,
    required this.updateSettings,
    required this.p1Score,
    required this.p2Score,
    required this.redsRemaining,
    required this.endFrame,
  });
  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final player1ScoreController = TextEditingController();
  final player2ScoreController = TextEditingController();
  final redsRemainingController = TextEditingController();
  var endFrame = false;
  @override
  initState() {
    super.initState();
    player1ScoreController.text = widget.p1Score.toString();
    player2ScoreController.text = widget.p2Score.toString();
    redsRemainingController.text = widget.redsRemaining.toString();
  }

  @override
  void dispose() {
    player1ScoreController.dispose();
    player2ScoreController.dispose();
    redsRemainingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Player 1 Score',
              ),
              controller: player1ScoreController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Player 2 Score',
              ),
              controller: player2ScoreController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Reds Remaining',
              ),
              controller: redsRemainingController,
            ),
            CheckboxListTile(
              title: const Text('End Frame'),
              value: endFrame,
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    endFrame = true;
                  } else {
                    endFrame = false;
                  }
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.updateSettings(
                      int.parse(player1ScoreController.text),
                      int.parse(player2ScoreController.text),
                      int.parse(redsRemainingController.text),
                      endFrame);
                  Navigator.of(context).pop();
                },
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
