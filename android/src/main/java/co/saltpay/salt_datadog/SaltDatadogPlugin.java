package co.saltpay.salt_datadog;

import android.util.Log;

import androidx.annotation.NonNull;

import com.datadog.android.Datadog;
import com.datadog.android.DatadogConfig;
import com.datadog.android.privacy.TrackingConsent;
import com.datadog.android.rum.GlobalRum;
import com.datadog.android.rum.RumErrorSource;
import com.datadog.android.rum.RumMonitor;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * SaltDatadogPlugin
 */
public class SaltDatadogPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "salt_datadog");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("init")) {
            DatadogConfig config = new DatadogConfig.Builder("pub6de5d25ee61dc1cb99f774e8f935c2ca", "development", "441316d2-4c7b-4317-b3d4-77bb4a66927d")
                    .useEUEndpoints()
                    .setRumEnabled(true)
                    .build();
            Datadog.initialize(this.flutterPluginBinding.getApplicationContext(), TrackingConsent.GRANTED, config);
            GlobalRum.registerIfAbsent(new RumMonitor.Builder().build());
            result.success(true);
        } else if (call.method.equals("addError")) {
            String message = call.argument("message");
            GlobalRum.get().addError(message, RumErrorSource.LOGGER, new Throwable(), new HashMap<String, String>());
            Log.d("addError", message);
        } else if (call.method.equals("startView")) {
            Map<String, String> map = new HashMap<>();
            map.put("test", "Amit");
            String viewKey = call.argument("viewKey");
            GlobalRum.get().startView(viewKey, viewKey, map);
            Log.d("startView", viewKey);
        } else if (call.method.equals("stopView")) {
            Map<String, String> map = new HashMap<>();
            map.put("test", "Amit");
            String viewKey = call.argument("viewKey");
            GlobalRum.get().stopView(viewKey, map);
            Log.d("stopView", viewKey);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
