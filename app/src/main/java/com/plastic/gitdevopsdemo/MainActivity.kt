package com.plastic.gitdevopsdemo

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

class MainActivity : AppCompatActivity() {

    //trying to resolve app center check
    //trying to reconfigure
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        AppCenter.start(
            application, "aaa8208f-2293-4777-8192-c38fa56f546a",
            Analytics::class.java, Crashes::class.java
        )

    }
}
