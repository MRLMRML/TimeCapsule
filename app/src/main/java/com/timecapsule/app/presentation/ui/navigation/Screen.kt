package com.timecapsule.app.presentation.ui.navigation

/**
 * Navigation routes for the app.
 */
sealed class Screen(val route: String) {
    data object Home : Screen("home")
    data object CreateCapsule : Screen("create_capsule")
    data object CapsuleDetail : Screen("capsule_detail/{capsuleId}") {
        fun createRoute(capsuleId: Long) = "capsule_detail/$capsuleId"
    }
}
