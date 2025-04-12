from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from appium.options.common import AppiumOptions
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
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

# Wait for the app to launch
print("Waiting for the app to launch...")
time.sleep(10)

# Explicitly launch the app using the mobile: startActivity command
print("Explicitly launching the app...")
try:
    driver.execute_script("mobile: startActivity", {
        "intent": "com.example.mobile_app/.MainActivity"
    })
except Exception as e:
    print(f"Failed to launch app with mobile: startActivity: {str(e)}")
    raise

# Wait for the app to fully load
print("Waiting for the app to load...")
time.sleep(5)

# Test Case: Login to the app
def test_login():
    try:
        # Locate and fill the email field
        email_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[1]"))
        )
        print("Email field found successfully using XPath")
        email_field.clear()
        email_field.click()
        email_field.send_keys("lupin@hogwarts.com")
        print("Email entered: lupin@hogwarts.com")

        # Locate and fill the password field
        password_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[2]"))
        )
        print("Password field found successfully using XPath")
        password_field.clear()
        password_field.click()
        password_field.send_keys("eatCh0klate")
        print("Password entered: eatCh0klate")

        # Debug: Print all buttons on the screen
        print("Available buttons on the screen:")
        buttons = driver.find_elements(AppiumBy.XPATH, "//android.widget.Button")
        if buttons:
            for i, button in enumerate(buttons, 1):
                text = button.get_attribute("text") or "N/A"
                print(f"Button {i}: text='{text}'")
        else:
            print("No buttons found with class 'android.widget.Button'")

        # Locate and click the login button using positional locator
        login_button = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, "Login Button"))
        )
        print("Login button found successfully using positional XPath")
        login_button.click()
        print("Login button clicked") # flutter build apk

        # Wait briefly for login to process
        time.sleep(2)

        # Verify login success (adjust this based on your app’s behavior)
        toast = driver.find_element(AppiumBy.XPATH, "//android.widget.Toast")
        toast_text = toast.get_attribute("text")
        assert "Login successful!" in toast_text, f"Expected 'Login successful!' but got '{toast_text}'"
        print("Login successful! Toast message: ", toast_text)

    except Exception as e:
        print(f"Test Failed: {str(e)}")
        assert False, f"Test Failed: {str(e)}"

# Run the test
if __name__ == "__main__":
    try:
        test_login()
    finally:
        driver.quit()