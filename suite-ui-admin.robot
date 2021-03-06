*** Settings ***
Documentation                           FloShip UI testing Admin part
Resource                                resource.robot
Suite Setup                             Setup Tests
Suite Teardown                          Close All Browsers

*** Test Cases ***

Create a new user (Admin)
    [Tags]                        CreateUser
    ${email}=                     Get Email Client     ${client mail}
    set suite variable            ${rand_email}        ${email}
    log to console                ${rand_email}
    Login                         ${login_admin}        ${pass_admin}
    Wait Until Page Contains      Dashboard
    Capture Page Screenshot       ${TEST NAME}-{index}.png

Invalid User Name (Admin)
    Go To                         ${ADMIN}auth/user/
    Invalid User Name         test @.        Enter a valid username. This value may contain only letters, numbers and @/./+/-/_ characters.      This field is required

TC467 - Prepare client's warehouse
    ${name}=                    Get Rand ID          FName_
    ${lname}=                    Get Rand ID          LName_
    set suite variable          ${ch_name}        ${name}
    set suite variable          ${ch_lname}       ${lname}
    Create User                   ${rand_email}              12345678             12345678
    wait until page contains      The user "${rand_email}" was added successfully. You may edit it again below.
    Settings User                ${ch_name}    	${ch_lname}        ${rand_email}
    Select role (super user)
    wait until page contains      The user "${rand_email}" was changed successfully.

TC672 - Users. Search
    Go To                       ${ADMIN}auth/user/
    Check Item in Search        ${rand_email}
    Show in Table                ${rand_email}      ${ch_name}	${ch_lname}         Send Welcome Email
    Check Item in Search        ${ch_name}
    Show in Table                ${rand_email}      ${ch_name}	${ch_lname}         Send Welcome Email
    Check Item in Search        ${ch_lname}
    Show in Table                ${rand_email}      ${ch_name}	${ch_lname}        Send Welcome Email

TC674 - Users. Filters
    Go To                       ${ADMIN}auth/user/
    Check Item in Search        ${rand_email}
    Check Filter                1      No
    wait until page contains        0 users
    Check Filter                1      Yes
    Show in Table                ${rand_email}      ${ch_name}	${ch_lname}         Send Welcome Email
    Check Filter                2      Yes
    Show in Table                ${rand_email}      ${ch_name}	${ch_lname}         Send Welcome Email
    Check Filter                2      No
    wait until page contains        0 users

TC676 - Users. Sorting
    Go To                             ${ADMIN}auth/user/
    Sorting                          Username
    wait until page contains element      xpath=//tr[@class="row1"]
    Sorting                          First name
    wait until page contains element      xpath=//tr[@class="row1"]
    Sorting                          Last name
    wait until page contains element      xpath=//tr[@class="row1"]

TC678 - TC679 - Users. Bulk action 1
    Go To                             ${ADMIN}auth/user/
    Delete user                      Delete selected users
    wait until page contains          Successfully deleted 1 user
    Delete user Contact               Download contacts
    wait until page contains          Select user to change




    # create a new client
Create a new client (Admin)
    ${client_}=                   Get Rand ID        ${client}
    ${rand_refer_client}=                Get Rand ID        ${refer}
    set suite variable            ${rand_client_name}    ${client_}
    log to console                ${rand_client_name}
    Go To                         ${ADMIN}floship/client/
    Create Client                ${rand_client_name}        ${rand_email}            ${rand_email}       ${rand_refer_client}
    wait until page contains      The client "${rand_client_name}" was added successfully

#    # three pl
#    Go To                         ${ADMIN}floship/threepl/
#    Change Three pl               Geodis      ${rand_email}
#    wait until page contains      The 3PL "Geodis" was changed successfully

TC673 - Clients. Search
    Go To                       ${ADMIN}floship/client/
    Check Item in Search        ${rand_client_name}
    Show in Table               ${rand_client_name}     	 Finished	Geodis	     Active

TC677 - Clients. Sorting
     Go To                         ${ADMIN}floship/client/
     Sorting                       Client
     wait until page contains element      xpath=//tr[@class="row1"]

TC681 - Clients. Bulk action 1
    Go To                         ${ADMIN}floship/client/
    Delete user Contact               Activate default packaging items
    Sleep                             2 sec
    #wait until page contains           Activate was

TC682 - Clients. Bulk action 2
    Go To                         ${ADMIN}floship/client/
    Delete user Contact               Export as CSV file
    wait until page contains          Select client to change

#################### Product (Admin)

TC615 - Delete product
    Go To                               ${ADMIN}inventory/product/
    wait until page contains        Dashboard
    Check Item in Search            XM01
    wait until page contains element        xpath=//tr[@class="row1"][contains(.,"XM01")]
    Delete Something              products
    wait until page contains      Successfully deleted

TC613 - Create product (empty fields)
    [Tags]                             AdminSearch
    ${sku}=                            Get Rand Sku
    ${desc}=                           Get Rand ID        ${sku_desc}
    set suite variable                 ${search_sku}        ${sku}
    set suite variable                 ${search_desc}       ${desc}
    Go to                               ${ADMIN}inventory/product/
    Check Add Somethings (Admin)        Add product
    wait error this is required (Admin)       Client            This field is required
    wait error this is required (Admin)       Sku            This field is required
    wait error this is required (Admin)       Description            This field is required
    wait error this is required (Admin)       Customs description            This field is required

TC612 - Create product (Out of Stock)
    Go To                             ${ADMIN}inventory/product/add/
    Create Product Admin                   ${rand_client_name}             ${search_sku}          ${search_desc}
    Add SKU and Item for Product (Admin)           ${rand_client_name}            ${search_sku}
    log to console                  ${search_sku}
    log to console                  ${search_desc}
    wait until page contains        The product "${search_desc}" was added successfully.
    Show Product                    ${search_sku}        ${search_desc}

TC614 - Edit product
    Go To                          ${ADMIN}inventory/product/
    Edit Product Admin             ${search_sku}      ${rand_client_name}             ${search_sku}          ${search_desc}
    wait until page contains        The product "${search_desc}" was changed successfully

TC616 - Search
    Go To                           ${ADMIN}inventory/product/
    Check Item in Search                ${search_sku}
    Show Product                        ${search_sku}        ${search_desc}
    Check Item in Search                ${search_desc}
    Show Product                        ${search_sku}        ${search_desc}

TC617 - Filters
    Go to                              ${ADMIN}inventory/product/
    Check Filter                2      ${rand_client_name}
    Show Product                       ${search_sku}       ${search_desc}
    Check Filter                1      out of stock
    Show Product                       ${search_sku}       ${search_desc}
    Check Filter                1      available
    wait until page contains           0 products
    Check Filter                1      negative quantity
    wait until page contains           0 products

TC618 - Sorting
    Go To                             ${ADMIN}inventory/product/
    Sorting                           Sku
    wait until page contains element      xpath=//tr[@class="row1"]

TC619 - Bulk actions

################ Item CSV Upload


TC621 - Create item
    Mouse over and Click               Inventory              /admin-backend/items/itemcsvupload/
    wait until page contains           Select item csv upload to change

TC653 - Create item (empty fields)
    Add report                     Add item csv upload           Add item csv upload
    wait element and click         xpath=//input[contains(@name,"_save")]
    wait until page contains        Please correct the error below
    wait error this is required (Admin)           Client              This field is required

TC627 - Create item: empty file
    Check Item CSV Upload             empty.xlsx       ${rand_client_name}       The file is empty

TC628 - Create item: missing 1 column (SKU)
    Check Item CSV Upload             3_missing_1_column.xlsx       ${rand_client_name}       Missing_headers: ['SKU']

TC629 - Create item: missing 2 column (Description)
    Check Item CSV Upload             3_missing_2_column.xlsx       ${rand_client_name}       Missing_headers: ['Description']

TC630 - Create item: missing 3 column (Brand/Manufacturer)
    Check Item CSV Upload             3_missing_3_column.xlsx       ${rand_client_name}       Missing_headers: ['Brand/Manufacturer']

Check "Item CSV Upload" (Missing UPC/EAN/MPN)
    Check Item CSV Upload             3_missing_4_column.xlsx       ${rand_client_name}       Missing_headers: ['UPC/EAN/MPN']

TC632 - Create item: missing 5 column (Harmonized Code)
    Check Item CSV Upload             3_missing_5_column.xlsx       ${rand_client_name}       Missing_headers: ['Harmonized Code']

TC633 - Create item: missing 6 column (Gross Weight (kg))
    Check Item CSV Upload             3_missing_6_column.xlsx       ${rand_client_name}       Missing_headers: ['Gross Weight (kg)']

TC634 - Create item: missing 7 column (Gross Length (cm))
    Check Item CSV Upload             3_missing_7_column.xlsx       ${rand_client_name}       Missing_headers: ['Gross Length (cm)']

TC635 - Create item: missing 8 column (Gross Width (cm))
    Check Item CSV Upload             3_missing_8_column.xlsx       ${rand_client_name}       Missing_headers: ['Gross Width (cm)']

TC636 - Create item: missing 9 column (Gross Height (cm))
    Check Item CSV Upload             3_missing_9_column.xlsx       ${rand_client_name}       Missing_headers: ['Gross Height (cm)']

TC637 - Create item: missing 10 column (Customs Value (USD))
    Check Item CSV Upload             3_missing_10_column.xlsx       ${rand_client_name}       Missing_headers: ['Customs Value (USD)']

TC638 - Create item: missing 11 column (Customs Description)
    Check Item CSV Upload             3_missing_11_column.xlsx       ${rand_client_name}       Missing_headers: ['Customs Description']

TC639 - Create item: missing 12 column (Category (if known))
    Check Item CSV Upload             3_missing_12_column.xlsx       ${rand_client_name}       Missing_headers: ['Category (if known)']

TC640 - Create item: missing 13 column (Lithium Ion Battery (Y/N))
    Check Item CSV Upload             3_missing_13_column.xlsx       ${rand_client_name}       Missing_headers: ['Lithium Ion Battery (Y/N)']

TC641 - Create item: missing 14 column (Expiry Date (Y/N))
    Check Item CSV Upload             3_missing_14_column.xlsx       ${rand_client_name}       Missing_headers: ['Expiry Date (Y/N)']

TC642 - Create item: missing 15 column (Liquid (Y/N))
    Check Item CSV Upload             3_missing_15_column.xlsx       ${rand_client_name}       Missing_headers: ['Liquid (Y/N)']

TC643 - Create item: missing 16 column (Item Image URL)
    Check Item CSV Upload             3_missing_16_column.xlsx       ${rand_client_name}       Missing_headers: ['Item Image URL']

TC644 - Create item: missing 17 column (Packaging SKU)
    Check Item CSV Upload             3_missing_17_column.xlsx       ${rand_client_name}       Missing_headers: ['Packaging SKU']

TC645 - Create item: missing 18 column (Country of Manufacture)
    Check Item CSV Upload             3_missing_18_column.xlsx       ${rand_client_name}       Missing_headers: ['Country of Manufacture']

#TC646 - Create item: missing 19 column (Unit QTY)
#    Check Item CSV Upload             3_missing_19_column.xlsx       ${rand_client_name}       Missing_headers: ['Unit QTY']
#
#TC647 - Create item: missing 20 column (Unit type)
#    Check Item CSV Upload             3_missing_20_column.xlsx       ${rand_client_name}       Missing_headers: ['Unit type']



TC648 - Create item: file with invalid data (product exists)
    Check Item CSV Upload             4_invalid_data.xlsx       ${rand_client_name}       Items Csv Upload
    wait until page contains       Items Csv Upload
    show buttons in bulk form           Valid 0    Invalid 1    All 1
    click element                  css=button.close > span
    wait until page does not contain element         xpath=//input[contains(@value,"Save Items Item Csv Upload")]

TC654 - Delete item
    wait element and click               xpath=//a[contains(.,"Delete")]
    wait until page contains          Are you sure you want to delete the item csv upload
    wait element and click            xpath=//input[contains(@value,"Yes, I'm sure")]
    wait until page contains          The item csv upload

TC650 - Create item: file with missed fields
    Check Item CSV Upload             5_missing_fields.xlsx       ${rand_client_name}       Items Csv Upload
    wait until page contains       Items Csv Upload
    show buttons in bulk form           Valid 2    Invalid 1    All 3
    click element                  css=button.close > span
    wait until page does not contain element         xpath=//input[contains(@value,"Save Items Item Csv Upload")]

TC621 - Create item
    Check Item CSV Upload             original2.xlsx       ${rand_client_name}       Items Csv Upload
    wait until page contains       Items Csv Upload
    show buttons in bulk form           Valid 6    Invalid 0    All 6
    click element                  css=button.close > span
    wait element and click         xpath=//input[contains(@value,"Save Items Item Csv Upload")]
    wait until page contains       The item csv upload "${save_item_csv}" was changed successfully
    Sleep                          3 sec

TC621 - Check item (check PROD_1 and PROD_2)
    Go to                               ${ADMIN}inventory/product/
    Check Data Row                    PROD_1         A product one         ${rand_client_name}          987654321
    Check Data Row                   PROD_2         A product two         ${rand_client_name}          	987654321

TC656 - Filters
    Go to                              ${ADMIN}items/itemcsvupload/
    Check Filter                1      ${rand_client_name}
    Show Product                       Upload          ${rand_client_name}
    Check Filter                2      Pending
    wait until page contains           0 item csv uploads
    Check Filter                2      Started
    wait until page contains           0 item csv uploads
    Check Filter                2      Valid
    wait until page contains           0 item csv uploads
    Check Filter                2      Invalid
    Show Product                       Upload          ${rand_client_name}
    Check Filter                2      Failed
    wait until page contains           0 item csv uploads
    Check Filter                2      Saving
    wait until page contains           0 item csv uploads
    Check Filter                2      Saved
    Show Product                       Upload          ${rand_client_name}
    Check Filter                2      Processing
    wait until page contains           0 item csv uploads

TC657 - Sorting

############  Stock Adjustment
TC659 - Create stock adjustment
   [Tags]                                Adjustment
   Go To                         ${ADMIN}stock_adjustment/stockadjustment/
   wait until page contains      Select stock adjustment to change
   Add Stock Adjustment          ${search_sku}            ${search_sku} -- Base Item
   ${status}=                     Get Id Adjustment         Draft
   log to console                 ${status}
   wait until page contains      The stock adjustment "${status}" was added successfully
   set suite variable             ${get_status}            ${status}


TC660 - Create stock adjustment (approve)
   Approve stock adjustment        ${get_status}
   wait until page contains      ${get_status} successfully set to Approved


TC661 - Check product after adding stock adjustment
   Go To                         ${ADMIN}inventory/product/
   Check Item in Search          ${search_sku}
   Check Data Row                ${search_sku}       ${search_desc}       ${rand_client_name}    1

TC662 - Search
   Go To                         ${ADMIN}stock_adjustment/stockadjustment/
   Check Item in Search         ${get_status}
   wait until page contains     1 stock adjustment
   check stock adjustment       ${get_status}              Approved

TC664 - Sorting
    Go To                             ${ADMIN}stock_adjustment/stockadjustment/
    Sorting for FAD              Floship adjustment number           FADJ0000001           ${get_status}

TC663 - Filters
#############ASN Admin


TC698 - Create ASN (empty fields)
    Go To                         ${ADMIN}
    ${tracking}=                         Get Rand ID        ${tracking}
    ${reference}=                        Get Rand ID        ${refer}
    set suite variable                 ${search_tracking}   ${tracking}
    set suite variable                 ${search_refer}      ${reference}
    Wait Until Page Contains            Dashboard
    Mouse over and Click                ASN                   /admin-backend/asns/asn/
    wait element and click             xpath=//a[contains(.,"Add ASN")]
    wait until page contains            Add ASN
    wait element and click              name=_save

    wait error this is required (Admin)       Client            This field is required
    wait error this is required (Admin)       Contact name            This field is required
    wait error this is required (Admin)       Eta            This field is required
    wait error this is required (Admin)       Packaging list            This field is required

TC665 - Create ASN
    Go To                           ${ADMIN}asns/asn/add/
    Add SKU in ASN in Admin         ${search_sku}
    Create ASN Admin                ${rand_client_name}            ${search_refer}     ${search_tracking}
    log to console                  ${search_tracking}
    log to console                  ${search_refer}
    wait until page contains        was added successfully
    ${id}=                          Get FASN in Admin           ${search_refer}
    log to console                  ${id}
    set suite variable              ${search_fsn}                ${id}
    Show ASN                        ${search_refer}

TC954 - Create ASN (nonexistent Item)
    Check Item in Search                        ${search_fsn}
    Check does not exist SKU          Inventory item
    wait until page contains         Please correct the error below
    header link admin               ASN items                   Add another ASN item
    wait until page contains        Select a valid choice. That choice is not one of the available choices


TC666 - Create ASN (approve) - Create ASN in Admin Panel (Filter - Pending Arrival)
    Go To                            ${ADMIN}asns/asn/
    Check Item in Search             ${search_fsn}
    Check ASN Approve                ${search_fsn}        Pending Arrival Asn
    wait until page contains         ${search_fsn} successfully set to Pending Arrival
    Go To                            ${ADMIN}asns/asn/
    show in table                    ${search_fsn}       ${rand_client_name}         Pending Arrival         Geodis

TC666 - Create ASN (approve) - Create ASN in Admin Panel (Pending Arrival)

    Go To                            ${ADMIN}asns/asn/
    Check Filter                1      ${rand_client_name}
    Check Filter                2      Pending Arrival
    Show Product                       ${search_fsn}       Pending Arrival


TC666 - Create ASN (approve) - Create ASN in Admin Panel (to In Review)
    Go To                            ${ADMIN}asns/asn/
    Check Item in Search                        ${search_fsn}
    Check ASN Approve                ${search_fsn}    In Review Asn
    wait until page contains         ${search_fsn} successfully set to In Review
    Go To                            ${ADMIN}asns/asn/
    show in table                    ${search_fsn}       ${rand_client_name}         In Review         Geodis

TC666 - Create ASN (approve) - Create ASN in Admin Panel (Filter - In Review)
    Go To                            ${ADMIN}asns/asn/
    Check Filter                1      ${rand_client_name}
    Check Filter                2      In Review
    Show Product                       ${search_fsn}        In Review


TC666 - Create ASN (approve) - Create ASN in Admin Panel (In Review - Approved)
    Go To                            ${ADMIN}asns/asn/
    Check Item in Search              ${search_fsn}
    Check ASN Approve                 ${search_fsn}  Approve Asn
    wait until page contains         ${search_fsn} successfully set to Approve
    Go To                            ${ADMIN}asns/asn/
    show in table                    ${search_fsn}       ${rand_client_name}         Approved        Geodis

TC666 - Create ASN (approve) - Create ASN in Admin Panel (Filter - Approve)
    Go To                            ${ADMIN}asns/asn/
    Check Filter                1      ${rand_client_name}
    Check Filter                2      Approved
    Show Product                       ${search_fsn}        Approved

TC671 - Sorting
    Go To                             ${ADMIN}asns/asn/
    Sorting for FASN              Floship ASN number           FASN0000015           ${search_fsn}

TC667 - Check product after adding ASN
    Go To                             ${ADMIN}inventory/product/
    Check Item in Search               ${search_sku}
    show in table                      ${search_sku}     ${search_desc}    ${rand_client_name}     133


############ ASN Upload CSV


TC699 - ASN items uploads (empty fields)
    Go To                         ${ADMIN}
    Mouse over and Click               ASN                    /admin-backend/asns/asnitemsupload/
    wait until page contains           Select asn items upload to change
    Add report                     Add asn items upload            Add asn items upload
    wait element and click         xpath=//input[contains(@name,"_save")]
    wait until page contains        Please correct the error below
    wait error this is required (Admin)           Client              This field is required

TC688 - ASN items uploads: empty file
    Check ASN CSV Upload       2_empty.xlsx       ${rand_client_name}       The file is empty

TC689 - ASN items uploads: missing 1 column (SKU)
    Check ASN CSV Upload     3_missing_1_column.xlsx       ${rand_client_name}    Missing_headers: ['SKU']

TC690 - ASN items uploads: missing 2 column (Quantity)
    Check ASN CSV Upload    3.1_missing_2_column.xlsx      ${rand_client_name}    Missing_headers: ['Quantity']

TC691 - ASN items uploads: missing 3 column (Unit Type)
    Check ASN CSV Upload   3.2_missing_3_column.xlsx      ${rand_client_name}    Missing_headers: ['Unit Type']

TC692 - ASN items uploads: file with invalid data
    Check ASN CSV Upload   4_invalid_data.xlsx      ${rand_client_name}     Asn Items Upload
    wait until page contains       Asn Items Upload
    show buttons in bulk form           Valid 0    Invalid 1    All 1
    click element                  css=button.close > span
    wait until page does not contain element         xpath=//input[contains(@value,"Save Items Item Csv Upload")]

TC960 - ASN items uploads: delete
    wait element and click               xpath=//a[contains(.,"Delete")]
    wait until page contains          Are you sure you want to delete the asn items upload
    wait element and click            xpath=//input[contains(@value,"Yes, I'm sure")]
    wait until page contains          The asn items upload

TC694 - ASN items uploads: file with missed fields
    Check ASN CSV Upload    5_missing_fields.xlsx       ${rand_client_name}     Asn Items Upload
    wait until page contains       Asn Items Upload
    show buttons in bulk form           Valid 0    Invalid 2    All 2
    click element                  css=button.close > span
    wait until page does not contain element         xpath=//input[contains(@value,"Save Items Asn Item Upload")]

TC684 - ASN items uploads: successful upload
    Check ASN CSV Upload     1_success.xlsx       ${rand_client_name}     Asn Items Upload
    wait until page contains       Asn Items Upload
    show buttons in bulk form           Valid 2    Invalid 0    All 2
    click element                  css=button.close > span
    click element                  name=_save
    wait until page contains       The asn items upload "${save_item_csv}" was changed successfully
    show in table                  ${save_item_csv}        ${rand_client_name}         Download           Saved



######## SO

TC700 - Create Shipping option (empty fields)
     Go To                     ${ADMIN}
     Mouse over and Click          Customers                  /admin-backend/preferences/clientshippingoption/
     wait until page contains             Select client shipping option to change
     click element                 xpath=//a[contains(.,"Add client shipping option")]
     wait until page contains          Add client shipping option
     click button                  name=_save
     wait error this is required (Admin)                Client              This field is required

TC697 - Create Shipping option
    ${ship_op}=                        Get Rand ID            ${shipping_name}
    log to console                     ${ship_op}
    set suite variable                  ${ship_op_edit}                         ${ship_op}
    Go To                           ${ADMIN}preferences/clientshippingoption/add/
    wait until page contains          Add client shipping option
    Select Fields Country SO            United States of America
    input text                       name=shipping_option                  ${ship_op_edit}
    Select Fields (Client, Courier) SO          select2-id_client-container           ${rand_client_name}
    Select Fields (Client, Courier) SO          select2-id_courier_service-container                       WMP YAMATO
    click element                  name=_save
    wait until page contains             The client shipping option "${rand_client_name} - ${ship_op_edit}" was added successfully

TC702 - Search
    Go To                           ${ADMIN}preferences/clientshippingoption/
    Check Item in Search       ${ship_op_edit}
    show in table             ${ship_op_edit}       ${rand_client_name}           WMP YAMATO      United States of America
    Open Check Order          ${ship_op_edit}

TC701 - Edit Shipping option
    wait until page contains               Change client shipping option
    Select Fields (Client, Courier) SO          select2-id_client-container           ${rand_client_name}
    Select Fields Country SO            Australia
    click element                  name=_save
    wait until page contains             The client shipping option "${rand_client_name} - ${ship_op_edit}" was changed successfully

TC703 - Filters
    Go To                           ${ADMIN}preferences/clientshippingoption/
    Check Filter                1      WMP YAMATO
    wait until page contains element      xpath=//tr[contains(@class,"row") and contains(.,"${ship_op_edit}")]
    go back
    Check Filter                2      ${rand_client_name}
    show in table             ${ship_op_edit}      ${rand_client_name}           WMP YAMATO      United States of America

TC704 - Sorting
    Go To                           ${ADMIN}preferences/clientshippingoption/
    Sorting                          Shipping option
    wait until page contains element      xpath=//tr[@class="row1"]
    Sorting                           Client
    wait until page contains element      xpath=//tr[@class="row1"]

TC705 - Bulk actions
    Go To                           ${ADMIN}preferences/clientshippingoption/
    Delete user                     Delete selected client shipping options
    wait until page contains        Successfully deleted 1 client shipping option
    Go To                           ${ADMIN}preferences/clientshippingoption/
    Check Item in Search            ${ship_op_edit}
    wait until page contains        0 client shipping options



### SO Upload Item

TC706 - Create client shipping option uploads (empty fields)
     Go To                     ${ADMIN}
     Mouse over and Click          Customers                  /admin-backend/preferences/clientshippingoptionupload/
     wait until page contains             Select client shipping option upload to change
     click element                 xpath=//a[contains(.,"Add client shipping option upload")]
     wait until page contains          Add client shipping option upload
     click button                  name=_save
     wait error this is required (Admin)                Client              This field is required

TC710 - Client shipping option uploads: empty file
    Check SO CSV Upload       2_empty.xlsx       ${rand_client_name}       The file is empty
TC711 - Client shipping option uploads: missing 1 column (Courier Service)
    Check SO CSV Upload       3_missing_1_column.xlsx       ${rand_client_name}       Missing_headers: ['Courier Service']
TC712 - Client shipping option uploads: missing 1 column (Shipping Option)
    Check SO CSV Upload       3.1_missing_2_column.xlsx       ${rand_client_name}       Missing_headers: ['Shipping Option']
TC713 - Client shipping option uploads: missing 3 column (Countries)
    Check SO CSV Upload       3.2_missing_3_column.xlsx       ${rand_client_name}       Missing_headers: ['Countries']
TC714 - Client shipping option uploads: file with invalid data
   Check SO CSV Upload   4_invalid_data.xlsx      ${rand_client_name}     Client Shipping Option Upload
    wait until page contains       Client Shipping Option Upload
    show buttons in bulk form           Valid 0    Invalid 1    All 1
    click element                  css=button.close > span
    wait until page does not contain element         name=_fsmtransition-status-save_

TC1065 - Client shipping option uploads: missing row
   Check SO CSV Upload   5_missing_fields.xlsx      ${rand_client_name}     Client Shipping Option Upload
    wait until page contains       Client Shipping Option Upload
    show buttons in bulk form           Valid 2    Invalid 1    All 3
    click element                  css=button.close > span
    wait until page does not contain element         name=_fsmtransition-status-save_

TC707 - Client shipping option uploads: successful upload
    Check SO CSV Upload     1_success.xlsx       ${rand_client_name}     Client Shipping Option Upload
    wait until page contains       Client Shipping Option Upload
    show buttons in bulk form           Valid 3    Invalid 0    All 3
    click element                  css=button.close > span
    wait element and click         name=_fsmtransition-status-save_
    wait until page contains       The client shipping option upload "${save_item_csv}" was changed successfully.
    set suite variable             ${check_item}           ${save_item_csv}
    show in table                  ${check_item}        ${rand_client_name}         Download           Sav

TC716 - Sorting
    Go To                  ${ADMIN}preferences/clientshippingoptionupload/
    wait until page contains          Select client shipping option upload to change
    Sorting                   Status
    wait until page contains element             xpath=//tr[contains(@class,"row") and contains(.,"Invalid")]

TC717 - Bulk actions
    Go To                  ${ADMIN}preferences/clientshippingoptionupload/
    Delete user                     Delete selected client shipping option uploads
    wait until page contains        Successfully deleted 1 client shipping option upload


#### 3PL

TC718 - Create 3PL (empty fields)
     Go To                     ${ADMIN}
     Mouse over and Click           Miscellaneous                  /admin-backend/floship/threepl/
     wait until page contains             Select 3PL to change
     click element                 xpath=//a[contains(.,"Add 3PL")]
     wait until page contains          Add 3PL
     click button                  name=_save
     wait error this is required (Admin)               Name              This field is required

TC720 - Edit 3PL
    ${test_3pl}=              Get Rand ID                  ${3pl_rand}
    Go To                     ${ADMIN}floship/threepl/
    wait element and click         xpath=//a[contains(.,"3PL_")]
    wait until page contains    Change 3PL
    input text                        id=id_name               ${test_3pl}
    click element                 name=_save
    wait until page contains element          xpath=//a[contains(.,"${test_3pl}")]


### Courier

TC722 - Create courier (empty fields)
     Go To                     ${ADMIN}
     Mouse over and Click           Miscellaneous                  /admin-backend/couriers/courier/
     wait until page contains            Select courier to change
     click element                 xpath=//a[contains(.,"Add courier")]
     wait until page contains          Add courier
     click button                  name=_save
     wait error this is required (Admin)              Display name              This field is required
     wait error this is required (Admin)              Courier type              This field is required
     wait error this is required (Admin)              Tracking url              This field is required

TC724 - Search
    ${test_courier}=              Get Rand ID         ${couirier_rand}
    set suite variable         ${edit_courier}        ${test_courier}
    Go To                     ${ADMIN}couriers/courier/
    Check Item in Search        Courier
    Open Check Order            Courier

TC720 - Edit 3PL
    wait until page contains    Change courier
    input text                        id=id_display_name               Courier${edit_courier}
    click element                 name=_save
    wait until page contains       The courier "Courier${edit_courier}" was changed successfully.
    wait until page contains element          xpath=//a[contains(.,"Courier${edit_courier}")]

TC726 - Filters
    Go to                               ${ADMIN}couriers/courier/
    Check Filter                2      Express Courier
    wait until page contains element    xpath=//tr[contains(@class,"row") and contains(.,"Express Courier")]
    Check Filter                1       No
    wait until page contains element    xpath=//img[@alt="False"]




#### Sales Order

TC1064 - Click on "Add Order" button
    [Tags]                             AdminSearch
    ${id_order_admin}                           Get Rand ID              ${order_id}
    log to console                         ${id_order_admin}
    set suite variable                      ${order_admin_id}             ${id_order_admin}
    Go to                               ${ADMIN}orders/salesorder/
    wait element and click              ${add}

    ## Check all checks to the order's page

    show status order               Tracking Number              N/A
    show status order               Source              N/A
    show status order               Courier              N/A
    show status order               Status              N/A
    check fields in order (item)            SKU
    check fields in order (item)            Unit Type
    check fields in order (item)            Unit Qty
    check fields in order (item)            Description
    check fields in order (item)            Customs Value
    check fields in order (item)            Qty
    check fields in order (item)            Total Qty
    check fields in order (item)            Stock

    check labels order                      Company
    check labels order                      Full Name *
    check labels order                      Address Line 1 *
    check labels order                      Address Line 2
    check labels order                      City *
    check labels order                      State/Province
    check labels order                      Postal Code *
    check labels order                      Country *
    check labels order                     Phone Number *
    check labels order                      Email
    check labels order                      Save to address book
    page should contain element              xpath=//a[contains(.,"Address Book")]
    check labels order                      Order ID *
    check labels order                      Insurance Value
    check labels order                      Courier *
    check labels order                      Client *

    check labels order                      Shipping Exceptions
    check labels order                      ThreePL Exceptions
    check labels order                      Reason Of Export
    check labels order                      Status Notes

    check labels order                      Pick pack cost
    check labels order                      Actual cost
    check labels order                      Estimated cost
    check labels order                      Fuel surcharge
    check labels order                      Actual weight


TC757 - Add Sales Order (empty fields)
    Save
    wait error this is required       order     shipping_address.addressee                              This field is required
    wait error this is required       order     shipping_address.address_1                              This field is required
    wait error this is required       order     shipping_address.city                              This field is required
    wait error this is required       order     shipping_address.postal_code                              This field is required
    wait error this is required       order     shipping_address.country                              This field is required
    wait error this is required       order     shipping_address.phone                              This field is required
    wait error this is required       order     client_po                              This field is required
    wait error this is required       order     ship_via_id                              This field is required
    wait until page contains element   xpath=//*[@ng-model="order.client_id"]/..//li[contains(.,"This field is required")]

TC734 - Add Sales Order with Base Item (out of stock)
    [Tags]                           OrderAdmin
    reload page
    Create Sales Order             ${phone}   ${country}         ${order_admin_id}  WMP YAMATO    ${rand_client_name}    	${search_sku}    ${search_sku}   Base Item
    input text           ${city_field_order}                New York
    click button                      Save
    wait until page contains             Order Saved Successfully
    Sleep                               30 sec
    Go To                                ${ADMIN}orders/salesorder/
    show in table                       ${order_admin_id}          WMP YAMATO        Sent to 3PL        ${rand_client_name}
    ${get_fs_order}=                      Get Smt
    set suite variable                 ${get_fs}           ${get_fs_order}


TC758 - Edit Sales Order
   Go To                                 ${ADMIN}orders/salesorder/
   Search and Click Item                        ${order_admin_id}
   Edit Order Admin                           ${order_admin_id}       Other
   wait element and click             xpath=//button[contains(.,"Save")]
   Sleep                                10 sec
   Go To                                ${ADMIN}orders/salesorder/
   wait until page contains             Select sales order to change
   Go To                                ${ADMIN}orders/salesorder/
   Check Item in Search                ${order_admin_id}
   show in table                    ${order_admin_id}         WMP YAMATO       Sent to 3PL         Other


TC765 - Search
   Go To                                 ${ADMIN}orders/salesorder/
   Check Item in Search                ${order_admin_id}
   Show Product                        ${get_fs}        ${order_admin_id}
   Check Item in Search                ${get_fs}
   Show Product                        ${get_fs}        ${order_admin_id}


TC767 - Filters
    Go to                              ${ADMIN}orders/salesorder/
    Check Filter                1      ${country}
    wait until page contains element    xpath=//*[@class="row1"]
    Check Filter                2      B2C
    wait until page contains element    xpath=//*[@class="row1"]
    Check Filter                4      Geodis
    wait until page contains element    xpath=//*[@class="row1"]
    Check Filter                6      Out of stock
    wait until page contains element    xpath=//*[@class="row1"]
#    Check Filter                9       ${rand_client_name}
#    wait until page contains element    xpath=//*[@class="row1"]

#TC766 - Sorting


TC768 - TC770 - Bulk action
    Go to                              ${ADMIN}orders/salesorder/
    Check Item in Search               ${order_admin_id}
    show in table                      ${order_admin_id}          ${get_fs}         ${rand_client_name}    Pending Fulfillment
    Actions Sales Order                Approve pending orders                Orders are successfully approved
    show in table                      ${order_admin_id}          ${get_fs}         ${rand_client_name}    Pending Fulfillment
    Actions Sales Order                Mark as "Sent to 3pl"                 Warehouse successfully notified
    show in table                      ${order_admin_id}        ${get_fs}          ${rand_client_name}        Sent to 3PL
    Actions Sales Order                Regenerate orders                 1 orders are successfully regenerated
    show in table                      ${order_admin_id}     ${get_fs}       Generating shipping labels         ${rand_client_name}
    Actions Sales Order                Cancel orders                    1 orders are successfully canceled
    show in table                      ${order_admin_id}    ${get_fs}     Canceled         ${rand_client_name}
    #Actions Sales Order                Send warehouse documents                 1 orders are successfully regenerated

TC955 - Order bulk upload (empty fields)
    Go to                              ${ADMIN}
    wait until page contains           Dashboard
    mouse over and click               Orders                          /admin-backend/orders/ordercsvupload/
    wait until page contains           Select order csv upload to change
    Add report                     Add order csv upload            Add order csv upload
    wait element and click         xpath=//input[contains(@name,"_save")]
    wait until page contains        Please correct the error below
    wait error this is required (Admin)           Client              This field is required

TC776 - Order bulk upload: empty file
    Check Order CSV Upload        2_empty.xlsx       ${rand_client_name}       The file is empty

TC777 - Order bulk upload: missing 1 column (OrderID)
    Check Order CSV Upload     3_missing_1_column.xlsx       ${rand_client_name}    Missing_headers: ['OrderID']

TC778 - Order bulk upload: missing column (Insurance Value)
    Check Order CSV Upload    3_missing_2_column.xlsx      ${rand_client_name}    Missing_headers: ['Insurance Value (in USD)']

TC779 - Order bulk upload: missing column (Company)
    Check Order CSV Upload     3_missing_3_column.xlsx       ${rand_client_name}    Missing_headers: ['Company']

TC780 - Order bulk upload: missing column (Contact Name)
    Check Order CSV Upload    3_missing_4_column.xlsx      ${rand_client_name}    Missing_headers: ['Contact Name']

TC781 - Order bulk upload: missing column (Address 1)
    Check Order CSV Upload     3_missing_5_column.xlsx       ${rand_client_name}    Missing_headers: ['Address 1']

TC782 - Order bulk upload: missing column (Address 2)
    Check Order CSV Upload    3_missing_6_column.xlsx      ${rand_client_name}    Missing_headers: ['Address 2']


TC783 - Order bulk upload: missing column (City)
    Check Order CSV Upload     3_missing_7_column.xlsx       ${rand_client_name}    Missing_headers: ['City']

TC784 - Order bulk upload: missing column (State)
    Check Order CSV Upload    3_missing_8_column.xlsx      ${rand_client_name}    Missing_headers: ['State']


TC785 - Order bulk upload: missing column (Zip Code)
    Check Order CSV Upload     3_missing_9_column.xlsx       ${rand_client_name}    Missing_headers: ['Zip Code']

TC786 - Order bulk upload: missing column (Country Code* (2-letter))
    Check Order CSV Upload    3_missing_10_column.xlsx      ${rand_client_name}    Missing_headers: ['Country Code (2-letter)']

TC787 - Order bulk upload: missing column (Phone)
    Check Order CSV Upload     3_missing_11_column.xlsx       ${rand_client_name}   Missing_headers: ['Phone']

TC788 - Order bulk upload: missing column (Email)
    Check Order CSV Upload    3_missing_12_column.xlsx      ${rand_client_name}    Missing_headers: ['Email']

TC789 - Order bulk upload: missing column (Unit Value (in USD))
    Check Order CSV Upload     3_missing_13_column.xlsx       ${rand_client_name}    Missing_headers: ['Unit Value (in USD)']

TC790 - Order bulk upload: missing column (Shipping Option)
    Check Order CSV Upload    3_missing_14_column.xlsx      ${rand_client_name}    Missing_headers: ['Shipping Option']

TC791 - Order bulk upload: missing column (Quantity)
    Check Order CSV Upload     3_missing_15_column.xlsx       ${rand_client_name}    Missing_headers: ['Quantity']

TC792 - Order bulk upload: missing column (Item SKU)
    Check Order CSV Upload    3_missing_16_column.xlsx      ${rand_client_name}    Missing_headers: ['Item SKU']

TC793 - Order bulk upload: missing column (Packaging Item)
    Check Order CSV Upload     3_missing_17_column.xlsx       ${rand_client_name}    Missing_headers: ['Packaging Item']

TC794 - Order bulk upload: file with invalid data
    Check Order CSV Upload   4_invalid_data.xlsx       ${rand_client_name}      Order Csv Upload
    wait until page contains       Order Csv Upload
    show buttons in bulk form           Valid 0    Invalid 1    All 1
    click element                  css=button.close > span
    wait until page does not contain element         xpath=//input[contains(@value,"Save Items Item Csv Upload")]

Check "Order CSV Upload" (Delete Item)
    wait element and click               xpath=//a[contains(.,"Delete")]
    wait until page contains          Are you sure you want to delete the order csv upload
    wait element and click            xpath=//input[contains(@value,"Yes, I'm sure")]
    wait until page contains          The order csv upload

TC796 - Order bulk upload: missed fields
    Check Order CSV Upload    5_missing_fields.xlsx       ${rand_client_name}     Order Csv Upload
    wait until page contains       Order Csv Upload
    show buttons in bulk form           Valid 1    Invalid 1    All 2
    click element                  css=button.close > span
    wait until page does not contain element         xpath=//input[contains(@value,"Save Items Order Csv Upload")]

TC771 - Order bulk upload: successful upload
    Check Order CSV Upload         1_success.xlsx       ${rand_client_name}     Order Csv Upload
    wait until page contains       Order Csv Upload
    show buttons in bulk form           Valid 2    Invalid 0    All 2
    wait element and click                  css=button.close > span
    Sleep                          2 sec
    wait until page contains element    name=_save
    click button                    name=_save
    wait until page contains       The order csv upload "${save_item_csv}" was changed successfully
    show in table                  ${save_item_csv}       ${rand_client_name}         Download           Valid
    Logout Client
