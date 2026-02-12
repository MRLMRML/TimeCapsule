package com.timecapsule.app.domain.repository

import com.timecapsule.app.domain.model.TimeCapsule
import kotlinx.coroutines.flow.Flow

/**
 * Repository interface for Time Capsule operations.
 */
interface TimeCapsuleRepository {

    fun getAllCapsules(): Flow<List<TimeCapsule>>

    suspend fun getCapsuleById(id: Long): TimeCapsule?

    suspend fun getUnopenedCapsules(): List<TimeCapsule>

    suspend fun getUnlockedButNotNotifiedCapsules(): List<TimeCapsule>

    suspend fun createCapsule(timeCapsule: TimeCapsule): Long

    suspend fun updateCapsule(timeCapsule: TimeCapsule)

    suspend fun deleteCapsule(id: Long)

    suspend fun markAsOpened(id: Long)

    suspend fun markNotificationScheduled(id: Long)
}
