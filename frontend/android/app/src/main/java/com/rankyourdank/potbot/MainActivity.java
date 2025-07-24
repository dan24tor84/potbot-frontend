package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;

import com.getcapacitor.community.camera.CameraPreview;
import com.getcapacitor.community.filepicker.FilePicker;
import com.getcapacitor.community.geolocation.GeolocationPlugin;
import com.getcapacitor.community.permissions.PermissionsPlugin;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.init(
                savedInstanceState,
                new Plugin[] {
                        CameraPreview.class,
                        FilePicker.class,
                        GeolocationPlugin.class,
                        PermissionsPlugin.class
                }
        );
    }
}