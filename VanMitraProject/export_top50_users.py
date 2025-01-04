import pandas as pd

# Load the dataset from the provided file path
dataset_file_path = r"C:\Users\vardh\Downloads\van_mitra_sample_data.xlsx"
data = pd.read_excel(dataset_file_path)

# Print column names to verify the structure
print("Column names in the dataset:", data.columns)

# Check the first few rows of the dataset to understand its structure
print(data.head())

# Assuming that the dataset contains columns like 'User ID', 'Plants Planted', and 'Healthy Plants'
try:
    # Extract necessary columns and handle potential column name issues
    users = data[['User ID', 'Plants Planted', 'Healthy Plants']]

    # Calculate survival rate (Healthy Plants / Plants Planted)
    users['survivalRate'] = users['Healthy Plants'] / users['Plants Planted']

    # Calculate rankings based on survival rate (or other criteria)
    def calculateRankings(users):
        # Sort users based on survival rate in descending order
        users.sort_values(by='survivalRate', ascending=False, inplace=True)

        # Assign ranking based on sorted order
        users['ranking'] = range(1, len(users) + 1)

    # Function to export the top 50 users to JSON
    def exportTop50UsersToJSON():
        try:
            # Calculate rankings based on survival rate
            calculateRankings(users)

            # Get the top 50 users
            top50Users = users.head(50)

            # Prepare data for output with userID, plants planted, healthy plants, survival rate, and ranking
            top50Data = top50Users[['User ID', 'Plants Planted', 'Healthy Plants', 'survivalRate', 'ranking']]

            # Save the result to a new JSON file
            top50Data.to_json('top50Users.json', orient='records', lines=True)
            print('Top 50 users data has been saved to top50Users.json')
        except Exception as e:
            print(f"Error exporting data: {e}")

    # Run the function to export the top 50 users
    exportTop50UsersToJSON()

except KeyError as e:
    print(f"Missing column: {e}")
