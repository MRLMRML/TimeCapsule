package com.timecapsule.app.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.timecapsule.app.domain.model.TimeCapsule
import java.time.LocalDateTime

/**
 * Room entity for storing time capsule data in the database.
 */
@Entity(tableName = "time_capsules")
data class TimeCapsuleEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val message: String,
    val unlockTime: Long, // Stored as epoch millis
    val createdAt: Long, // Stored as epoch millis
    val isOpened: Boolean = false,
    val notificationScheduled: Boolean = false
) {
    fun toDomainModel(): TimeCapsule {
        return TimeCapsule(
            id = id,
            message = message,
            unlockTime = LocalDateTime.ofEpochSecond(unlockTime / 1000, 0, java.time.ZoneOffset.UTC),
            createdAt = LocalDateTime.ofEpochSecond(createdAt / 1000, 0, java.time.ZoneOffset.UTC),
            isOpened = isOpened,
            notificationScheduled = notificationScheduled
        )
    }

    companion object {
        fun fromDomainModel(timeCapsule: TimeCapsule): TimeCapsuleEntity {
            return TimeCapsuleEntity(
                id = timeCapsule.id,
                message = timeCapsule.message,
                unlockTime = timeCapsule.unlockTime.toEpochSecond(java.time.ZoneOffset.UTC) * 1000,
                createdAt = timeCapsule.createdAt.toEpochSecond(java.time.ZoneOffset.UTC) * 1000,
                isOpened = timeCapsule.isOpened,
                notificationScheduled = timeCapsule.notificationScheduled
            )
        }
    }
}
