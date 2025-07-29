package com.rankyourdank.potbot;

import android.os.Bundle;

import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;

import com.getcapacitor.community.camera.CameraPreview;
import com.getcapacitor.plugin.camera.Camera;
import com.getcapacitor.plugin.filesystem.Filesystem;
import com.getcapacitor.plugin.geolocation.Geolocation;
import com.getcapacitor.plugin.permissions.Permissions;

import java.util.ArrayList;

public class MainActivity extends BridgeActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initialize plugins manually
        this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
            add(Camera.class);
            add(Filesystem.class);
            add(Geolocation.class);
            add(Permissions.class);
        }});
    }
}
