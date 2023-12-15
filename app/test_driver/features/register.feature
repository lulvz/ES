Feature: Registering a new account.
    As a user, I want to register a new account so that I can use the application

    Scenario: Go to Register Page
        Then the element with key "login_form" is present
        When I tap the element with key "switch_to_register_button"
        Then the element with key "register_form" is present

    Scenario: Register sucess
        Then the element with key "login_form" is present
        When I tap the element with key "switch_to_register_button"
        Then the element with key "register_form" is present
        When I write "register@gmail.com" in "register_email"
        When I write "username" in "register_username"
        When I write "register123" in "register_password"
        When I tap the element with key "register_button"
        And I pause for 1 seconds
        Then the element with key "home_page" is present
        And I tap the element with key "logout_button"

    Scenario: Register insucess
        Then the element with key "login_form" is present
        When I tap the element with key "switch_to_register_button"
        Then the element with key "register_form" is present
        When I write "invalid_registergmail.com" in "register_email"
        When I write "invalid_username" in "register_username"
        When I write "invalid123" in "register_password"
        When I tap the element with key "register_button"
        Then the element with key "register_form" is present
    