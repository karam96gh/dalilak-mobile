import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/data_providers.dart';
import '../../widgets/shimmer_skeletons.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        elevation: 0,
      ),
      body: notificationsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 6,
          itemBuilder: (_, __) => NotificationSkeleton(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              const Text('حدث خطأ'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(notificationsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة محاولة'),
              ),
            ],
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('لا توجد إشعارات'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: notification.image != null
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(notification.image ?? ''),
                        )
                      : CircleAvatar(
                          child: Icon(Icons.notifications),
                        ),
                  title: Text(notification.title),
                  subtitle: Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  onTap: () async {
                    if (notification.linkType == 'listing' &&
                        notification.linkId != null) {
                      context.go('/listing/${notification.linkId}');
                    } else if (notification.linkUrl != null) {
                      final url = notification.linkUrl ?? '';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
