import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geonotes/features/notes/create_note_controller.dart';
import '../login/login_controller.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  void _createNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateNotePage(),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  Widget getNotes() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('notes')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('updatedAt', descending: true)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.grey),
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Text(AppLocalizations.of(context)!.notesFetchError));
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data!.docs[index]['title'] ??
                    AppLocalizations.of(context)!.defaultNoteTitle),
                subtitle: Text(snapshot.data!.docs[index]['content'] ?? '',
                    overflow: TextOverflow.ellipsis),
                onLongPress: () => {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title:
                          Text(AppLocalizations.of(context)!.deleteNoteTitle),
                      content:
                          Text(AppLocalizations.of(context)!.deleteNoteMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('notes')
                                .doc(snapshot.data!.docs[index].id)
                                .delete()
                                .then((_) {
                              Navigator.pop(context);

                              setState(() {});
                            });
                          },
                          child: Text(AppLocalizations.of(context)!.delete),
                        ),
                      ],
                    ),
                  )
                },
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNotePage(
                        noteId: snapshot.data!.docs[index].id,
                        title: snapshot.data!.docs[index]['title'],
                        content: snapshot.data!.docs[index]['content'],
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  })
                },
              );
            },
          );
        } else {
          return Text(AppLocalizations.of(context)!.noNotes);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(AppLocalizations.of(context)!.notesPageTitle),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ]),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(child: getNotes()),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: _createNote,
          tooltip: AppLocalizations.of(context)!.createNoteLabel,
          child: const Icon(Icons.note_add, size: 30),
        ),
      ),
    );
  }
}
