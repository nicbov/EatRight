package com.eatright.composables

import android.util.Log
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.eatright.ui.theme.EatRightTheme
import com.eatright.ui.theme.clickable

@Composable
fun MyMeals(
    modifier: Modifier = Modifier,
    innerPadding: PaddingValues = PaddingValues(0.dp),
) {
    LazyVerticalGrid(
        columns = GridCells.Fixed(2),
        contentPadding = innerPadding,
        modifier = modifier,
    ) {
        items((1..20).toList()) {
            Box(
                modifier = Modifier.padding(10.dp),
                contentAlignment = Alignment.Center,
            ) {
                Text(
                    text = "Meal ${it}",
                    style = typography.bodyLarge.clickable(),
                    modifier = Modifier
                        .height(100.dp)
                        .width(100.dp)
                        .border(
                            width = 2.dp,
                            color = MaterialTheme.colorScheme.primary,
                            shape = RoundedCornerShape(8.dp),
                        )
                        .wrapContentSize(Alignment.Center)
                        .clickable {
                            Log.i(null, "'Meal ${it}' clicked")
                        }
                )
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun MyMealsPreview() {
    EatRightTheme {
        MyMeals()
    }
}
