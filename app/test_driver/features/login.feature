Feature: Logging in
  The user should be able to log in to the system using an email and password.
  The user should be able to log out of the system.

  Scenario: SignIn insucess
    When I write "wrong@gmail.com" in "email_field"
    When I write "wrong" in "password_field"
    When I tap the element with key "login_button"
    Then the element with key "login_form" is present

  Scenario: SignIn sucess
    When I write "oso@gmail.com" in "email_field"
    When I write "123456" in "password_field"
    When I tap the element with key "login_button"
    And I pause for 1 seconds
    Then the element with key "home_page" is present
    And I tap the element with key "logout_button"

   

  