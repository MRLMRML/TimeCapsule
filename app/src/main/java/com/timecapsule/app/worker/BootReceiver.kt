package com.timecapsule.app.worker

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.timecapsule.app.util.NotificationScheduler

/**
 * BroadcastReceiver to reschedule notifications after device boot.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            NotificationScheduler.schedulePeriodicNotification(context)
        }
    }
}
