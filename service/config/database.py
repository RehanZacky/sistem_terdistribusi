import os
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError

# -----------------------------------------------------
# Database Configuration
# -----------------------------------------------------

# Use SQLite for development (easy setup, no PostgreSQL needed)
# For production, switch to PostgreSQL by setting USE_SQLITE=false
USE_SQLITE = os.getenv("USE_SQLITE", "true").lower() == "true"

if USE_SQLITE:
    # SQLite Configuration
    DB_FILE = os.getenv("DB_FILE", "ebanking.db")
    DATABASE_URL = f"sqlite:///{DB_FILE}"
else:
    # PostgreSQL Configuration
    DB_USER = os.getenv("DB_USER", "postgres")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "postgres")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = os.getenv("DB_PORT", "5432")
    DB_NAME = os.getenv("DB_NAME", "ebanking")
    DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# -----------------------------------------------------
# SQLAlchemy Engine + Connection Pool
# -----------------------------------------------------
if USE_SQLITE:
    # SQLite doesn't support connection pooling the same way
    engine = create_engine(
        DATABASE_URL,
        connect_args={"check_same_thread": False},  # Allow multi-threaded access
        echo=False
    )
else:
    # PostgreSQL with connection pooling
    engine = create_engine(
        DATABASE_URL,
        pool_size=10,
        max_overflow=20,
        pool_pre_ping=True,
        pool_recycle=1800,  # recycle connection every 30 min
    )

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# -----------------------------------------------------
# DB Initialization
# -----------------------------------------------------
def init_db():
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        print("Database connected: OK")
    except SQLAlchemyError as e:
        print("Database connection failed:", e)
        raise e

# -----------------------------------------------------
# Dependency for DB session (used in controllers)
# -----------------------------------------------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
