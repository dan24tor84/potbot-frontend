package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;

import com.getcapacitor.plugin.camera.CameraPlugin;
import com.getcapacitor.plugin.filesystem.FilesystemPlugin;
import com.getcapacitor.plugin.geolocation.GeolocationPlugin;
import com.getcapacitor.plugin.haptics.HapticsPlugin;
import com.getcapacitor.plugin.preferences.PreferencesPlugin;
import com.getcapacitor.plugin.statusbar.StatusBarPlugin;
import com.getcapacitor.plugin.toast.ToastPlugin;

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
        add(ToastPlugin.class);
      }}
    );
  }
}
