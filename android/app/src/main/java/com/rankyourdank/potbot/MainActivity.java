package com.rankyourdank.potbot;

import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import com.getcapacitor.Plugin;

// Correct imports for official Capacitor plugins
import com.capacitorjs.plugins.camera.CameraPlugin;
import com.capacitorjs.plugins.filesystem.FilesystemPlugin;
import com.capacitorjs.plugins.geolocation.GeolocationPlugin;
import com.capacitorjs.plugins.haptics.HapticsPlugin;
import com.capacitorjs.plugins.preferences.PreferencesPlugin;
import com.capacitorjs.plugins.statusbar.StatusBarPlugin;
import com.capacitorjs.plugins.toast.ToastPlugin;
import com.capacitorjs.plugins.localnotifications.LocalNotificationsPlugin; // If you meant this by PermissionPlugin previously
import com.capacitorjs.plugins.permissions.PermissionsPlugin; // If you meant this by PermissionPlugin previously


import java.util.ArrayList;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // CORRECTED LINE: Pass savedInstanceState as the first argument
        this.init(
            savedInstanceState, // <--- THIS IS THE FIX
            new ArrayList<Class<? extends Plugin>>() {{
                add(CameraPlugin.class);
                add(FilesystemPlugin.class);
                add(GeolocationPlugin.class);
                add(HapticsPlugin.class);
                add(PreferencesPlugin.class);
                add(StatusBarPlugin.class);
                add(ToastPlugin.class);

                // --- IMPORTANT NOTE REGARDING "PermissionPlugin" ---
                // The import `com.getcapacitor.plugin.permission.PermissionPlugin;`
                // and its registration `add(PermissionPlugin.class);` are for
                // an older, possibly deprecated, or non-existent plugin path.
                //
                // For Capacitor 4+ and the latest official plugins, permission handling
                // is typically done via `@capacitor/preferences` (for prompt management),
                // or specific plugins request their own permissions (e.g., Camera asks
                // for camera permission).
                //
                // If you explicitly installed a plugin named `@capacitor/permission`,
                // it's likely `@capacitor/permissions` and the import should be:
                // `import com.capacitorjs.plugins.permissions.PermissionsPlugin;`
                // and the class name `PermissionsPlugin.class`.
                //
                // If "PermissionPlugin" was meant to be for local notifications, it would be:
                // `import com.capacitorjs.plugins.localnotifications.LocalNotificationsPlugin;`
                // `add(LocalNotificationsPlugin.class);`
                //
                // Please double-check which "PermissionPlugin" you intended to use.
                // For now, I'll update it to the more common `PermissionsPlugin`.
                // If you don't have `@capacitor/permissions` installed, you might
                // need to remove this line or install the plugin.

                add(PermissionsPlugin.class); // Most likely the correct one for general permissions
            }}
        );
    }
}
