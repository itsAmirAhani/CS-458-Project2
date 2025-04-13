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
time.sleep(5)

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
        print("Login button clicked")

        # Wait briefly for login to process
        time.sleep(2)

        # Verify login success (adjust this based on your app’s behavior)
        toast = driver.find_element(AppiumBy.XPATH, "//android.widget.Toast")
        toast_text = toast.get_attribute("text")
        assert "Login successful!" in toast_text, f"Expected 'Login successful!' but got '{toast_text}'"
        print("Login successful! Toast message: ", toast_text)

        # Debug: Print all elements on the survey page to find the Education Level dropdown
        #print("Debug: Printing all elements on the survey page...")
        #all_elements = driver.find_elements(AppiumBy.XPATH, "//*")
        #print(f"Found {len(all_elements)} elements on the survey page")
        #counter = 0
        #for element in all_elements:
        #    class_name = element.get_attribute("class") or "N/A"
        #    text = element.get_attribute("text") or "N/A"
        #    content_desc = element.get_attribute("content-desc") or "N/A"
        #    print(f"Element={counter}: class={class_name}, text={text}, content-desc={content_desc}")
        #    counter += 1

        #Locate and fill the Name & Surname field
        name_surname_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[1]"))
        )
        print("Name & Surname field found successfully using XPath")
        name_surname_field.clear()
        name_surname_field.click()
        name_surname_field.send_keys("John Doe")
        print("Name & Surname entered: John Doe")

    # Locate and fill the Day field
        day_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[2]"))
        )
        print("Day field found successfully using XPath")
        day_field.clear()
        day_field.click()
        day_field.send_keys("15")
        print("Day set to 15")

        # Locate and fill the Month field
        month_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[3]"))
        )
        print("Month field found successfully using XPath")
        month_field.clear()
        month_field.click()
        month_field.send_keys("05")
        print("Month set to 05")

        # Locate and fill the Year field
        year_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[4]"))
        )
        print("Year field found successfully using XPath")
        year_field.clear()
        year_field.click()
        year_field.send_keys("1990")
        print("Year set to 1990")

        # Verify the birth date fields
        day_field_verify = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[2][@text='15']"))
        )
        month_field_verify = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[3][@text='05']"))
        )
        year_field_verify = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[4][@text='1990']"))
        )
        print("Birth Date set successfully: 15/05/1990")

        # Locate the Education Level dropdown (Spinner)
        education_dropdown = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@content-desc, 'Education Level')]"))
        )
        print("Education Level dropdown found successfully using XPath")
        education_dropdown.click()
        print("Education Level dropdown tapped to open options")

        # Wait for the dropdown menu to appear and select "Undergraduate"
        undergraduate_option = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//*[contains(@content-desc, 'Undergraduate')]"))
        )
        print("Undergraduate option found successfully")
        undergraduate_option.click()
        print("Selected Education Level: Undergraduate")
        
        # Add a small delay to ensure UI stability
        time.sleep(1)

        # Locate and fill the City field
        city_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[5]"))
        )
        print("City field found successfully using XPath")
        city_field.clear()
        city_field.click()
        city_field.send_keys("Ankara")
        print("City set to Ankara")
        
        # Verify the City field
        city_field_verify = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "(//android.widget.EditText)[5][@text='Ankara']"))
        )
        print("City verified successfully: Ankara")
        
        # Dismiss the keyboard by tapping the "Gender" label (a non-interactive area)
        driver.press_keycode(4)  # 4 is the Android keycode for the Back button
        print("Back button pressed to dismiss keyboard")

        # Add a small delay to ensure the keyboard is fully dismissed
        time.sleep(1)

        # Locate the Male radio button using content-desc
        male_radio_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((AppiumBy.XPATH, "//*[contains(@content-desc, 'MaleRadio')]"))
        )
        print("Male radio button found successfully using content-desc")
        male_radio_button.click()
        print("Selected Gender: Male")

        # Verify the selection
        male_radio_button_verify = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//android.widget.RadioButton[@content-desc='MaleRadio'][@checked='true']"))
        )

        print("Gender button found successfully using positional XPath")
        male_radio_button.click()
        print("Gender button clicked") 

        # Click the ChatGPT chip
        chatgpt_chip = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((AppiumBy.XPATH, "//*[contains(@content-desc, 'ChatGPT')]"))
        )
        print("ChatGPT chip found successfully using content-desc")
        chatgpt_chip.click()
        print("ChatGPT chip clicked")
        
        # Debug: Print all EditText elements
        time.sleep(1)  # Give the UI a moment to render
        all_elements = driver.find_elements(AppiumBy.XPATH, "//android.widget.EditText")
        
        # Wait for the ChatGPT defect field to appear (first empty EditText after clicking)
        chatgpt_defect_field = WebDriverWait(driver, 20).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//android.widget.EditText[@text='']"))
        )
        print("ChatGPT defect field found")
        chatgpt_defect_field.clear()
        chatgpt_defect_field.click()
        chatgpt_defect_field.send_keys("Sometimes gives inaccurate answers")
        print("ChatGPT defect set to: Sometimes gives inaccurate answers")
        
        # Dismiss the keyboard
        driver.press_keycode(4)
        print("Back button pressed to dismiss keyboard")
        time.sleep(1)

        # Locate the Beneficial AI Use field using content-desc
        beneficial_ai_field = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//android.widget.EditText[@text='']"))        
        )
        print("Beneficial AI Use field found using content-desc")
        beneficial_ai_field.clear()
        beneficial_ai_field.click()
        beneficial_ai_field.send_keys("Automating repetitive tasks")
        print("Beneficial AI Use set to: Automating repetitive tasks")

        # Dismiss the keyboard
        driver.press_keycode(4)
        print("Back button pressed to dismiss keyboard")
        time.sleep(1)

        # Locate the Email field using content-desc
        email_field = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((AppiumBy.XPATH, "//android.widget.EditText[@text='']"))        
        )
        print("Email field found using content-desc")
        email_field.clear()
        email_field.click()
        email_field.send_keys("ahmed.haikal")
        print("Email set to: ahmed.haikal won't be submitted cause it is missing @ sign")

        time.sleep(4)

        email_field.send_keys("@ug.bilkent.edu.tr")

        # Dismiss the keyboard
        driver.press_keycode(4)
        print("Back button pressed to dismiss keyboard")
        time.sleep(1)

        # Locate the Submit Survey button using its text
        submit_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((AppiumBy.XPATH, "//*[contains(@content-desc, 'Submit Survey')]"))
        )
        print("Submit Survey button found using text")
        submit_button.click()
        print("Submit Survey button clicked")

    except Exception as e:
        print(f"Test Failed: {str(e)}")
        assert False, f"Test Failed: {str(e)}"

# Run the test
if __name__ == "__main__":
    try:
        test_login()
    finally:
        driver.quit()