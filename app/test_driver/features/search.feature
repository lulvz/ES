Feature: Search recipes
    The user should be able search for his available recipes.

    Scenario: Search success
        When I write "oso@gmail.com" in "email_field"
        When I write "123456" in "password_field"
        When I tap the element with key "login_button"
        And I pause for 1 seconds
        Then the element with key "search_button_home_page" is present
        When I tap the element with key "search_button_home_page"
        Then the element with key "toggle_search_bar" is present
        When I tap the element with key "toggle_search_bar"
        And I pause for 1 seconds
        When I write "potato salad" in "search_bar"
        Then the element with key "Potato Salad" is present
        And I tap the element with key "back_button_search_page"
        Then the element with key "logout_button" is present
        And I tap the element with key "logout_button"