import requests

header = '''
Check Hunter.io balance
------------------------------------'''
print(header)

#paste in your api key
api_key=""

json_data = requests.get('https://api.hunter.io/v2/account?api_key=' + api_key).json()

firstName = json_data['data']['first_name']
lastName = json_data['data']['last_name']
emailAddress = json_data['data']['email']
requestsAvailable = json_data['data']['calls']['available']
requestsUsed = json_data['data']['calls']['used']
resetDate = json_data['data']['reset_date']
planType = json_data['data']['plan_name']

print('Name:			' + firstName + " " + lastName)
print('Account:		' + emailAddress)
print('Account Type:		' + planType)
print('Requests Remaining:	' + str(requestsAvailable))
print('Requests Used:		' + str(requestsUsed))
print('Reset Date:		' + resetDate)
