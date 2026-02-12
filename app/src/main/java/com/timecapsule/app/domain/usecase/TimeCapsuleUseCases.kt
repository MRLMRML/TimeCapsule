package com.timecapsule.app.domain.usecase

import com.timecapsule.app.domain.model.TimeCapsule
import com.timecapsule.app.domain.repository.TimeCapsuleRepository
import kotlinx.coroutines.flow.Flow

/**
 * Use case for getting all time capsules.
 */
class GetAllCapsulesUseCase(
    private val repository: TimeCapsuleRepository
) {
    operator fun invoke(): Flow<List<TimeCapsule>> {
        return repository.getAllCapsules()
    }
}

/**
 * Use case for getting a single capsule by ID.
 */
class GetCapsuleByIdUseCase(
    private val repository: TimeCapsuleRepository
) {
    suspend operator fun invoke(id: Long): TimeCapsule? {
        return repository.getCapsuleById(id)
    }
}

/**
 * Use case for creating a new time capsule.
 */
class CreateCapsuleUseCase(
    private val repository: TimeCapsuleRepository
) {
    suspend operator fun invoke(message: String, unlockTime: java.time.LocalDateTime): Long {
        val capsule = TimeCapsule(
            message = message,
            unlockTime = unlockTime
        )
        return repository.createCapsule(capsule)
    }
}

/**
 * Use case for deleting a time capsule.
 */
class DeleteCapsuleUseCase(
    private val repository: TimeCapsuleRepository
) {
    suspend operator fun invoke(id: Long) {
        repository.deleteCapsule(id)
    }
}

/**
 * Use case for opening a time capsule.
 */
class OpenCapsuleUseCase(
    private val repository: TimeCapsuleRepository
) {
    suspend operator fun invoke(id: Long): TimeCapsule? {
        val capsule = repository.getCapsuleById(id)
        if (capsule != null && capsule.isUnlocked && !capsule.isOpened) {
            repository.markAsOpened(id)
        }
        return capsule
    }
}

/**
 * Use case for getting unlocked but not yet notified capsules.
 */
class GetUnlockedCapsulesUseCase(
    private val repository: TimeCapsuleRepository
) {
    suspend operator fun invoke(): List<TimeCapsule> {
        return repository.getUnlockedButNotNotifiedCapsules()
    }
}
