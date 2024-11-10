package com.eatright.composables

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.outlined.Call
import androidx.compose.material.icons.outlined.Info
import androidx.compose.material.icons.outlined.Lock
import androidx.compose.material.icons.outlined.Notifications
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material.icons.outlined.ShoppingCart
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.em
import androidx.navigation.NavController
import com.eatright.R
import com.eatright.Screen
import com.eatright.ui.theme.EatRightTheme

@OptIn(ExperimentalMaterial3Api::class) // for TopAppBar
@Composable
fun Profile(
    modifier: Modifier = Modifier,
    navController: NavController? = null,
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Image(
                        painter = painterResource(id = R.drawable.eatright_logo),
                        contentDescription = stringResource(id = R.string.eatright_logo_desc),
                        Modifier.width(150.dp)
                    )
                },
                navigationIcon = {
                    IconButton(
                        onClick = { navController?.navigateUp() }
                    ) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                        )
                    }
                })
        },
        content = { innerPadding ->
            Column(
                modifier = Modifier
                    .padding(innerPadding)
                    .fillMaxSize(),
                verticalArrangement = Arrangement.Top,
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Text(
                    text = "Profile",
                    style = typography.titleLarge,
                    textAlign = TextAlign.Center,
                )
                Icon(
                    Icons.Filled.AccountCircle,
                    contentDescription = null,
                    modifier = Modifier.size(160.dp),
                    tint = MaterialTheme.colorScheme.secondary,
                )
                LazyColumn {
                    item {
                        ProfileCard(
                            text = "Account Settings",
                            icon = Icons.Outlined.Settings,
                            onClick = { navController?.navigate(Screen.AccountSettings.route) }
                        )
                    }
                    item {
                        ProfileCard(
                            text = "Notifications",
                            icon = Icons.Outlined.Notifications,
                        )
                    }
                    item {
                        ProfileCard(
                            text = "Payment Activity",
                            icon = Icons.Outlined.ShoppingCart,
                        )
                    }
                    item {
                        ProfileCard(
                            text = "Privacy Settings",
                            icon = Icons.Outlined.Lock,
                        )
                    }
                    item {
                        ProfileCard(
                            text = "Help & Support",
                            icon = Icons.Outlined.Call,
                        )
                    }
                    item {
                        ProfileCard(
                            text = "About Us",
                            icon = Icons.Outlined.Info,
                        )
                    }
                }
            }
        },
        modifier = modifier,
    )
}

@Preview(showBackground = true)
@Composable
fun ProfilePreview() {
    EatRightTheme {
        Profile()
    }
}
