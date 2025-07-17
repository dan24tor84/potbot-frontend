package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;
import com.getcapacitor.plugin.camera.CameraPlugin;
import com.getcapacitor.plugin.filesystem.FilesystemPlugin;
import com.getcapacitor.plugin.geolocation.GeolocationPlugin;
import com.getcapacitor.plugin.localnotifications.LocalNotificationsPlugin;
import com.getcapacitor.plugin.pushnotifications.PushNotificationsPlugin;

import java.util.ArrayList;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
            add(CameraPlugin.class);
            add(FilesystemPlugin.class);
            add(GeolocationPlugin.class);
            add(LocalNotificationsPlugin.class);
            add(PushNotificationsPlugin.class);
        }});
    }
}