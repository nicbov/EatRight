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
import androidx.compose.material.icons.outlined.Info
import androidx.compose.material.icons.outlined.Lock
import androidx.compose.material.icons.outlined.Person
import androidx.compose.material.icons.outlined.Place
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
import com.eatright.ui.theme.EatRightTheme

@OptIn(ExperimentalMaterial3Api::class) // For TopAppBar
@Composable
fun AccountSettings(
    navController: NavController? = null,
    modifier: Modifier = Modifier,
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Image(
                        painter = painterResource(id = R.drawable.eatright_logo),
                        contentDescription = stringResource(id = R.string.eatright_logo_desc),
                        modifier.width(150.dp)
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
                modifier = modifier
                    .padding(innerPadding)
                    .fillMaxSize(),
                verticalArrangement = Arrangement.Top,
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Text(
                    text = "Account Settings",
                    style = typography.titleLarge,
                    textAlign = TextAlign.Center,
                )
                LazyColumn {
                    item {
                        ProfileCard(
                            text = "Change Email And Password",
                            icon = Icons.Outlined.Lock,
                        )
                    }
                    item {
                        ProfileCard(
                            text = "Profile Information",
                            icon = Icons.Outlined.Person,
                        )
                    }
                    item {
                        ProfileCard(
                            text = "Language Preferences",
                            icon = Icons.Outlined.Place,
                        )
                    }
                    item {
                        ProfileCard(
                            text = "Manage Subscriptions",
                            icon = Icons.Outlined.ShoppingCart,
                        )
                    }
                    item {
                        ProfileCard(
                            text = "Data Privacy",
                            icon = Icons.Outlined.Info,
                        )
                    }
                }
            }
        },
        modifier = modifier)
}

@Preview(showBackground = true)
@Composable
fun AccountSettingsPreview() {
    EatRightTheme {
        AccountSettings()
    }
}
