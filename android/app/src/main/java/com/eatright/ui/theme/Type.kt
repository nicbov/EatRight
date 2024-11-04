package com.eatright.ui.theme

import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

// You can't add your own type scale entries in Typography. Use a Kotlin extension function
// to make it easier to consistently style particular situations.
fun TextStyle.clickable(): TextStyle = copy(color = Color.Blue)

fun createTypography(colorScheme: ColorScheme): Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    ),
    titleLarge = TextStyle(
        fontFamily = FontFamily.Serif,
        fontWeight = FontWeight.Bold,
        fontSize = 36.sp,
        color = colorScheme.secondary,
        lineHeight = 28.sp,
        letterSpacing = 0.sp
    ),
)
