package com.timecapsule.app.presentation

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import androidx.core.content.ContextCompat
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.compose.rememberNavController
import com.timecapsule.app.data.local.database.TimeCapsuleDatabase
import com.timecapsule.app.data.repository.TimeCapsuleRepositoryImpl
import com.timecapsule.app.presentation.ui.navigation.TimeCapsuleNavGraph
import com.timecapsule.app.presentation.ui.theme.TimeCapsuleTheme
import com.timecapsule.app.presentation.viewmodel.TimeCapsuleViewModel
import com.timecapsule.app.util.NotificationScheduler

class MainActivity : ComponentActivity() {

    private lateinit var viewModel: TimeCapsuleViewModel

    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted: Boolean ->
        if (isGranted) {
            scheduleNotifications()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val database = TimeCapsuleDatabase.getDatabase(applicationContext)
        val repository = TimeCapsuleRepositoryImpl(database.timeCapsuleDao())

        viewModel = ViewModelProvider(
            this,
            TimeCapsuleViewModel.Factory(repository)
        )[TimeCapsuleViewModel::class.java]

        checkNotificationPermission()
        scheduleNotifications()

        setContent {
            TimeCapsuleTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val navController = rememberNavController()
                    TimeCapsuleNavGraph(
                        navController = navController,
                        viewModel = viewModel
                    )
                }
            }
        }
    }

    private fun checkNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            when {
                ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) == PackageManager.PERMISSION_GRANTED -> {
                    // Permission already granted
                }
                else -> {
                    requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                }
            }
        }
    }

    private fun scheduleNotifications() {
        NotificationScheduler.schedulePeriodicNotification(this)
    }
}
