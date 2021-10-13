package com.usercentrics.sdk.flutter.bridge

import com.usercentrics.sdk.UsercentricsSDK
import com.usercentrics.sdk.flutter.api.FakeFlutterMethodCall
import com.usercentrics.sdk.flutter.api.FakeFlutterResult
import com.usercentrics.sdk.flutter.api.FakeUsercentricsProxy
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.Assert
import org.junit.Test

class GetTCStringBridgeTest {

    companion object {
        private const val mockGetTCString = "AAAAAAAAAAAAAAA"

        // Data from a real call of the debugger
        private val mockCall = FakeFlutterMethodCall(method = "getTCString", arguments = null)
        private const val expectedResultPayload = "AAAAAAAAAAAAAAA"
    }

    @Test
    fun testName() {
        val instance = GetTCStringBridge(FakeUsercentricsProxy())
        Assert.assertEquals("getTCString", instance.name)
    }

    @Test
    fun testInvokeWithOtherName() {
        val instance = GetTCStringBridge(FakeUsercentricsProxy())
        val call = FakeFlutterMethodCall(method = "otherName", arguments = null)

        Assert.assertThrows(AssertionError::class.java) {
            instance.invoke(call, FakeFlutterResult())
        }
    }

    @Test
    fun testInvoke() {
        val usercentricsSDK = mockk<UsercentricsSDK>()
        every { usercentricsSDK.getTCString() }.returns(mockGetTCString)
        val usercentricsProxy = FakeUsercentricsProxy(usercentricsSDK)
        val instance = GetTCStringBridge(usercentricsProxy)
        val result = FakeFlutterResult()

        instance.invoke(mockCall, result)

        verify(exactly = 1) { usercentricsSDK.getTCString() }

        Assert.assertEquals(1, result.successCount)
        Assert.assertEquals(expectedResultPayload, result.successResultArgument)
    }

}