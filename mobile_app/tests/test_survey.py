from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from appium.options.common import AppiumOptions
import time

# Desired capabilities for your Flutter app
desired_caps = {
    "platformName": "Android",
    "platformVersion": "12",
    "deviceName": "emulator-5554",
    "app": "C:\\Users\\ahmad\\Desktop\\Bilkent\\4th year\\2nd sem\\VV - CS458\\Project\\CS-458-Project-2\\mobile_app\\build\\app\\outputs\\flutter-apk\\app-debug.apk",
    "automationName": "UiAutomator2",
    "appPackage": "com.example.mobile_app",
    "appActivity": ".MainActivity",
    "noReset": True
}

# Set capabilities using AppiumOptions
options = AppiumOptions()
for key, value in desired_caps.items():
    options.set_capability(key, value)

# Connect to Appium server
driver = webdriver.Remote("http://localhost:4723", options=options)

def login():
    email_field = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "email_field")
    email_field.send_keys("test@example.com")
    password_field = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "password_field")
    password_field.send_keys("password123")
    login_button = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "login_button")
    login_button.click()
    time.sleep(2)

# Test Case 1: Partial Form Submission
def test_partial_submission():
    login()
    name_field = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "name_surname_field")
    name_field.send_keys("John Doe")
    email_field = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "email_field")
    email_field.send_keys("john@example.com")
    submit_button = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "submit_button")
    submit_button.click()
    toast = driver.find_element(AppiumBy.XPATH, "//android.widget.Toast")
    assert "Please select a birth date" in toast.text or "Please fill all required fields" in toast.text
    print("Test 1 Passed: Partial submission handled")

# Test Case 2: Multiple AI Models with Defects
def test_multiple_ai_models():
    login()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "name_surname_field").send_keys("Jane Doe")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "birth_date_field").click()
    driver.find_element(AppiumBy.XPATH, "//android.widget.Button[@text='1']").click()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "education_level_field").send_keys("University")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "city_field").send_keys("New York")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "gender_male").click()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "ai_models_field").send_keys("chatGPT, DeepSeek")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "defect_key_field").send_keys("chatGPT")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "defect_value_field").send_keys("slow")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "add_defect_button").click()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "defect_key_field").send_keys("DeepSeek")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "defect_value_field").send_keys("inaccurate")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "add_defect_button").click()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "beneficial_use_field").send_keys("Research")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "email_field").send_keys("jane@example.com")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "submit_button").click()
    toast = driver.find_element(AppiumBy.XPATH, "//android.widget.Toast")
    assert "Survey submitted successfully" in toast.text
    print("Test 2 Passed: Multiple AI models submitted")

# Test Case 3: Long Input Handling
def test_long_input():
    login()
    long_text = "A" * 500
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "name_surname_field").send_keys(long_text)
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "birth_date_field").click()
    driver.find_element(AppiumBy.XPATH, "//android.widget.Button[@text='1']").click()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "gender_male").click()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "email_field").send_keys("long@example.com")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "submit_button").click()
    toast = driver.find_element(AppiumBy.XPATH, "//android.widget.Toast")
    assert "Survey submitted successfully" in toast.text or "Error" not in toast.text
    print("Test 3 Passed: Long input handled")

# Test Case 4: Invalid Email Format
def test_invalid_email():
    login()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "name_surname_field").send_keys("Test User")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "birth_date_field").click()
    driver.find_element(AppiumBy.XPATH, "//android.widget.Button[@text='1']").click()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "gender_male").click()
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "email_field").send_keys("invalid@.com")
    driver.find_element(AppiumBy.ACCESSIBILITY_ID, "submit_button").click()
    toast = driver.find_element(AppiumBy.XPATH, "//android.widget.Toast")
    assert "Valid email required" in toast.text
    print("Test 4 Passed: Invalid email rejected")

# Test Case 5: Form Reset After Submission
def test_form_reset():
    test_multiple_ai_models()
    driver.back()
    login()
    name_field = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "name_surname_field")
    assert name_field.text == "" or name_field.text is None
    print("Test 5 Passed: Form reset after submission")

# Run all tests
if __name__ == "__main__":
    try:
        test_partial_submission()
        test_multiple_ai_models()
        test_long_input()
        test_invalid_email()
        test_form_reset()
    finally:
        driver.quit()