package com.eatright

import androidx.compose.ui.test.assertTextEquals
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onParent
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextInput
import com.eatright.composables.Login
import com.eatright.ui.theme.EatRightTheme
import junit.framework.TestCase.assertFalse
import org.junit.Rule
import org.junit.Test

class LoginTest {
    @get:Rule
    val rule = createComposeRule()

    @Test
    fun wrong_password() {
        var loggedIn = false
        rule.setContent {
            EatRightTheme {
                Login({
                    loggedIn = true
                })
            }
        }

        rule
            .onNodeWithText("Username", useUnmergedTree = true)
            .onParent()
            .performTextInput("test")
        val passwordField = rule
            .onNodeWithText("Password", useUnmergedTree = true)
            .onParent()
        passwordField.performTextInput("not the correct fake password!")
        rule
            .onNodeWithText("Login")
            .performClick()

        rule.waitUntil(timeoutMillis=10_000) {
            rule
                .onAllNodesWithText("Incorrect username or password.")
                .fetchSemanticsNodes().size == 1
        }
        passwordField.assertTextEquals("")
        assertFalse(loggedIn)
    }


    @Test
    fun successful_fake_login() {
        var loggedIn = false
        rule.setContent {
            EatRightTheme {
                Login({
                    loggedIn = true
                })
            }
        }

        rule
            .onNodeWithText("Username", useUnmergedTree = true)
            .onParent()
            .performTextInput("test")
        val passwordField = rule
            .onNodeWithText("Password", useUnmergedTree = true)
            .onParent()
        passwordField.performTextInput("password")
        rule
            .onNodeWithText("Login")
            .performClick()

        rule
            .waitUntil(timeoutMillis=10_000) { loggedIn }
    }
}