import 'package:flutter/material.dart';
import 'package:fooderlich/components/grocery_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class GroceryItemScreen extends StatefulWidget {
  final Function(GroceryItem) onCreate;
  final Function(GroceryItem) onUpdate;

  final GroceryItem originalItem;

  final bool isUpdating;

  const GroceryItemScreen(
      {Key key, this.onCreate, this.onUpdate, this.originalItem})
      : isUpdating = (originalItem != null),
        super(key: key);

  @override
  _GroceryItemScreenState createState() => _GroceryItemScreenState();
}

class _GroceryItemScreenState extends State<GroceryItemScreen> {
  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  @override
  void initState() {
    if (widget.originalItem != null) {
      _nameController.text = widget.originalItem.name;
      _name = widget.originalItem.name;
      _currentSliderValue = widget.originalItem.quantity;
      _importance = widget.originalItem.importance;
      _currentColor = widget.originalItem.color;
      final date = widget.originalItem.date;
      _timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
      _dueDate = date;
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  final groceryItem = GroceryItem(
                      id: widget.originalItem?.id ?? const Uuid().v1(),
                      name: _nameController.text,
                      importance: _importance,
                      color: _currentColor,
                      quantity: _currentSliderValue,
                      date: DateTime(_dueDate.year, _dueDate.month,
                          _dueDate.day, _timeOfDay.minute));

                  if (widget.isUpdating)
                    widget.onUpdate(groceryItem);
                  else {
                    widget.onCreate(groceryItem);
                  }
                })
          ],
          elevation: 0,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'Grocery Item',
              style: GoogleFonts.lato(fontWeight: FontWeight.w600),
            ),
          )),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              buildNameField(),
              const SizedBox(
                height: 15,
              ),
              buildImportanceFiled(),
              const SizedBox(
                height: 15,
              ),
              buildDateField(context),
              const SizedBox(
                height: 15,
              ),
              buildTimeField(context),
              const SizedBox(
                height: 15,
              ),
              buildColorPicker(),
              const SizedBox(
                height: 15,
              ),
              buildQuantityField(),
              const SizedBox(
                height: 16,
              ),
              GroceryTile(
                  item: GroceryItem(
                      name: _name,
                      importance: _importance,
                      color: _currentColor,
                      isComplete: false,
                      quantity: _currentSliderValue,
                      date: DateTime(_dueDate.year, _dueDate.month,
                          _dueDate.day, _timeOfDay.hour, _timeOfDay.minute)))
            ],
          )),
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Item Name', style: GoogleFonts.lato(fontSize: 28)),
        const SizedBox(
          height: 8,
        ),
        TextField(
          controller: _nameController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
              hintText: 'E.g Apples, Banana, 1 Bag of salt',
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _currentColor),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: _currentColor),
              )),
        )
      ],
    );
  }

  Widget buildImportanceFiled() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Importance', style: GoogleFonts.lato(fontSize: 28)),
        Wrap(spacing: 10, children: [
          ChoiceChip(
            selectedColor: Colors.green[700],
            selected: _importance == Importance.low,
            label: const Text(
              'low',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onSelected: (selected) => _importance = Importance.low,
          ),
          ChoiceChip(
            selectedColor: Colors.green[700],
            selected: _importance == Importance.medium,
            label: const Text(
              'Medium',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onSelected: (selected) => _importance = Importance.medium,
          ),
          ChoiceChip(
            selectedColor: Colors.green[700],
            selected: _importance == Importance.high,
            label: const Text(
              'High',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onSelected: (selected) => _importance = Importance.high,
          )
        ])
      ],
    );
  }

  Widget buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Date', style: GoogleFonts.lato(fontSize: 28)),
          TextButton(
            child: const Text('Select'),
            onPressed: () async {
              final currentDate = DateTime.now();

              final selectedDate = await showDatePicker(
                context: context,
                initialDate: currentDate,
                firstDate: currentDate,
                lastDate: DateTime(currentDate.year + 5),
              );

              setState(() {
                if (selectedDate != null) {
                  _dueDate = selectedDate;
                }
              });
            },
          )
        ]),
        if (_dueDate != null)
          Text('${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
      ],
    );
  }

  Widget buildTimeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Time of Day', style: GoogleFonts.lato(fontSize: 28)),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                final timeOfDay = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                setState(() {
                  if (timeOfDay != null) {
                    _timeOfDay = timeOfDay;
                  }
                });
              },
            )
          ],
        ),
        if (_timeOfDay != null) Text('${_timeOfDay.format(context)}'),
      ],
    );
  }

  Widget buildColorPicker() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Container(height: 50, width: 10, color: _currentColor),
          const SizedBox(
            width: 8,
          ),
          Text('Color', style: GoogleFonts.lato(fontSize: 28)),
          TextButton(
            child: const Text('Select'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: BlockPicker(
                        pickerColor: Colors.white,
                        onColorChanged: (color) {
                          setState(() => _currentColor = color);
                        },
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Save'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
          )
        ],
      )
    ]);
  }

  Widget buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Quantity',
              style: GoogleFonts.lato(fontSize: 28),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(_currentSliderValue.toInt().toString(),
                style: GoogleFonts.lato(fontSize: 18))
          ],
        ),
        Slider(
          inactiveColor: _currentColor.withOpacity(0.5),
          activeColor: _currentColor,
          value: _currentSliderValue.toDouble(),
          min: 0.0,
          max: 100.0,
          divisions: 100,
          label: _currentSliderValue.toInt().toString(),
          onChanged: (double val) {
            setState(() {
              _currentSliderValue = val.toInt();
            });
          },
        )
      ],
    );
  }
}
