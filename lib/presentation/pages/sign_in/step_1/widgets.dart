import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../styles.dart';
import '../../../notifiers/notifiers.dart';
import '../widgets.dart';
import 'utils.dart';

const _phoneFormatter = PhoneMaskFormatter('\u{200B}');

class SendSmsButton extends ConsumerWidget {
  const SendSmsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = ref.watch(verifyPhoneParamsNotifierProvider);
    final phone = params.phoneNumber;
    return Column(
      children: [
        FilledButton(
          onPressed: () async {
            if (phone.length < _phoneFormatter.mask.length) return;
            ref.read(signInStepIdxNotifierProvider.notifier).increment();
            ref.read(userNotifierProvider.notifier).verifyPhone();
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 68, vertical: 16),
            backgroundColor: phone.length < _phoneFormatter.mask.length
                ? const Color(0xFFA7A7A7)
                : kSignInPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              const Text('Отправить смс-код', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(fontSize: 10, color: Color(0xFFA7A7A7)),
            children: <TextSpan>[
              TextSpan(
                  text: 'Нажимая на данную кнопку, вы даете'
                      '\nсогласие на обработку '),
              TextSpan(
                  text: 'персональных данных',
                  style: TextStyle(color: kSignInPrimaryColor)),
            ],
          ),
        )
      ],
    );
  }
}

class PhoneFlied extends ConsumerStatefulWidget {
  const PhoneFlied({super.key});

  @override
  ConsumerState<PhoneFlied> createState() => _PhoneFliedState();
}

class _PhoneFliedState extends ConsumerState<PhoneFlied> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController(text: '+7');
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final newTextLength = _controller.text.length;
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: newTextLength));
    });

    _focusNode.addListener(
      () => setState(() {
        if (_controller.text.length <= 2) {
          _controller.text = _phoneFormatter.mask;
        }
        _validateOnComplete();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(
          label: 'Номер телефона',
          onChanged: (v) => ref
              .read(verifyPhoneParamsNotifierProvider.notifier)
              .phone = v.replaceAll(_phoneFormatter.wildcard, ''),
          showCursor: false,
          inputFormatters: const [_phoneFormatter],
          keyboardType: TextInputType.phone,
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _isError ? Colors.red : const Color(0xFFD9D9D9),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: _isError ? Colors.red : kSignInPrimaryColor),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _validateOnComplete() {
    bool isValid =
        phoneMaskValidator(_controller.text, _phoneFormatter.wildcard) == null;
    if (isValid || _focusNode.hasFocus) {
      _isError = false;
      return;
    }
    _isError = true;
  }
}
