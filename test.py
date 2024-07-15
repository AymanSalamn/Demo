from dotenv import load_dotenv
import os

# Load .env file
load_dotenv()

# Access environment variables
my_secret_key = os.getenv('MY_SECRET_KEY')

print(f'My Secret Key: {my_secret_key}')
