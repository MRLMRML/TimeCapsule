package com.timecapsule.app.worker

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.timecapsule.app.R
import com.timecapsule.app.data.local.database.TimeCapsuleDatabase
import com.timecapsule.app.data.repository.TimeCapsuleRepositoryImpl
import com.timecapsule.app.presentation.MainActivity

/**
 * WorkManager worker that checks for unlocked capsules and shows notifications.
 */
class NotificationWorker(
    private val context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        val database = TimeCapsuleDatabase.getDatabase(context)
        val repository = TimeCapsuleRepositoryImpl(database.timeCapsuleDao())

        val unlockedCapsules = repository.getUnlockedButNotNotifiedCapsules()

        for (capsule in unlockedCapsules) {
            showNotification(
                id = capsule.id.toInt(),
                title = context.getString(R.string.notification_title),
                message = capsule.message
            )
            repository.markNotificationScheduled(capsule.id)
        }

        return Result.success()
    }

    private fun showNotification(id: Int, title: String, message: String) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        createNotificationChannel(notificationManager)

        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra(EXTRA_CAPSULE_ID, id)
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(context.getString(R.string.notification_text))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build()

        notificationManager.notify(id, notification)
    }

    private fun createNotificationChannel(notificationManager: NotificationManager) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                context.getString(R.string.notification_channel_name),
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = context.getString(R.string.notification_channel_description)
                enableVibration(true)
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    companion object {
        const val CHANNEL_ID = "time_capsule_channel"
        const val EXTRA_CAPSULE_ID = "capsule_id"
        const val WORK_NAME = "time_capsule_notification_work"
    }
}
