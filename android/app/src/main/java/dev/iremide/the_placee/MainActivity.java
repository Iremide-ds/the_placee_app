package dev.iremide.the_placee;

import android.os.Bundle;

import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
//import io.flutter.plugins.googlesignin.GoogleSignInPlugin;

public class MainActivity extends FlutterActivity {
    /*GoogleSignInPlugin.registerWith(registry.registrarFor("io.flutter.plugins.googlesignin.GoogleSignInPlugin"));
//    GeneratedPluginRegistrant().registerWith(this);
    private final GeneratedPluginRegistrant generatedPluginRegistrant = new GeneratedPluginRegistrant();
    generatedPluginRegistrant.registerWith(this);*/
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        GoogleSignInPlugin.registerWith();
        GeneratedPluginRegistrant.registerWith(Objects.requireNonNull(this.getFlutterEngine()));
    }
}
