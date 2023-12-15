Feature: Logging out
  The user should be able to log out of the system.

Scenario: SignOut
    When I write "oso@gmail.com" in "email_field"
    When I write "123456" in "password_field"
    When I tap the element with key "login_button"
    And I pause for 1 seconds
    Then the element with key "logout_button" is present
    When I tap the element with key "logout_button"
    Then the element with key "login_form" is present