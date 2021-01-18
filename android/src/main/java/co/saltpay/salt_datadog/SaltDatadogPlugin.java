package co.saltpay.salt_datadog;

import android.util.Log;

import androidx.annotation.NonNull;

import com.datadog.android.Datadog;
import com.datadog.android.DatadogConfig;
import com.datadog.android.privacy.TrackingConsent;
import com.datadog.android.rum.GlobalRum;
import com.datadog.android.rum.RumErrorSource;
import com.datadog.android.rum.RumMonitor;
import com.datadog.android.rum.RumActionType;
import com.datadog.android.rum.RumResourceKind;
import com.datadog.android.log.Logger;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

    public class SaltDatadogPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private FlutterPluginBinding flutterPluginBinding;
    private Logger datadogLogger;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "salt_datadog");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("init")) {
            DatadogConfig config = new DatadogConfig.Builder(
                "pub6de5d25ee61dc1cb99f774e8f935c2ca", 
                "development",
                "441316d2-4c7b-4317-b3d4-77bb4a66927d"
            )
            .useEUEndpoints()
            .setRumEnabled(true)
            .build();
            Datadog.initialize(
                this.flutterPluginBinding.getApplicationContext(),
                TrackingConsent.GRANTED,
                config
            );
            Datadog.setVerbosity(Log.INFO);
            GlobalRum.registerIfAbsent(new RumMonitor.Builder().build());

            datadogLogger = new Logger.Builder()
                .setNetworkInfoEnabled(true)
                .setServiceName("co.saltpay.terminal.salt.development")
                .setLogcatLogsEnabled(true)
                .setDatadogLogsEnabled(true)
                .setLoggerName("datadog")
                .build();

            datadogLogger.d("Datadog initialized");
            result.success(true);
        } else if (call.method.equals("addError")) {
            String message = call.argument("message");
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "addError", 
            //     "message='" + message + "', " +
            //     "attributes=" + attributes.toString()
            // );
            // datadogLogger.d(
            //     "addError: " +
            //     "message='" + message + "', " +
            //     "attributes=" + attributes.toString()
            // );
            GlobalRum.get().addError(
                message, 
                RumErrorSource.LOGGER, 
                null, 
                attributes
            );
            result.success(true);            
        } else if (call.method.equals("startView")) {
            String viewKey = call.argument("viewKey").toString();
            String viewName = call.argument("viewName").toString();
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "startView", 
            //     "viewName='" + viewName + "', " +
            //     "viewKey='" + viewKey + "', " +
            //     "attributes=" + attributes.toString()
            // );
            // datadogLogger.d(
            //     "startView: " +
            //     "viewName='" + viewName + "', " +
            //     "viewKey='" + viewKey + "', " +
            //     "attributes=" + attributes.toString()
            // );
            GlobalRum.get().startView(viewKey, viewName, attributes);
            result.success(true);
        } else if (call.method.equals("stopView")) {
            String viewKey = call.argument("viewKey").toString();
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "stopView", 
            //     "viewKey='" + viewKey + "', " +
            //     "attributes=" + attributes.toString()
            // );
            // datadogLogger.d(
            //     "stopView: " +
            //     "viewKey='" + viewKey + "', " +
            //     "attributes=" + attributes.toString()
            // );
            GlobalRum.get().stopView(viewKey, attributes);
            result.success(true);
        } else if (call.method.equals("addUserAction")) {
            String name = call.argument("name").toString();
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "addUserAction", 
            //     "name='" + name + "', " +
            //     "attributes=" + attributes.toString()
            // );
            // datadogLogger.d(
            //     "addUserAction: " +
            //     "name='" + name + "', " +
            //     "attributes=" + attributes.toString()
            // );
            GlobalRum.get().addUserAction(
                RumActionType.CUSTOM,
                name, 
                attributes
            );
            result.success(true);
        } else if (call.method.equals("startUserAction")) {
            String name = call.argument("name").toString();
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "startUserAction", 
            //     "name='" + name + "', " +
            //     "attributes=" + attributes.toString()
            // );
            // datadogLogger.d(
            //     "startUserAction: " +
            //     "name='" + name + "', " +
            //     "attributes=" + attributes.toString()
            // );
            GlobalRum.get().startUserAction(
                RumActionType.CUSTOM,
                name, 
                attributes
            );
            result.success(true);
        } else if (call.method.equals("stopUserAction")) {
            String name = call.argument("name").toString();
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "stopUserAction", 
            //     "name='" + name + "', " +
            //     "attributes=" + attributes.toString()
            // );
            // datadogLogger.d(
            //     "stopUserAction: " +
            //     "name='" + name + "', " +
            //     "attributes=" + attributes.toString()
            // );
            GlobalRum.get().stopUserAction(
                RumActionType.CUSTOM,
                name, 
                attributes
            );
            result.success(true);
        } else if (call.method.equals("startResource")) {
            String key = call.argument("key").toString();
            String method = call.argument("method").toString();
            String url = call.argument("url").toString();
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "startResource", 
            //     "key='" + key + "', " +
            //     "method='" + method + "', " +
            //     "url='" + url + "', " +
            //     "attributes=" + attributes.toString()
            // );
            // datadogLogger.d(
            //     "startResource: " +
            //     "key='" + key + "', " +
            //     "method='" + method + "', " +
            //     "url='" + url + "', " +
            //     "attributes=" + attributes.toString()
            // );
            GlobalRum.get().startResource(
                key,
                method,
                url, 
                attributes
            );
            result.success(true);
        } else if (call.method.equals("stopResource")) {
            String key = call.argument("key").toString();
            int statusCode = Integer.parseInt(
                call.argument("statusCode").toString()
            );
            long size = Integer.parseInt(
                call.argument("size").toString()
            );
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "stopResource", 
            //     "key='" + key + "', " +
            //     "statusCode='" + statusCode + "', " +
            //     "size='" + size + "', " +
            //     "attributes=" + attributes.toString()
            // );
            // datadogLogger.d(
            //     "stopResource: " +
            //     "key='" + key + "', " +
            //     "statusCode='" + statusCode + "', " +
            //     "size='" + size + "', " +
            //     "attributes=" + attributes.toString()
            // );
            GlobalRum.get().stopResource(
                key,
                statusCode,
                size,
                RumResourceKind.DOCUMENT,
                attributes
            );
            result.success(true);
        } else if (call.method.equals("log")) {
            String message = call.argument("message");
            Map<String, String> attributes = call.argument("attributes");
            // Log.d(
            //     "log", 
            //     "message='" + message + "', " +
            //     "attributes=" + attributes.toString()
            // );
            datadogLogger.d(message);
            result.success(true);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
