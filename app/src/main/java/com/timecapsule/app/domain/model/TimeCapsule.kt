package com.timecapsule.app.domain.model

import java.time.LocalDateTime

/**
 * Domain model representing a Time Capsule message.
 */
data class TimeCapsule(
    val id: Long = 0,
    val message: String,
    val unlockTime: LocalDateTime,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    val isOpened: Boolean = false,
    val notificationScheduled: Boolean = false
) {
    val isUnlocked: Boolean
        get() = LocalDateTime.now().isAfter(unlockTime)

    val formattedUnlockTime: String
        get() = "${unlockTime.monthValue}/${unlockTime.dayOfMonth}/${unlockTime.year} ${unlockTime.hour}:${unlockTime.minute.toString().padStart(2, '0')}"
}
