package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;

import java.util.ArrayList;

import com.getcapacitor.community.camera.Camera;
import com.getcapacitor.community.filesystem.Filesystem;
import com.getcapacitor.community.geolocation.Geolocation;
import com.getcapacitor.community.permissions.Permissions;

public class MainActivity extends BridgeActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
            add(Camera.class);
            add(Filesystem.class);
            add(Geolocation.class);
            add(Permissions.class);
        }});
    }
}
