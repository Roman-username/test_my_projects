import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../styles.dart';
import '../../notifiers/notifiers.dart';
import '../edit_user_field_page.dart';

class UserFieldListTiles extends ConsumerWidget {
  const UserFieldListTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).value;
    final name = user?.name;
    final lastName = user?.lastName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
        ),
        child: Column(
          children: [
            _buildTile(context,
                name: name,
                onPressed: (v) => ref
                    .watch(editUserParamsNotifierProvider.notifier)
                    .setField(name: v),
                title: 'Ваше Имя'),
            _buildTile(context,
                name: lastName,
                onPressed: (v) => ref
                    .watch(editUserParamsNotifierProvider.notifier)
                    .setField(lastName: v),
                title: 'Ваша Фамилия'),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required String? name,
    required void Function(String) onPressed,
    required String title,
  }) =>
      Column(children: [
        CupertinoListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditUserFieldPage(
                title: title,
                prevPageTitle: 'Аккаунт',
                onChanged: onPressed,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            name == null || name.isEmpty ? title : name,
            style: const TextStyle(fontSize: 16),
          ),
          additionalInfo: const Text(
            'Настроить',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFC6C6C8),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: Color(0xFFC6C6C8),
          ),
        ),
        const Divider(
          height: 1,
          color: Color(0xFFC6C6C8),
        ),
      ]);
}

class EmailField extends ConsumerWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 30),
        const Text(
          'Добавьте email',
          style: TextStyle(fontSize: 12, color: kUnselectedItemColor),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditUserFieldPage(
                  title: 'Ваш Email',
                  prevPageTitle: 'Аккаунт',
                  onChanged: (v) => ref
                      .watch(editUserParamsNotifierProvider.notifier)
                      .setField(email: v),
                ),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'На почту отправлено письмо подтверждения',
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 300,
                  horizontal: 16,
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.edit,
            size: 18,
          ),
        ),
      ],
    );
  }
}

class AvatarButton extends ConsumerWidget {
  const AvatarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).value;
    final photoUrl = user?.photoURL;
    return Center(
      child: Stack(
        children: [
          if (photoUrl == null)
            const CircleAvatar(
              radius: 37.5,
              backgroundColor: Color(0xFFE3E3E3),
              child: Icon(
                MyProjectIcons.account,
                color: kSelectedItemColor,
                size: 60,
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                height: 75,
                width: 75,
                imageUrl: photoUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                final photo = await showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text('Выберите фото'),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () async {
                          final photo = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          Navigator.pop(context, photo);
                        },
                        child: const Text('Камера'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () async {
                          final photo = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          Navigator.pop(context, photo);
                        },
                        child: const Text('Галерея фото'),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Закрыть'),
                    ),
                  ),
                );
                if (photo == null) return;
                ref
                    .watch(editUserParamsNotifierProvider.notifier)
                    .setField(photo: File(photo.path));
                ref.read(userNotifierProvider.notifier).editUser();
              },
              child: const CircleAvatar(
                backgroundColor: kScaffoldBackground,
                radius: 15,
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: kSelectedItemColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
