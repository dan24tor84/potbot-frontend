package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;

import com.getcapacitor.camera.CameraPlugin;
import com.getcapacitor.filesystem.FilesystemPlugin;
import com.getcapacitor.geolocation.GeolocationPlugin;
import com.getcapacitor.haptics.HapticsPlugin;
import com.getcapacitor.preferences.PreferencesPlugin;
import com.getcapacitor.statusbar.StatusBarPlugin;
import com.getcapacitor.permissions.PermissionsPlugin;
import com.getcapacitor.toast.ToastPlugin;

import java.util.ArrayList;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.init(
            new ArrayList<Class<? extends Plugin>>() {{
                add(CameraPlugin.class);
                add(FilesystemPlugin.class);
                add(GeolocationPlugin.class);
                add(HapticsPlugin.class);
                add(PreferencesPlugin.class);
                add(StatusBarPlugin.class);
                add(PermissionsPlugin.class);
                add(ToastPlugin.class);
            }}
        );
    }
}
