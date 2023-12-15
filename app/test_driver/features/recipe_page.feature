Feature: Go to individual recipe page
    The user should be able to check the information of a recipe by clicking on it.

    Scenario: Go to individual recipe page success
        When I write "oso@gmail.com" in "email_field"
        When I write "123456" in "password_field"
        When I tap the element with key "login_button"
        And I pause for 1 seconds
        Then the element with key "Potato Salad" is present
        When I tap the element with key "Potato Salad"
        And I pause for 1 seconds
        Then the element with key "recipe_page_title" is present
        When I tap the element with key "recipe_page_back_button"
        And I pause for 1 seconds
        Then the element with key "logout_button" is present
        And I tap the element with key "logout_button"