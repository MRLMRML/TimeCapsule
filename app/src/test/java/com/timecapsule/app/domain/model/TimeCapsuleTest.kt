package com.timecapsule.app.domain.model

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.LocalDateTime

/**
 * Unit tests for TimeCapsule domain model.
 */
class TimeCapsuleTest {

    @Test
    fun `isUnlocked returns true when current time is after unlock time`() {
        val capsule = TimeCapsule(
            id = 1,
            message = "Test message",
            unlockTime = LocalDateTime.now().minusHours(1),
            isOpened = false
        )

        assertTrue(capsule.isUnlocked)
    }

    @Test
    fun `isUnlocked returns false when current time is before unlock time`() {
        val capsule = TimeCapsule(
            id = 1,
            message = "Test message",
            unlockTime = LocalDateTime.now().plusHours(1),
            isOpened = false
        )

        assertFalse(capsule.isUnlocked)
    }

    @Test
    fun `formattedUnlockTime returns correct format`() {
        val unlockTime = LocalDateTime.of(2025, 6, 15, 14, 30)
        val capsule = TimeCapsule(
            id = 1,
            message = "Test message",
            unlockTime = unlockTime,
            isOpened = false
        )

        assertEquals("6/15/2025 14:30", capsule.formattedUnlockTime)
    }

    @Test
    fun `formattedUnlockTime pads single digit minutes correctly`() {
        val unlockTime = LocalDateTime.of(2025, 6, 15, 14, 5)
        val capsule = TimeCapsule(
            id = 1,
            message = "Test message",
            unlockTime = unlockTime,
            isOpened = false
        )

        assertEquals("6/15/2025 14:05", capsule.formattedUnlockTime)
    }

    @Test
    fun `default values are set correctly`() {
        val capsule = TimeCapsule(
            message = "Test",
            unlockTime = LocalDateTime.now()
        )

        assertEquals(0L, capsule.id)
        assertFalse(capsule.isOpened)
        assertFalse(capsule.notificationScheduled)
    }
}
