import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.ui import Select

# NOTE: this depends on 1.) chrome 2.) chromedriver being installed systemwide.
# both are installed systemwide by brew. versions are just based on w/e brew
# decides to install. there is likely a better way to localize this, but for
# now, this works.

chrome_binary_location = "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"

options = webdriver.ChromeOptions()
options.binary_location = chrome_binary_location
# options.add_argument("headless")
options.add_argument("disable-gpu")
options.add_argument("--start-maximized")

driver = webdriver.Chrome(options=options)
driver.get("http://169.254.134.184")

try:

    print("configuring NVX")

    # login to stream
    def login_to_stream():
    
        driver.implicitly_wait(40)        
        # username field
        username_field = driver.find_element_by_css_selector("#cred_userid_inputtext")
        username_field.send_keys("admin")

        # password field
        passwd_field = driver.find_element_by_css_selector("#cred_password_inputtext")
        passwd_field.send_keys("admin")

    

        # login click
        prompt_login_button = driver.find_element_by_css_selector("#credentials > button")
        prompt_login_button.click()

        print("login complete")


        # select stream
        print("waiting for login")
        time.sleep(30)

        # select stream page
        driver.implicitly_wait(40)
        stream_page_button = driver.find_element_by_css_selector("#hyd-groups-tree-navigation > group-tree > p-tree > div > ul > p-treenode:nth-child(2) > li > div > span.ui-treenode-label.ui-corner-all > span > div > div")
        stream_page_button.click()
        
        print("on stream page")

    login_to_stream()
        
    # add if for if TX or RX
    time.sleep(4)
    
    # DELETE 
    tx = False
    rx = True

    if tx:

    
        driver.implicitly_wait(5)
        stream_mode_dropdown = driver.find_element_by_css_selector("#cmb_stream_DeviceMode")
        stream_mode_dropdown.click()

        driver.implicitly_wait(5)
        tramsmitter_button = driver.find_element_by_css_selector("#cmb_stream_DeviceMode > div > div.ui-dropdown-panel.ui-widget-content.ui-corner-all.ui-helper-hidden.ui-shadow > div > ul > li:nth-child(2)")
        tramsmitter_button.click()

        print("changed to transmitter")

        
        driver.implicitly_wait(5)
        reboot_button = driver.find_element_by_css_selector("#btn_DeviceManagement_okButtonLabel")
        reboot_button.click()

        print("rebooting please wait")
        
        time.sleep(200)

        login_to_stream()

        multicast_address_field = driver.find_element_by_css_selector("#txt_stream_MulticastAddressInput")
        multicast_address_field.send_keys("test")

        pass
    elif rx:
        multicast_address_field = driver.find_element_by_css_selector("#txt_stream_MulticastAddressInput")
        multicast_address_field.send_keys("test")


        # add switch to extract for audio and set source.
        pass


finally:
    driver.quit()
    pass
