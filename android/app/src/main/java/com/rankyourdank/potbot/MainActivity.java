package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;

import com.capacitorjs.plugins.camera.CameraPlugin;
import com.capacitorjs.plugins.filesystem.FilesystemPlugin;
import com.capacitorjs.plugins.geolocation.GeolocationPlugin;
import com.capacitorjs.plugins.haptics.HapticsPlugin;
import com.capacitorjs.plugins.preferences.PreferencesPlugin;
import com.capacitorjs.plugins.statusbar.StatusBarPlugin;
import com.capacitorjs.plugins.toast.ToastPlugin;
import com.capacitorjs.plugins.localnotifications.LocalNotificationsPlugin;

import java.util.ArrayList;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.init(
            savedInstanceState,
            new ArrayList<Class<? extends Plugin>>() {{
                add(CameraPlugin.class);
                add(FilesystemPlugin.class);
                add(GeolocationPlugin.class);
                add(HapticsPlugin.class);
                add(PreferencesPlugin.class);
                add(StatusBarPlugin.class);
                add(ToastPlugin.class);
                add(LocalNotificationsPlugin.class);
            }}
        );
    }
}
