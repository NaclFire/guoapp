import 'package:flutter/material.dart';

import '../app_build.dart';
import 'app_scope.dart';
import 'widgets/focus_ring.dart';

const _clauses = [
  '$appName 是开源软件，源代码全部公开，仅供个人学习与技术研究，**不收费，不提供任何付费服务**。',
  '$appName 与红果短剧及其他各站源的运营方**无任何关联**，未获得其授权或认可；文中提到的名称和商标归各自权利人所有。',
  '$appName 本身**不存储、不上传、不分发任何影视内容**，所有内容均来自第三方站点，版权归原权利人所有；应用不解除源站 VIP 或其他授权限制。',
  '通过本应用观看或下载的内容仅供试看和个人学习交流，**请于下载后 24 小时内删除**；如喜欢相关作品，请支持正版。',
  '**不得在任何公开平台（如社交媒体、短视频平台、论坛、公开群组等）宣传、分享本应用及其安装包、下载链接或通过本应用获取的内容**。',
  '站源内容（包括其中的广告、链接、二维码、联系方式等）均由第三方提供，**请自行鉴别真伪，切勿轻信其中的充值、投资、博彩、兼职等信息**；**由此造成的任何财产损失，作者不承担任何责任**。',
  '观看记录、追剧和下载等数据只保存在本设备。开启「匿名使用统计」时，启动时发送随机编号、版本号和平台用于统计使用人数，可在设置 › 关于中关闭。',
  '你应遵守所在地法律法规及各站点的服务条款，**不得将本应用用于违法或商业用途**；**因使用本应用产生的一切后果由你自行承担**。',
  '本应用按「现状」提供，不对可用性、稳定性或适用性作任何保证，**作者不承担由此造成的任何直接或间接损失**。',
  '如不同意本条款，**请立即停止使用并卸载本应用**。',
];

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final television = AppScope.of(context).television;
    final body = theme.textTheme.bodyMedium?.copyWith(height: 1.6);
    final emphasis = TextStyle(
      color: theme.colorScheme.error,
      fontWeight: FontWeight.w600,
    );
    return SingleChildScrollView(
      padding: television
          ? const EdgeInsets.symmetric(horizontal: televisionInset, vertical: 8)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              for (final (index, clause) in _clauses.indexed)
                FocusRing(
                  radius: 8,
                  scale: 1,
                  child: Focus(
                    canRequestFocus: television,
                    autofocus: television && index == 0,
                    child: Text.rich(
                      TextSpan(
                        text: '${index + 1}. ',
                        children: [
                          for (final (part, text) in clause.split('**').indexed)
                            TextSpan(
                              text: text,
                              style: part.isOdd ? emphasis : null,
                            ),
                        ],
                      ),
                      style: body,
                    ),
                  ),
                ),
              Text(
                '继续使用即视为同意以上条款。',
                style: body?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
