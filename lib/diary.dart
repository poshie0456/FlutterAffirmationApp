import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryEntry {
  String text;
  DateTime date;
  String mood;

  DiaryEntry({required this.text, required this.date, required this.mood});
}

class DiaryApp extends StatefulWidget {
  const DiaryApp({Key? key}) : super(key: key);

  @override
  _DiaryAppState createState() => _DiaryAppState();
}

class _DiaryAppState extends State<DiaryApp> {
  List<DiaryEntry> entries = [];
  final TextEditingController _textController = TextEditingController();
  String? selectedMood;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? entryStrings = prefs.getStringList('entries');
    if (entryStrings != null) {
      setState(() {
        entries = entryStrings.map((entryString) {
          List<String> parts = entryString.split('|');
          return DiaryEntry(
            text: parts[0],
            date: DateTime.parse(parts[1]),
            mood: parts[2],
          );
        }).toList();
      });
    }
  }

  Future<void> _saveEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> entryStrings = entries
        .map((entry) => '${entry.text}|${entry.date.toIso8601String()}|${entry.mood}')
        .toList();
    await prefs.setStringList('entries', entryStrings);
  }

  void _addEntry(String text, String mood) {
    setState(() {
      entries.add(DiaryEntry(text: text, date: DateTime.now(), mood: mood));
    });
    _saveEntries();
  }

  Future<void> _deleteEntry(int index) async{
    setState(() {
      entries.removeAt(index);
    });
    await _saveEntries();
  }

  void _openBottomSheet({int? editIndex}) {
    final bool isEditing = editIndex != null;
    if (isEditing) {
      _textController.text = entries[editIndex].text;
      selectedMood = entries[editIndex].mood;
    } else {
      _textController.clear();
      selectedMood = null;
    }

   showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => StatefulBuilder(
    builder: (context, setState) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      return Container(constraints: BoxConstraints(maxHeight: screenHeight*0.8),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: screenHeight * 0.02,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF121212), // Darker background
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    isEditing ? 'Edit Entry' : 'New Entry',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  controller: _textController,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your diary entry...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E), // Slightly lighter dark
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Mood',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Wrap(
                  spacing: 8,
                  children: ['Happy', 'Sad', 'Excited', 'Angry', 'Relaxed'].map((mood) {
                    return ChoiceChip(
                      label: Text(
                        mood,
                        style: TextStyle(
                          color: selectedMood == mood ? Colors.black : Colors.white,
                        ),
                      ),
                      selected: selectedMood == mood,
                      selectedColor: Colors.blueAccent.withOpacity(0.8),
                      backgroundColor: const Color(0xFF1E1E1E),
                      onSelected: (isSelected) {
                        setState(() {
                          selectedMood = isSelected ? mood : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.08,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_textController.text.isNotEmpty && selectedMood != null) {
                          if (isEditing) {
                            setState(() {
                              entries[editIndex!].text = _textController.text;
                              entries[editIndex].mood = selectedMood!;
                            });
                            await _saveEntries();
                          } else {
                            _addEntry(_textController.text, selectedMood!);
                          }
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please enter text and select a mood.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                        await _loadEntries();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.08,
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
);

  }

@override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    
                  
    backgroundColor: Colors.transparent,
    body: entries.isEmpty
        ? Center(
            child: Container(
             
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.note_add,
                    size: screenWidth * 0.15, // Scaled icon size
                    color: Colors.white.withOpacity(0.8),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'No entries yet.\nTap the + button to add one!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Scaled font size
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: 
                
                  Text(
                    "Diary",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),),
            Expanded(
              child: ListView.separated(
                 
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.01),
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.grey.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        entries[index].text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${entries[index].mood} | ${entries[index].date.day}/${entries[index].date.month}/${entries[index].date.year}',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () async {
                          await _deleteEntry(index);
                          await _loadEntries();
                          setState(() {});
                        },
                      ),
                      onTap: () => _openBottomSheet(editIndex: index),
                    );
                  },
                ),
            ),
          ],
        ),
    floatingActionButton: GestureDetector(
  onTap: () => _openBottomSheet(),
  child: Container(
    width: 70, // Adjust size as needed
    height: 70,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [
          Color(0xff4784B2).withOpacity(0.8), Color(0xffAB72AC).withOpacity(0.7)
     
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          spreadRadius: 5,
          offset: Offset(0, 5),
        ),
      ],
      border: Border.all(
        color: Colors.white.withOpacity(0.5),
        width: 1.5,
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
     
        // Icon in the center
        const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ],
    ),
  ),
),

  );
}


}
