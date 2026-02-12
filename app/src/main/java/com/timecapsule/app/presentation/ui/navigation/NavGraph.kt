package com.timecapsule.app.presentation.ui.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import com.timecapsule.app.presentation.ui.screens.CapsuleDetailScreen
import com.timecapsule.app.presentation.ui.screens.CreateCapsuleScreen
import com.timecapsule.app.presentation.ui.screens.HomeScreen
import com.timecapsule.app.presentation.viewmodel.TimeCapsuleViewModel

@Composable
fun TimeCapsuleNavGraph(
    navController: NavHostController,
    viewModel: TimeCapsuleViewModel
) {
    NavHost(
        navController = navController,
        startDestination = Screen.Home.route
    ) {
        composable(Screen.Home.route) {
            HomeScreen(
                viewModel = viewModel,
                onNavigateToCreate = {
                    navController.navigate(Screen.CreateCapsule.route)
                },
                onNavigateToDetail = { capsuleId ->
                    navController.navigate(Screen.CapsuleDetail.createRoute(capsuleId))
                }
            )
        }

        composable(Screen.CreateCapsule.route) {
            CreateCapsuleScreen(
                viewModel = viewModel,
                onNavigateBack = {
                    navController.popBackStack()
                }
            )
        }

        composable(
            route = Screen.CapsuleDetail.route,
            arguments = listOf(
                navArgument("capsuleId") { type = NavType.LongType }
            )
        ) { backStackEntry ->
            val capsuleId = backStackEntry.arguments?.getLong("capsuleId") ?: -1L
            CapsuleDetailScreen(
                capsuleId = capsuleId,
                viewModel = viewModel,
                onNavigateBack = {
                    navController.popBackStack()
                }
            )
        }
    }
}
