package com.timecapsule.app.data.local.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import com.timecapsule.app.data.local.entity.TimeCapsuleEntity
import kotlinx.coroutines.flow.Flow

/**
 * Data Access Object for Time Capsule database operations.
 */
@Dao
interface TimeCapsuleDao {

    @Query("SELECT * FROM time_capsules ORDER BY createdAt DESC")
    fun getAllCapsules(): Flow<List<TimeCapsuleEntity>>

    @Query("SELECT * FROM time_capsules WHERE id = :id")
    suspend fun getCapsuleById(id: Long): TimeCapsuleEntity?

    @Query("SELECT * FROM time_capsules WHERE isOpened = 0 AND unlockTime <= :currentTime AND notificationScheduled = 0")
    suspend fun getUnlockedButNotNotifiedCapsules(currentTime: Long): List<TimeCapsuleEntity>

    @Query("SELECT * FROM time_capsules WHERE isOpened = 0")
    suspend fun getUnopenedCapsules(): List<TimeCapsuleEntity>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCapsule(capsule: TimeCapsuleEntity): Long

    @Update
    suspend fun updateCapsule(capsule: TimeCapsuleEntity)

    @Delete
    suspend fun deleteCapsule(capsule: TimeCapsuleEntity)

    @Query("DELETE FROM time_capsules WHERE id = :id")
    suspend fun deleteCapsuleById(id: Long)

    @Query("UPDATE time_capsules SET isOpened = 1 WHERE id = :id")
    suspend fun markAsOpened(id: Long)

    @Query("UPDATE time_capsules SET notificationScheduled = 1 WHERE id = :id")
    suspend fun markNotificationScheduled(id: Long)

    @Query("UPDATE time_capsules SET notificationScheduled = :scheduled WHERE id = :id")
    suspend fun updateNotificationScheduled(id: Long, scheduled: Boolean)
}
