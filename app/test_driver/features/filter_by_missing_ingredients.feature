Feature: Filter by missing ingredients
    The user should be able to filter is available recipes by missing ingredients.

    Scenario: Search success
        When I write "oso@gmail.com" in "email_field"
        When I write "123456" in "password_field"
        When I tap the element with key "login_button"
        And I pause for 1 seconds
        Then the element with key "search_button_home_page" is present
        When I tap the element with key "search_button_home_page"
        Then the element with key "filter_button_search_page" is present
        When I tap the element with key "filter_button_search_page"
        And I pause for 1 seconds
        When I tap the element with key "filter_button_1"
        Then the element with key "Cast-Iron Skillet Steak" is present
        And I tap the element with key "back_button_search_page"
        Then the element with key "logout_button" is present
        And I tap the element with key "logout_button"