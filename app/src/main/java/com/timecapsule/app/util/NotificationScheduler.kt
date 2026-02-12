package com.timecapsule.app.util

import android.content.Context
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import com.timecapsule.app.worker.NotificationWorker
import java.util.concurrent.TimeUnit

/**
 * Utility class for scheduling notification work.
 */
object NotificationScheduler {

    fun schedulePeriodicNotification(context: Context) {
        val workRequest = PeriodicWorkRequestBuilder<NotificationWorker>(
            repeatInterval = 15,
            repeatIntervalTimeUnit = TimeUnit.MINUTES
        ).build()

        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            NotificationWorker.WORK_NAME,
            ExistingPeriodicWorkPolicy.KEEP,
            workRequest
        )
    }

    fun cancelScheduledNotification(context: Context) {
        WorkManager.getInstance(context).cancelUniqueWork(NotificationWorker.WORK_NAME)
    }
}
