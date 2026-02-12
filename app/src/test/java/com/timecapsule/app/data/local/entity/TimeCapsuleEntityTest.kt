package com.timecapsule.app.data.local.entity

import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDateTime
import java.time.ZoneOffset

/**
 * Unit tests for TimeCapsuleEntity.
 */
class TimeCapsuleEntityTest {

    @Test
    fun `toDomainModel converts entity to domain model correctly`() {
        val unlockTime = LocalDateTime.of(2025, 6, 15, 14, 30)
        val createdAt = LocalDateTime.of(2025, 6, 1, 10, 0)

        val entity = TimeCapsuleEntity(
            id = 1,
            message = "Test message",
            unlockTime = unlockTime.toEpochSecond(ZoneOffset.UTC) * 1000,
            createdAt = createdAt.toEpochSecond(ZoneOffset.UTC) * 1000,
            isOpened = false,
            notificationScheduled = true
        )

        val domainModel = entity.toDomainModel()

        assertEquals(1L, domainModel.id)
        assertEquals("Test message", domainModel.message)
        assertEquals(unlockTime, domainModel.unlockTime)
        assertEquals(createdAt, domainModel.createdAt)
        assertEquals(false, domainModel.isOpened)
        assertEquals(true, domainModel.notificationScheduled)
    }

    @Test
    fun `fromDomainModel converts domain model to entity correctly`() {
        val unlockTime = LocalDateTime.of(2025, 6, 15, 14, 30)
        val createdAt = LocalDateTime.of(2025, 6, 1, 10, 0)

        val domainModel = com.timecapsule.app.domain.model.TimeCapsule(
            id = 1,
            message = "Test message",
            unlockTime = unlockTime,
            createdAt = createdAt,
            isOpened = true,
            notificationScheduled = false
        )

        val entity = TimeCapsuleEntity.fromDomainModel(domainModel)

        assertEquals(1L, entity.id)
        assertEquals("Test message", entity.message)
        assertEquals(unlockTime.toEpochSecond(ZoneOffset.UTC) * 1000, entity.unlockTime)
        assertEquals(createdAt.toEpochSecond(ZoneOffset.UTC) * 1000, entity.createdAt)
        assertEquals(true, entity.isOpened)
        assertEquals(false, entity.notificationScheduled)
    }

    @Test
    fun `round trip conversion preserves all data`() {
        val original = com.timecapsule.app.domain.model.TimeCapsule(
            id = 42,
            message = "Hello from the past!",
            unlockTime = LocalDateTime.now().plusDays(7),
            createdAt = LocalDateTime.now(),
            isOpened = false,
            notificationScheduled = true
        )

        val entity = TimeCapsuleEntity.fromDomainModel(original)
        val converted = entity.toDomainModel()

        assertEquals(original, converted)
    }
}
