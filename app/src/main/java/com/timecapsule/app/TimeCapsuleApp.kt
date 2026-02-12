package com.timecapsule.app

import android.app.Application
import com.timecapsule.app.util.NotificationScheduler

class TimeCapsuleApp : Application() {

    override fun onCreate() {
        super.onCreate()
        NotificationScheduler.schedulePeriodicNotification(this)
    }
}
