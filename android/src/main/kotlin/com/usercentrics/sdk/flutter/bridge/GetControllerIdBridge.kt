package com.usercentrics.sdk.flutter.bridge

import com.usercentrics.sdk.flutter.api.FlutterMethodCall
import com.usercentrics.sdk.flutter.api.FlutterResult
import com.usercentrics.sdk.flutter.api.UsercentricsProxy
import com.usercentrics.sdk.flutter.api.UsercentricsProxySingleton

internal class GetControllerIdBridge(
    private val usercentrics: UsercentricsProxy = UsercentricsProxySingleton
) : MethodBridge {

    override val name: String
        get() = "getControllerId"

    override fun invoke(call: FlutterMethodCall, result: FlutterResult) {
        assert(name == call.method)
        result.success(usercentrics.instance.getControllerId())
    }

}