package me.navidicted.derspp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.widget.Toast

class MainActivity : FlutterActivity() {
    private val CHANNEL = "me.navidicted.derspp/toast"
    private var currentToast: Toast? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showToast") {
                val message = call.argument<String>("message")
                
                currentToast?.cancel()
                
                currentToast = Toast.makeText(this, message, Toast.LENGTH_SHORT)
                currentToast?.show()
                
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
