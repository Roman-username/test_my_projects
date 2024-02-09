import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../validators.dart';
import '../notifiers/notifiers.dart';

class EditUserFieldPage extends ConsumerStatefulWidget {
  final String title;
  final String? prevPageTitle;
  final void Function(String) onChanged;

  const EditUserFieldPage({
    required this.title,
    this.prevPageTitle,
    required this.onChanged,
    super.key,
  });

  @override
  ConsumerState<EditUserFieldPage> createState() => _EditUserFieldPageState();
}

class _EditUserFieldPageState extends ConsumerState<EditUserFieldPage> {
  final _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        ref.read(userNotifierProvider.notifier).editUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: TextButton.icon(
          onPressed: () {
            _focusNode.unfocus();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          label: Text(
            widget.prevPageTitle ?? '',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        leadingWidth: 125,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Form(
          key: _formKey,
          child: TextFormField(
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            onTapOutside: (e) => _focusNode.unfocus(),
            validator: nameValidator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(hintText: widget.title),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
