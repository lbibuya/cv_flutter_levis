import os
from pathlib import Path

from dotenv import load_dotenv

load_dotenv(Path(__file__).with_name(".env"))

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    
    "postgresql://postgres.lyirchzfkkgonxmhgowl:moilevis1008@aws-1-eu-west-1.pooler.supaba",
)
SECRET_KEY = os.getenv("SECRET_KEY", "cle-de-test-a-remplacer-avant-deploiement")
JWT_EXPIRATION_HOURS = 24
