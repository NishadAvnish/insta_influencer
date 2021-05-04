import 'package:cron/cron.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/logined_current_provider.dart';

final currentIndexValue = ValueNotifier(0);
final isLogin = ValueNotifier(false);
Cron cron;
Function startCron(BuildContext context) {
  cron = Cron();
  cron.schedule(Schedule.parse('*/2 * * * *'), () async {
    Provider.of<LoginCurrentNoProvider>(context, listen: false)
        .changeCurrentStatus(flag: 3);
  });
}
