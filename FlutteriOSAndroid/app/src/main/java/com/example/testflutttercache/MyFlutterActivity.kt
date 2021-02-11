package com.example.testflutttercache


import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.example.testflutttercache.utils.MethodChannelUtil
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.util.Log;
import android.widget.Toast;


class MyFlutterActivity: FlutterActivity() {

    val INIT_PARAMS = "initParams"
    val METHOD_CHANNEL = "methodChannel"


    private var initParams: String? = null

    private var methodChannel: MethodChannel? = null


    fun start(context: Context, initParams: String?) {
        val intent = Intent(context, MyFlutterActivity::class.java)
        intent.putExtra(INIT_PARAMS, initParams)
        context.startActivity(intent)
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannelUtil.addFinishMethodToList {
            finish()
        }
        initParams = intent.getStringExtra(INIT_PARAMS)
        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, METHOD_CHANNEL)
        methodChannel?.invokeMethod("callFlutter", "传值成功，牛逼了烙铁", object : MethodChannel.Result {
            override fun success(result: Any?) {
                Log.i("tag", result.toString())
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
            override fun notImplemented() {}
        })
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return FlutterEngineCache
            .getInstance()
            .get("my_engine_id")

    }

    /**
     * 重载该方法来传递初始化参数
     *
     * @return
     */
    override fun getInitialRoute(): String? {
        return if (initParams == null) super.getInitialRoute() else initParams!!
    }
}