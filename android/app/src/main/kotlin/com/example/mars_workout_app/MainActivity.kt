package com.example.mars_workout_app

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.mars_workout_app/pip"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "enterPiP") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val builder = PictureInPictureParams.Builder()
                    val aspectRatio = Rational(16, 9)
                    builder.setAspectRatio(aspectRatio)
                    enterPictureInPictureMode(builder.build())
                    result.success(null)
                } else {
                    result.error("UNAVAILABLE", "PiP not supported on this device", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}