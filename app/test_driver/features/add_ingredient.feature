Feature: Add ingredient
    The user should be able to add ingredients to his inventory.

    Scenario: Add ingredient success
        When I write "oso@gmail.com" in "email_field"
        When I write "123456" in "password_field"
        When I tap the element with key "login_button"
        And I pause for 1 seconds
        Then the element with key "inventory_button" is present
        When I tap the element with key "inventory_button"
        And I pause for 1 seconds
        Then the element with key "add_ingredient_button" is present
        And I pause for 1 seconds
        When I tap the element with key "add_ingredient_button"
        Then the element with key "Angel Pasta" is present
        When I tap the element with key "Angel Pasta"
        And I pause for 1 seconds
        Then the element with key "Angel Pasta" is present
        And I tap the element with key "back_button_inventory_page"
        And I pause for 1 seconds
        Then the element with key "logout_button" is present
        And I tap the element with key "logout_button"



