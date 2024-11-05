package com.eatright.composables

import android.util.Log
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import com.eatright.ui.theme.EatRightTheme
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.engine.cio.CIO
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.plugins.logging.Logging
import io.ktor.client.request.get
import io.ktor.serialization.kotlinx.json.json
import kotlinx.coroutines.launch
import kotlinx.serialization.Serializable


class HomeViewModel : ViewModel() {
    var filterVisible by mutableStateOf(false)
    var protein by mutableStateOf(100.0f)
    var carbs by mutableStateOf(100.0f)
    var fats by mutableStateOf(100.0f)
}

@Serializable
data class Recipe(val id: Int, val title: String)

@Composable
fun Home(
    modifier: Modifier = Modifier,
    innerPadding: PaddingValues = PaddingValues(0.dp),
    viewModel: HomeViewModel = viewModel(),
) {
    LazyColumn(
        modifier = modifier
            .fillMaxSize()
            .padding(innerPadding)
    ) {
        item {
            RecipeSearchSection()
        }
        item {
            FilterSection(
                isVisible = viewModel.filterVisible,
                viewModel = viewModel,
                onFilterButtonClick = { viewModel.filterVisible = !viewModel.filterVisible },
            )
        }
    }
}

@Composable
private fun RecipeSearchSection() {
    var text by remember {
        mutableStateOf("")
    }
    val scope = rememberCoroutineScope()

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp)
    ) {
        TextField(
            value = text,
            onValueChange = { text = it },
            singleLine = true,
            placeholder = { Text("Search for recipes...") },
            modifier = Modifier.fillMaxWidth()
        )
        Button(
            onClick = {
                Log.i(null, "Search for recipes containing ${text}")

                scope.launch {
                    // TODO(seb): reuse client across requests
                    val client = HttpClient(CIO) {
                        expectSuccess = true
                        install(Logging)
                        install(ContentNegotiation) {
                            json()
                        }
                    }

                    // For development.  This IP is owned by the Android simulator's host, where we
                    // expect to be running the backend.
                    val eatRightBackendAddress = "10.0.2.2:3000"
                    val recipes: List<Recipe> =
                        client.get("http://${eatRightBackendAddress}/search_recipes"){
                            url {
                                parameters.append("dish", text)
                            }
                        }.body()

                    Log.i(null, "Search results: ${recipes.count()} recipes: ${recipes}")
                    client.close()
                }
            },
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 16.dp)
        ) {
            Text("Fetch Recipes")
        }
    }
}

@Composable
private fun FilterSection(
    isVisible: Boolean,
    viewModel: HomeViewModel = viewModel(),
    onFilterButtonClick: () -> Unit,
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        OutlinedButton(
            onClick = onFilterButtonClick,
            border = BorderStroke(
                width = 2.dp,
                color = MaterialTheme.colorScheme.primary,
            ),
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 16.dp)
        ) {
            Text("Filters")
        }

        AnimatedVisibility(
            visible = isVisible,
            enter = fadeIn(),
            exit = fadeOut()
        ) {
            Column {
                FilterSlider(
                    label = "Protein",
                    value = viewModel.protein,
                    onValueChange = { viewModel.protein = it }
                )
                FilterSlider(
                    label = "Carbs",
                    value = viewModel.carbs,
                    onValueChange = { viewModel.carbs = it }
                )
                FilterSlider(
                    label = "Fats",
                    value = viewModel.fats,
                    onValueChange = { viewModel.fats = it }
                )
            }
        }
    }
}

@Composable
private fun FilterSlider(
    label: String,
    value: Float,
    onValueChange: (Float) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth(0.9f)
            .padding(10.dp)
            .border(
                width = 2.dp,
                color = MaterialTheme.colorScheme.primary,
                shape = RoundedCornerShape(16.dp),
            )
            .padding(10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(label)
        Slider(
            value = value,
            onValueChange = onValueChange,
            valueRange = 0f..500f,
            modifier = Modifier.weight(2f)
        )
        Text("${value.toInt()}")
    }
}

@Preview(showBackground = true)
@Composable
fun HomePreview() {
    EatRightTheme {
        Home()
    }
}
