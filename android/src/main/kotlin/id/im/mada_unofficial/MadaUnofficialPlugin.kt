package id.im.mada_unofficial

import android.app.Activity
import androidx.annotation.NonNull
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** MadaUnofficialPlugin */
class MadaUnofficialPlugin : FlutterPlugin, ActivityAware {

    companion object {
        val madaResponseLiveData = MutableLiveData<String?>()
    }

    lateinit var channel: MethodChannel
    var activity: Activity? = null
    private val responseObserver = Observer<String?> { response ->
        channel.invokeMethod(
            "mada_response", JSONObject(
                mapOf("success" to true, "response_data" to response)
            ).toString()
        )
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mada_unofficial")
        channel.setMethodCallHandler(PluginHandler(this))
        ECRUtils.sendAndReceiveBroadcast(flutterPluginBinding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        madaResponseLiveData.observeForever(responseObserver)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
//        madaResponseLiveData.removeObserver(responseObserver)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
//        madaResponseLiveData.observeForever(responseObserver)
    }

    override fun onDetachedFromActivity() {
        activity?.let { ECRUtils.unRegisterBroadcast(it.applicationContext) }
        activity = null
        madaResponseLiveData.removeObserver(responseObserver)
    }
}
