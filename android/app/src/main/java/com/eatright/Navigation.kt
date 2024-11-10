package com.eatright

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.eatright.composables.AccountSettings
import com.eatright.composables.Favorites
import com.eatright.composables.Home
import com.eatright.composables.HomeViewModel
import com.eatright.composables.Login
import com.eatright.composables.LoginViewModel
import com.eatright.composables.MyMeals
import com.eatright.composables.Profile
import com.eatright.composables.Startup
import kotlinx.coroutines.delay

sealed class Screen(val route: String) {
    object Startup : Screen("startup_screen")
    object Login : Screen("login_screen")
    object Home : Screen("home_screen")
    object Favorites : Screen("favorites_screen")
    object MyMeals : Screen("my_meals_screen")
    object Profile : Screen("profile_screen")
    object AccountSettings : Screen("account_settings_screen")
}

@Composable
fun Navigation(innerPadding: PaddingValues) {
    // Use ViewModels to persist the state.  A goal for the app is to survive configuration
    // (i.e., rotation) and navigation (see Navigation.kt) changes. Among the various docs on state
    // handling, I found https://developer.android.com/topic/libraries/architecture/saving-states
    // to be the most enlightening. There are many options and the answer is "it depends".
    // Practically speaking, this means e.g. the slider values of the Home screen are maintained when
    // the phone is rotated, or when you go to a different nav destination (e.g. Profile) and return.
    val homeViewModel: HomeViewModel = viewModel()
    val loginViewModel: LoginViewModel = viewModel()

    // Navigation approach is based on https://youtu.be/4gUeyNkGE3g.
    val navController = rememberNavController()
    NavHost(navController = navController, startDestination = Screen.Startup.route) {
        composable(route = Screen.Startup.route) {
            Startup(
                modifier = Modifier.padding(innerPadding)
            )
            LaunchedEffect(key1 = true) {
                delay(3000)
                navController.navigate(Screen.Login.route)
            }
        }
        composable(route = Screen.Login.route) {
            // Avoid passing through the (rich) navController, to reduce Login's context.
            Login({ navController.navigate(Screen.Home.route) }, viewModel = loginViewModel)
        }
        composable(route = Screen.Home.route) {
            NavBar(navController) { innerPadding, modifier ->
                Home(modifier, innerPadding, homeViewModel)
            }
        }
        composable(route = Screen.Favorites.route) {
            NavBar(navController) { innerPadding, modifier ->
                Favorites(modifier, innerPadding)
            }
        }
        composable(route = Screen.MyMeals.route) {
            NavBar(navController) { innerPadding, modifier ->
                MyMeals(modifier, innerPadding)
            }
        }
        // Profile screens are rich enough navigation wise to justify passing through the
        // navController, rather than a callback.  This is subjective and fine to revisited.
        composable(route = Screen.Profile.route) {
            Profile(navController=navController)
        }
        composable(route = Screen.AccountSettings.route) {
            AccountSettings(navController)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NavBar(
    navController: NavController,
    modifier: Modifier = Modifier,
    content: @Composable (PaddingValues, Modifier) -> Unit
) {
    val currentRoute = navController.currentDestination?.route
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Image(
                        painter = painterResource(id = R.drawable.eatright_logo),
                        contentDescription = stringResource(id = R.string.eatright_logo_desc),
                        modifier
                            .width(150.dp)
                    )
                },
                actions = {
                    for ((route, icon) in listOf(
                        Screen.Home.route to Icons.Filled.Home,
                        Screen.Favorites.route to Icons.Filled.Star,
                        Screen.MyMeals.route to Icons.Filled.DateRange,
                        Screen.Profile.route to Icons.Filled.Person,
                    )) {
                        IconButton(
                            onClick = { navController.navigate(route) },
                        ) {
                            Icon(
                                icon,
                                contentDescription =null,
                                modifier = Modifier.size(36.dp),
                                tint = when {
                                    currentRoute == route -> MaterialTheme.colorScheme.primary
                                    else -> Color.Gray
                                }
                            )
                        }
                    }
                }
            )
        },
        content = { innerPadding ->
            content(innerPadding, modifier)
        }
    )
}
