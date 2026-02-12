package com.timecapsule.app.data.repository

import com.timecapsule.app.data.local.dao.TimeCapsuleDao
import com.timecapsule.app.data.local.entity.TimeCapsuleEntity
import com.timecapsule.app.domain.model.TimeCapsule
import com.timecapsule.app.domain.repository.TimeCapsuleRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.time.LocalDateTime
import java.time.ZoneOffset

/**
 * Implementation of TimeCapsuleRepository using Room database.
 */
class TimeCapsuleRepositoryImpl(
    private val timeCapsuleDao: TimeCapsuleDao
) : TimeCapsuleRepository {

    override fun getAllCapsules(): Flow<List<TimeCapsule>> {
        return timeCapsuleDao.getAllCapsules().map { entities ->
            entities.map { it.toDomainModel() }
        }
    }

    override suspend fun getCapsuleById(id: Long): TimeCapsule? {
        return timeCapsuleDao.getCapsuleById(id)?.toDomainModel()
    }

    override suspend fun getUnopenedCapsules(): List<TimeCapsule> {
        return timeCapsuleDao.getUnopenedCapsules().map { it.toDomainModel() }
    }

    override suspend fun getUnlockedButNotNotifiedCapsules(): List<TimeCapsule> {
        val currentTime = LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) * 1000
        return timeCapsuleDao.getUnlockedButNotNotifiedCapsules(currentTime).map { it.toDomainModel() }
    }

    override suspend fun createCapsule(timeCapsule: TimeCapsule): Long {
        return timeCapsuleDao.insertCapsule(TimeCapsuleEntity.fromDomainModel(timeCapsule))
    }

    override suspend fun updateCapsule(timeCapsule: TimeCapsule) {
        timeCapsuleDao.updateCapsule(TimeCapsuleEntity.fromDomainModel(timeCapsule))
    }

    override suspend fun deleteCapsule(id: Long) {
        timeCapsuleDao.deleteCapsuleById(id)
    }

    override suspend fun markAsOpened(id: Long) {
        timeCapsuleDao.markAsOpened(id)
    }

    override suspend fun markNotificationScheduled(id: Long) {
        timeCapsuleDao.markNotificationScheduled(id)
    }
}
