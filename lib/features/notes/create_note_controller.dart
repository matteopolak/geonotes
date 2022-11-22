import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key, this.noteId, this.title, this.content});

  final String? noteId;
  final String? title;
  final String? content;

  @override
  State<CreateNotePage> createState() => CreateNotePageState();
}

class CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController _title =
      TextEditingController(text: 'Note title...');
  final TextEditingController _content = TextEditingController();

  String? _noteId;
  bool _sameTitle = true;
  bool _sameContent = true;
  String? _lastSavedContent;
  String? _lastSavedTitle;

  void _saveNote() async {
    setState(() {
      _lastSavedContent = _content.text;
      _lastSavedTitle = _title.text;
      _sameTitle = true;
      _sameContent = true;
    });

    // save the note content or update if it already exists
    if (_noteId == null) {
      DocumentReference note =
          await FirebaseFirestore.instance.collection('notes').add({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'content': _content.text.isEmpty ? null : _content.text,
        'title': _title.text.isEmpty ? null : _title.text,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      _noteId = note.id;
    } else {
      await FirebaseFirestore.instance.collection('notes').doc(_noteId).update({
        'content': _content.text,
        'title': _title.text,
        'updatedAt': DateTime.now()
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.title != null) {
      _title.text = widget.title!;
    }

    if (widget.content != null) {
      _content.text = widget.content!;
    }

    if (widget.noteId != null) {
      _noteId = widget.noteId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notesPageTitle),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: // add text box for title and make the note content box span the rest of the page
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _title,
              maxLength: 256,
              maxLines: null,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
              ),
              onChanged: (data) {
                bool sameTitle = data == _lastSavedTitle;
                if (_sameTitle == sameTitle) return;

                setState(() {
                  _sameTitle = sameTitle;
                });
              },
            ),
            Expanded(
                child: TextFormField(
              controller: _content,
              maxLength: 2048,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Note content...',
                counterText: '',
              ),
              onChanged: (data) {
                bool sameContent = data == _lastSavedContent;
                if (_sameContent == sameContent) return;

                setState(() {
                  _sameContent = sameContent;
                });
              },
            )),
          ],
        ),
      ),
      floatingActionButton: _sameContent && _sameTitle
          ? null
          : SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                onPressed: _saveNote,
                tooltip: 'Save note',
                child: const Icon(Icons.save, size: 30),
              ),
            ),
    );
  }
}
