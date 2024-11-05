package com.eatright.composables

import android.util.Log
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.eatright.R
import com.eatright.ui.theme.EatRightTheme
import com.eatright.ui.theme.clickable
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch


class LoginViewModel : androidx.lifecycle.ViewModel() {
    var username by mutableStateOf("")
    var password by mutableStateOf("")
}

@Composable
fun Login(
    onSuccessfulAuthentication: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: LoginViewModel = viewModel(),
) {
    var isLoading by remember { mutableStateOf(false) }
    var showAlert by remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()

    LazyColumn(
        modifier = modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceEvenly,
    ) {
        item {
            // TODO(seb): Style image per IOS implementation.
            Image(
                painter = painterResource(id = R.drawable.eatright_logo),
                contentDescription = stringResource(id = R.string.eatright_logo_desc),
                Modifier
                    .width(250.dp)
                    .height(250.dp),
            )
        }
        item {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(10.dp),
                modifier = Modifier.fillMaxWidth(0.75f),
            ) {
                Text(
                    text = "Sign In",
                    style = typography.titleLarge,
                )
                OutlinedTextField(
                    value = viewModel.username,
                    onValueChange = { viewModel.username = it },
                    label = { Text("Username") },
                    modifier = Modifier.fillMaxWidth(0.9f),
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(
                        keyboardType = KeyboardType.Text,
                        imeAction = ImeAction.Next,
                    )
                )
                OutlinedTextField(
                    value = viewModel.password,
                    onValueChange = { viewModel.password = it },
                    label = { Text("Password") },
                    modifier = Modifier.fillMaxWidth(0.9f),
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(
                        keyboardType = KeyboardType.Password,
                        imeAction = ImeAction.Done,
                    ),
                    visualTransformation = PasswordVisualTransformation()
                )
                Button(
                    onClick = {
                        isLoading = true

                        scope.launch {
                            delay(2000); // fake delay representing evt. network delay
                            isLoading = false
                            if (viewModel.username.lowercase() == "test" && viewModel.password.lowercase() == "password") {
                                Log.i(null, "Successful (fake) login!")
                                onSuccessfulAuthentication()
                            } else {
                                showAlert = true
                            }
                        }
                    },
                    modifier = Modifier.fillMaxWidth().height(64.dp),
                    enabled = viewModel.username.isNotEmpty() && viewModel.password.isNotEmpty() && !isLoading,
                ) {
                    if (isLoading) {
                        CircularProgressIndicator(
                            color = MaterialTheme.colorScheme.onPrimary,
                            strokeWidth = 8.dp,
                        )
                    } else {
                        Text("Login")
                    }
                }
            }
        }
        item {
            Row(modifier = Modifier.padding(10.dp)) {
                Text(
                    text = "Forgot Password?",
                    style = typography.bodyLarge.clickable(),
                    modifier = Modifier
                        .clickable {
                            Log.i(null, "'Forgot Password' tapped")
                        }
                )
                Spacer(Modifier.fillMaxWidth(0.5f))
                Text(
                    text = "Create Account",
                    style = typography.bodyLarge.clickable(),
                    modifier = Modifier
                        .clickable {
                            Log.i(null, "'Create Account' tapped")
                        })
            }
        }
    }
    // NB: Not in LazyColumn as we unconditionally want to display the alert.
    // Otherwise it has been observed to only display upon scrolling to the bottom.
    if (showAlert) {
        viewModel.password = ""  // Corrections of hidden fields are atypical.
        AlertDialog(
            onDismissRequest = { showAlert = false },
            title = { Text("Login Error") },
            text = { Text("Incorrect username or password.") },
            confirmButton = {
                Button(onClick = { showAlert = false }) {
                    Text("OK")
                }
            }
        )
    }
}

@Preview(showBackground = true)
@Composable
fun LoginPreview() {
    EatRightTheme {
        Login({
            println("Preview: Successfully logged in!")
        })
    }
}