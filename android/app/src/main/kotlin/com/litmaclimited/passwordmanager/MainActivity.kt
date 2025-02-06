//package com.litmaclimited.passwordmanager
//
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity()
package com.litmaclimited.passwordmanager

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Environment
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.litmaclimited.passwordmanager/csv"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveCSV" -> {
                    val data = call.argument<String>("data")
                    if (data != null) {
                        val filePath = saveCSVToFile(data)
                        if (filePath != null) {
                            result.success(filePath)
                        } else {
                            result.error("SAVE_FAILED", "Failed to save CSV file", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "No data provided", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun saveCSVToFile(csvData: String): String? {
        val directory = getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS)
        val file = File(directory, "data.csv")

        return try {
            FileOutputStream(file).use {
                it.write(csvData.toByteArray())
            }
            file.absolutePath
        } catch (e: IOException) {
            e.printStackTrace()
            null
        }
    }

}
