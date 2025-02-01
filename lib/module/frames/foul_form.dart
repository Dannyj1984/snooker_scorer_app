import 'package:flutter/material.dart';

class FoulForm extends StatefulWidget {
  const FoulForm({super.key, required this.handleFoul});
  final Function(int foulAmount, int redsPotted) handleFoul;
  @override
  State<FoulForm> createState() => _FoulFormState();
}

class _FoulFormState extends State<FoulForm> {
  final _foulAmountController = TextEditingController();
  int foulAmount = 0;
  bool _showRedsPotted = false;
  int redsPotted = 0;

  @override
  void dispose() {
    _foulAmountController.dispose();
    super.dispose();
  }

  void _submitFoulData() {
    if (foulAmount == 0) {
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
      foulAmount,
      redsPotted,
    );
    Navigator.of(context).pop(foulAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            const Row(
              children: [
                Text('Foul',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            _colourButtons(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        foulAmount.toString(),
                        style: const TextStyle(
                            fontSize: 64, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _showRedsPotted,
                  onChanged: (value) {
                    setState(() {
                      _showRedsPotted = value!;
                    });
                  },
                ),
                const Text('Reds potted?')
              ],
            ),
            const SizedBox(height: 20),
            if (_showRedsPotted) _redsPotted(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      _submitFoulData();
                    },
                    child: const Text('Save')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (redsPotted == 0) return;
                        redsPotted -= 1;
                      });
                    },
                    child: const Text('Undo'))
              ],
            )
          ],
        ));
  }

  Widget _redsPotted() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  redsPotted += 1;
                });
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero, // Remove extra padding
              ),
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    redsPotted.toString(),
                    style: const TextStyle(
                        fontSize: 64, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _colourButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              foulAmount = 4;
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero, // Remove extra padding
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              foulAmount = 4;
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero, // Remove extra padding
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.yellow,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              foulAmount = 4;
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero, // Remove extra padding
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              foulAmount = 4;
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero, // Remove extra padding
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.brown,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              foulAmount = 5;
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero, // Remove extra padding
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              foulAmount = 6;
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero, // Remove extra padding
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.pink,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              foulAmount = 7;
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero, // Remove extra padding
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
