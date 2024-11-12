package com.eatright.composables

import android.util.Log
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.ArrowForward
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.navigation.NavController
import com.caverock.androidsvg.SVG
import com.caverock.androidsvg.SVGImageView
import com.eatright.R
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.engine.cio.CIO
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.plugins.logging.Logging
import io.ktor.client.request.get
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.contentType
import io.ktor.serialization.kotlinx.json.json
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class RecipeDetails(
    @SerialName("instructions_info")
    val instructionsInfo: List<InstructionInfo>,
    @SerialName("nutrition_info")
    val nutritionInfo: List<NutritionInfo>,
    @SerialName("price_info")
    val priceInfo: List<PriceInfo>,
    @SerialName("taste_info")
    val tasteInfo: List<TasteInfo>
)

@Serializable
data class InstructionInfo(
    @SerialName("Instruction")
    val instruction: String,
    @SerialName("Step")
    val step: Int
)

@Serializable
data class NutritionInfo(
    val amount: Double,
    val name: String,
    val percentOfDailyNeeds: Double,
    val unit: String
)

@Serializable
data class PriceInfo(
    @SerialName("Amount")
    val amount: Double,
    @SerialName("Name")
    val name: String,
    @SerialName("Price")
    val price: Double
)

@Serializable
data class TasteInfo(
    @SerialName("Taste Metric")
    val tasteMetric: String,
    @SerialName("Value")
    val value: Double
)

@Serializable
data class TasteChartRequest(
    @SerialName("taste_info")
    val tasteInfo: List<TasteInfo>
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MealDetail(
    recipeId: Int,
    recipeTitle: String,
    modifier: Modifier = Modifier,
    innerPadding: PaddingValues = PaddingValues(0.dp),
    navController: NavController? = null,
) {
    var recipeDetails by remember { mutableStateOf<RecipeDetails?>(null) }
    var tasteChart by remember { mutableStateOf("") }

    val client = remember {
        HttpClient(CIO) {
            expectSuccess = true
            install(Logging)
            install(ContentNegotiation) {
                json(
                    kotlinx.serialization.json.Json {
                        ignoreUnknownKeys = true
                    })
            }
        }
    }
    LaunchedEffect(key1 = true) {
        val eatRightBackendAddress = "10.0.2.2:3000"
        recipeDetails =
            client.get("http://${eatRightBackendAddress}/recipe/${recipeId}").body()
        val tasteInfo = recipeDetails?.tasteInfo
        if (tasteInfo != null) {
            val filteredTasteInfo = tasteInfo.filter { tasteInfo ->
                tasteInfo.tasteMetric.lowercase() != "spiciness"
            }
            tasteChart =
                client.post("http://${eatRightBackendAddress}/taste_chart") {
                    contentType(ContentType.Application.Json)
                    setBody(TasteChartRequest(filteredTasteInfo))
                }.body()
            Log.i(null, "svg: ${tasteChart}")
        }
    }

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
            LazyColumn(
                modifier = Modifier
                    .padding(innerPadding)
                    .fillMaxSize(),
                verticalArrangement = Arrangement.Top,
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                item {
                    Text(
                        recipeTitle,
                        textAlign = TextAlign.Center,
                        style = typography.titleLarge,
                    )
                }
                val details =
                    recipeDetails // Local copy without a custom getter to benefit from smart cast.
                if (details == null) {
                    item {
                        CircularProgressIndicator(
                            strokeWidth = 8.dp,
                        )
                    }
                } else {
                    val spiciness =
                        details.tasteInfo.find { it.tasteMetric.lowercase() == "spiciness" }?.value
                    spiciness?.let {
                        if (it > 500) {
                            item {
                                Image(
                                    painter = painterResource(id = R.drawable.redpepper),
                                    contentDescription = stringResource(id = R.string.redpepper_desc),
                                    Modifier
                                        .width(50.dp)
                                        .height(50.dp),
                                )
                            }
                        }
                    }
                    item {
                        DisclosureGroup("Instructions") {
                            val sortedInstructions =
                                details.instructionsInfo.sortedBy { it.step }
                            for (instructionInfo in sortedInstructions) {
                                Row(
                                    verticalAlignment = Alignment.Top,
                                ) {
                                    Text(
                                        text = "${instructionInfo.step}",
                                        modifier = Modifier.padding(end = 8.dp)
                                    )
                                    Text(
                                        text = instructionInfo.instruction,
                                    )
                                }
                                Spacer(modifier = Modifier.height(28.dp))
                            }
                        }
                    }
                    item {
                        DisclosureGroup("Nutrition") {
                            val sortedNutritionInfo = details.nutritionInfo.sortedBy { it.name }
                            for (nutritionInfo in sortedNutritionInfo) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Text(
                                        text = "•",
                                        modifier = Modifier.padding(end = 8.dp)
                                    )
                                    Text(
                                        text = "${nutritionInfo.name}: ${nutritionInfo.amount} ${nutritionInfo.unit}",
                                    )
                                }
                            }
                        }
                    }
                    item {
                        DisclosureGroup("Price Info") {
                            val sortedPriceInfo = details.priceInfo.sortedBy { -it.price }
                            for (priceInfo in sortedPriceInfo) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Text(
                                        text = "•",
                                        modifier = Modifier.padding(end = 8.dp)
                                    )
                                    Text(
                                        text = "${priceInfo.amount} ${priceInfo.name} - $${priceInfo.price}",
                                    )
                                }
                            }
                        }
                    }
                    item {
                        if (tasteChart.isNotEmpty()) {
                            Svg(
                                svg = SVG.getFromString(tasteChart),
                                modifier = Modifier
                                    .height(300.dp)
                                    .fillMaxSize()
                            )
                        }
                    }
                }
            }
        })
}

// Named after the corresponding swiftui standard component.
@Composable
fun DisclosureGroup(
    text: String,
    modifier: Modifier = Modifier,
    content: @Composable () -> Unit,
) {
    var expanded by remember { mutableStateOf(false) }

    OutlinedCard(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier
                    .clickable { expanded = !expanded },
            ) {
                Text(
                    text = text,
                    style = typography.titleMedium,
                    textAlign = TextAlign.Center,
                )
                Spacer(Modifier.weight(1f))
                Icon(
                    imageVector = if (expanded) Icons.Filled.ArrowDropDown else Icons.Filled.ArrowForward,
                    contentDescription = if (expanded) "Show less" else "Show more"
                )
            }
            if (expanded) {
                content()
            }
        }
    }
}

// From https://github.com/stefanhaustein/blog/blob/main/Compose/AndroidSvg.md
// Note that the lighter-weight canvas based solution wasn't picked b/c it doesn't honor
// the bounds of the composable it seems, at least not out of the box.
@Composable
fun Svg(svg: SVG, modifier: Modifier = Modifier) {
    AndroidView(
        factory = { context ->
            SVGImageView(context)
        },
        modifier = modifier,
        update = { svgImageView ->
            svgImageView.setSVG(svg)
        }
    )
}