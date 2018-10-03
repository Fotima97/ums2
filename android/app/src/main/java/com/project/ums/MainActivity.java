package com.project.ums;

import android.os.Bundle;
import android.content.Intent;
import android.net.Uri;
import android.Manifest;
import android.support.v4.app.ActivityCompat;
import android.content.pm.PackageManager;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.lang.String	;


public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.project.ums/call";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                String number=call.arguments();
                // TODO
                if (call.method.equals("callNumber")) {
                  Intent callIntent = new Intent(Intent.ACTION_CALL);
                  callIntent.setData(Uri.parse("tel:"+number));
              // ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.CALL_PHONE}, 1);
              //    startActivity(callIntent);

            if (ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
    ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.CALL_PHONE},1);
}
else
{
    startActivity(callIntent);
}
        



                } else {
                  result.notImplemented();
                }
              }
            });  }
}
