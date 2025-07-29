package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginConfig;
import com.getcapacitor.community.camera.CameraPreview;
import com.getcapacitor.plugin.camera.Camera;
import com.getcapacitor.plugin.filesystem.Filesystem;
import com.getcapacitor.plugin.geolocation.Geolocation;
import com.getcapacitor.plugin.permissions.Permissions;

import java.util.ArrayList;

public class MainActivity extends BridgeActivity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
      add(Camera.class);
      add(Filesystem.class);
      add(Geolocation.class);
      add(Permissions.class);
    }});
  }
}
