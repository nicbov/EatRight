package com.eatright

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Scaffold
import androidx.compose.ui.Modifier
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onParent
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextInput
import com.eatright.composables.Login
import com.eatright.ui.theme.EatRightTheme
import org.junit.Rule
import org.junit.Test

class SearchRecipeFlowTest {
    @get:Rule
    val rule = createComposeRule()

    @Test
    fun meatballs() {
        rule.setContent {
            EatRightTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Navigation(innerPadding)
                }
            }
        }

        rule.waitUntil(timeoutMillis = 10_000) {
            rule
                .onAllNodesWithText("Username")
                .fetchSemanticsNodes().size == 1
        }

        rule
            .onNodeWithText("Username", useUnmergedTree = true)
            .onParent()
            .performTextInput("test")
        rule
            .onNodeWithText("Password", useUnmergedTree = true)
            .onParent()
            .performTextInput("password")
        rule
            .onNodeWithText("Login")
            .performClick()

        rule
            .waitUntil(timeoutMillis = 10_000) {
                rule
                    .onAllNodesWithText("Search for recipes...")
                    .fetchSemanticsNodes().size == 1
            }
        rule
            .onNodeWithText("Search for recipes...", useUnmergedTree = true)
            .onParent()
            .performTextInput("meatballs")
        rule
            .onNodeWithText("Fetch Recipes")
            .performClick()


//        rule
//            .waitUntil(timeoutMillis = 15_000) {
//                rule
//                    .onAllNodesWithText("FAIL ON THIS")
//                    .fetchSemanticsNodes().size == 1
//            }
    }
}