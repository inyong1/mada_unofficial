package id.im.mada_unofficial;

import android.annotation.SuppressLint;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;

public class ECRUtils {

    private static GetPortBroadcastReceiver getPortBroadcastReceiver;

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    public static void sendAndReceiveBroadcast(Context context) {
        Intent intent = new Intent();
        intent.setAction("com.skyband.pos.app.send.ecr.port");
        // send ecr connection mode to payment app for its usage.
        intent.putExtra("ConnectionMode", "appToAppIntent");
        intent.putExtra("packageName", context.getPackageName());
        intent.addFlags(Intent.FLAG_INCLUDE_STOPPED_PACKAGES);
        intent.setComponent(
                new ComponentName("com.skyband.pos.app", "com.skyband.pos.app.ui.ecr.ECRPortBroadcastReceiver"));
        context.sendBroadcast(intent);
        getPortBroadcastReceiver = new GetPortBroadcastReceiver();
        IntentFilter intentFilter = new IntentFilter("com.skyband.pos.perform.port");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.registerReceiver(getPortBroadcastReceiver, intentFilter, Context.RECEIVER_NOT_EXPORTED);
        }else{
            context.registerReceiver(getPortBroadcastReceiver, intentFilter);
        }
    }

    public static void unRegisterBroadcast(Context context) {
        if (getPortBroadcastReceiver != null) {
            context.unregisterReceiver(getPortBroadcastReceiver);
            getPortBroadcastReceiver = null;
        }
    }
}
