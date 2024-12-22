package id.im.mada_unofficial

import android.content.Intent
import com.skyband.ecr.sdk.CLibraryLoad
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONObject
import java.security.MessageDigest
import java.text.SimpleDateFormat
import java.util.Locale

class PluginHandler(val plugin: MadaUnofficialPlugin) : MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "purchase" -> {
                val data = "${call.arguments}"
                if (!data.startsWith("{")) {
                    result.success(
                        JSONObject(
                            mapOf(
                                "success" to false,
                                "message" to "inalid data"
                            )
                        ).toString()
                    )
                }
                doPurchase(data, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun doPurchase(data: String, result: MethodChannel.Result) {
        val map = mutableMapOf<String, Any?>("success" to true, "message" to "terjadi kesalahan")
        if (plugin.activity == null) {
            map["message"] = "activity not found"
            result.success(JSONObject(map).toString())
            return
        }
        try {
            val json = JSONObject(data)
            val ecrNumber = json.getString("ecr_number")
            val terminalId = json.getString("terminal_id")
            val combined = "${ecrNumber.padEnd(8, '0')}${terminalId.padStart(6, '0')}"
            val signature = computeSha256Hash(combined)
            val amount = json.getDouble("amount")
            val amountInt = (amount * 100).toInt()
            val date = SimpleDateFormat(
                "ddMMyyHHmmss",
                Locale.getDefault()
            ).format(System.currentTimeMillis())
            val command = "$date;$amountInt;0;$combined!"
            val packData = CLibraryLoad.getInstance().getPackData(command, 0, signature)
            System.out.println("Command: $command")
            System.out.println("Pack Data: $packData")
            val intent: Intent? =
                plugin.activity!!.packageManager.getLaunchIntentForPackage("com.skyband.pos.app")
            intent?.let {
                intent.putExtra("message", "ecr-txn-event")
                intent.putExtra("request", packData)
                intent.putExtra("packageName", plugin.activity!!.packageName)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                plugin.activity!!.startActivity(intent)
                map["message"] = "command sent successfully"
                result.success(JSONObject(map).toString())
            } ?: run {
                throw Exception("target com.skyband.pos.app not found")
            }
        } catch (e: Exception) {
            e.printStackTrace()
            map["message"] = e.message
            plugin.channel.invokeMethod(
                "mada_response", JSONObject(map).toString()
            )
            result.success(JSONObject(map).toString())
        }
    }

    private fun computeSha256Hash(combinedValue: String): String {
        // Last Six digit of ecr reference number + terminal id == combined value

        val md = MessageDigest.getInstance("SHA-256")
        val hashInBytes = md.digest(combinedValue.toByteArray())

        val sb = StringBuilder()

        for (b in hashInBytes) {
            sb.append(String.format("%02x", b))
        }

        val resultSHA = sb.toString()

        return resultSHA
    }
}