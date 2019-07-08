package com.plastic.gitdevopsdemo

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
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
            application, "6bd172da-7001-4dca-b5bf-93c0ed435e8c",
            Analytics::class.java, Crashes::class.java
        )


        AppCenter.setLogLevel(Log.VERBOSE)
//        val intent = Intent(this, TempActivity::class.java)
//        startActivity(intent)
    }
}
