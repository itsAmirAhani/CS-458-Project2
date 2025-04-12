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
        time.sleep(1)
        email_field.click()
        email_field.send_keys("lupin@hogwarts.com")
        print("Email entered: lupin@hogwarts.com")

        # Locate and fill the password field
        password_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[2]"))
        )
        print("Password field found successfully using XPath")
        password_field.clear()
        time.sleep(1)
        password_field.click()
        password_field.send_keys("eatCh0klate")
        print("Password entered: eatCh0klate")

        # Locate and click the login button using XPath by its visible text "Login"
        login_button = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@content-desc, 'Login Button')]"))
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

        #Locate and fill the Name & Surname field
        name_surname_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[1]"))
        )
        print("Name & Surname field found successfully using XPath")
        name_surname_field.clear()
        name_surname_field.click()
        name_surname_field.send_keys("John Doe")
        print("Name & Surname entered: John Doe")

        # Locate and tap the Birth Date field to open the date picker
        birth_date_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@content-desc, 'Birth Date')]"))
        )
        print("Birth Date field found successfully using XPath")
        birth_date_field.click()
        print("Birth Date field tapped to open date picker")

        # Wait for the date picker dialog to appear
        time.sleep(10)
        
        # Locate and click the pencil button to switch to manual entry
        pencil_button = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@content-desc, 'fieldLabelText')]"))
        )
        print("Pencil button found successfully")
        pencil_button.click()
        print("Pencil button clicked to switch to manual entry")
        # Set the year (e.g., 1990)
        year_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@content-desc, 'year')]"))
        )
        print("Year is about to set to 1990")
        year_field.send_keys("1990")
        print("Year set to 1990")

        # Wait for the date picker dialog to appear
        time.sleep(2)

        # Set the month (e.g., May)
        month_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@content-desc, 'Month')]"))
        )
        print("Month is about to set to May")
        month_field.send_keys("May")
        print("Month set to May")

        # Wait for the date picker dialog to appear
        time.sleep(2)

        # Set the day (e.g., 15)
        day_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@content-desc, 'day')]"))
        )
        print("Day is about to set to 15")
        day_field.send_keys("15")
        print("Day set to 15")

        # Wait for the date picker dialog to appear
        time.sleep(2)

        # Click the OK button to confirm
        ok_button = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//android.widget.Button[@text='OK']"))
        )
        ok_button.click()
        print("Date picker OK button clicked")

        # Verify the birth date is set
        birth_date_display = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//android.widget.TextView[@text='1990-05-15']"))
        )
        print("Birth Date set successfully: 1990-05-15")

    except Exception as e:
        print(f"Test Failed: {str(e)}")
        assert False, f"Test Failed: {str(e)}"

# Run the test
if __name__ == "__main__":
    try:
        test_login()
    finally:
        driver.quit()