package com.timecapsule.app.worker

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * BroadcastReceiver for notification actions.
 */
class NotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_OPEN_CAPSULE) {
            val capsuleId = intent.getLongExtra(EXTRA_CAPSULE_ID, -1)
            if (capsuleId != -1L) {
                openCapsule(context, capsuleId)
            }
        }
    }

    private fun openCapsule(context: Context, capsuleId: Long) {
        val intent = Intent(context, Class.forName("com.timecapsule.app.presentation.MainActivity")).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(NotificationWorker.EXTRA_CAPSULE_ID, capsuleId)
        }
        context.startActivity(intent)
    }

    companion object {
        const val ACTION_OPEN_CAPSULE = "com.timecapsule.app.ACTION_OPEN_CAPSULE"
        const val EXTRA_CAPSULE_ID = "capsule_id"
    }
}
