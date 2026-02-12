package com.timecapsule.app.data.local.database

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.timecapsule.app.data.local.dao.TimeCapsuleDao
import com.timecapsule.app.data.local.entity.TimeCapsuleEntity

/**
 * Room database for the Time Capsule app.
 */
@Database(
    entities = [TimeCapsuleEntity::class],
    version = 1,
    exportSchema = false
)
abstract class TimeCapsuleDatabase : RoomDatabase() {

    abstract fun timeCapsuleDao(): TimeCapsuleDao

    companion object {
        @Volatile
        private var INSTANCE: TimeCapsuleDatabase? = null

        fun getDatabase(context: Context): TimeCapsuleDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    TimeCapsuleDatabase::class.java,
                    "time_capsule_database"
                )
                    .fallbackToDestructiveMigration()
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
