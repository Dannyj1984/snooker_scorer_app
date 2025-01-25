import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snooker_scorer/helpers/text_formatter.dart';

class FoulForm extends StatefulWidget {
  const FoulForm({super.key, required this.handleFoul});
  final Function(int foulAmount) handleFoul;
  @override
  State<FoulForm> createState() => _FoulFormState();
}

class _FoulFormState extends State<FoulForm> {
  final _foulAmountController = TextEditingController();

  @override
  void dispose() {
    _foulAmountController.dispose();
    super.dispose();
  }

  void _submitFrameData() {
    if (_foulAmountController.text.trim().isEmpty) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: const Text('Missing values'),
                  content: const Text(
                      'Please make sure a valid foul amount is entered'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('OK'))
                  ]));
      return;
    }

    widget.handleFoul(
      int.parse(_foulAmountController.text),
    );
    Navigator.of(context).pop(int.parse(_foulAmountController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            const Row(
              children: [
                Text('Fouls',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(children: [
              Expanded(
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    RangeTextInputFormatter(min: 4, max: 7),
                  ],
                  decoration: const InputDecoration(label: Text('Points')),
                  controller: _foulAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  autocorrect: false,
                  enableSuggestions: false,
                ),
              ),
            ]),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      _submitFrameData();
                    },
                    child: const Text('Save'))
              ],
            )
          ],
        ));
  }
}
