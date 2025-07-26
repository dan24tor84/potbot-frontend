package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;
import com.getcapacitor.plugin.Camera;
import com.getcapacitor.plugin.Geolocation;
import com.getcapacitor.plugin.Permissions;

import java.util.ArrayList;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initialize Capacitor plugins
        this.init(
            savedInstanceState,
            new ArrayList<Class<? extends Plugin>>() {{
                add(Camera.class);
                add(Geolocation.class);
                add(Permissions.class);
            }}
        );
    }
}
