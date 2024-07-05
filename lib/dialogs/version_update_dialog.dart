import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:app_rhyme/src/rust/api/check_update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

void showVersionUpdateDialog(BuildContext context, Release release) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("版本更新", style: const TextStyle().useSystemChineseFont()),
        content: Column(
          children: [
            Text('作者: ${release.author.login}'),
            Text('名称: ${release.name}'),
            Text('版本: ${release.tagName}'),
            Text('时间: ${release.createdAt}'),
            Text('内容: ${release.body}')
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('下载'),
            onPressed: () async {
              Navigator.of(context).pop();
              if (await canLaunchUrl(Uri.parse(release.htmlUrl))) {
                await launchUrl(Uri.parse(release.htmlUrl));
              } else {
                await Clipboard.setData(ClipboardData(text: release.htmlUrl));
                toastification.show(
                    autoCloseDuration: const Duration(seconds: 2),
                    type: ToastificationType.error,
                    title: Text("打开下载页面失败",
                        style: const TextStyle().useSystemChineseFont()),
                    description: Text("已复制链接到剪切板，请在浏览器中打开并下载",
                        style: const TextStyle().useSystemChineseFont()));
              }
            },
          ),
          CupertinoDialogAction(
            child: const Text('关闭'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}