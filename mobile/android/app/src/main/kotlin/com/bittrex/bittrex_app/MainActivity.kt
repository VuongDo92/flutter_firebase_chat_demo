package com.bittrex.bittrex_app

import android.content.*
import android.os.Bundle
import android.text.TextUtils

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "ph.com.channel.platform"
    private val APP_PREFERENCE = "app_preference"
    private val CONSUMER_ID = "consumer_id"

    private enum class ChannelMethod {
        GET_DEVICE_UUID
    }

    private var channel: MethodChannel? = null
    private var preferences: SharedPreferences? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        preferences = getSharedPreferences(APP_PREFERENCE, Context.MODE_PRIVATE)
        channel = MethodChannel(flutterView, CHANNEL)

        channel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "GET_DEVICE_UUID" -> result.success(getDeviceUUID())
                else -> result.notImplemented()
            }
        }
    }

    private fun getDeviceUUID(): String {
        if (!preferences?.contains(CONSUMER_ID)!!) {
            val consumerId = UUID.randomUUID().toString()
            val editor = preferences?.edit()
            editor?.putString(CONSUMER_ID, consumerId)
            editor?.apply()
            return consumerId
        } else {
            return preferences?.getString(CONSUMER_ID, UUID.randomUUID().toString())!!
        }
    }
}
