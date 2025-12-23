"""
Database Setup Script (SQLite Version)
Membuat database SQLite dan mengisi data dummy untuk testing
Tidak perlu PostgreSQL - cocok untuk development dan testing
"""

import os
from datetime import datetime
from decimal import Decimal

# Import models
from models.m_customer import Base as CustomerBase
from models.m_customer import MCustomer
from models.m_portfolio_account import Base as AccountBase
from models.m_portfolio_account import MPortfolioAccount
from models.t_transaction import Base as TransactionBase
from models.t_transaction import TTransaction
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# SQLite database file
DB_FILE = "ebanking.db"
DATABASE_URL = f"sqlite:///{DB_FILE}"

def create_tables():
    """Create all tables"""
    engine = create_engine(DATABASE_URL, echo=False)
    
    # Create tables from all models
    CustomerBase.metadata.create_all(engine)
    AccountBase.metadata.create_all(engine)
    TransactionBase.metadata.create_all(engine)
    
    print("✅ All tables created successfully")
    engine.dispose()
    return engine

def insert_dummy_data():
    """Insert dummy data for testing"""
    engine = create_engine(DATABASE_URL, echo=False)
    SessionLocal = sessionmaker(bind=engine)
    db = SessionLocal()
    
    try:
        # Check if data already exists
        existing_customer = db.query(MCustomer).first()
        if existing_customer:
            print("ℹ️  Data already exists, skipping insertion")
            
            # Show existing data
            customers = db.query(MCustomer).all()
            accounts = db.query(MPortfolioAccount).all()
            
            print("\n" + "="*60)
            print("📋 Existing Test Accounts:")
            print("-" * 60)
            for customer in customers:
                print(f"\n👤 Customer: {customer.customer_name}")
                print(f"   Username: {customer.customer_username}")
                print(f"   PIN: {customer.customer_pin}")
                print(f"   Customer ID: {customer.id}")
                
                # Get accounts for this customer
                customer_accounts = [acc for acc in accounts if acc.m_customer_id == customer.id]
                for acc in customer_accounts:
                    print(f"   💳 Account: {acc.account_number} ({acc.account_name}) - Rp {acc.available_balance:,.2f}")
            
            print("\n" + "="*60)
            return
        
        # 1. Create customers
        print("📝 Creating customers...")
        customers = [
            MCustomer(
                customer_name="Budi Santoso",
                customer_username="budi",
                customer_pin="123456",  # Plain text for demo (should be hashed in production)
                customer_phone="081234567890",
                customer_email="budi@example.com",
                cif_number="CIF001",
                ib_status="A",
                mb_status="A",
                failed_login_attempts=0
            ),
            MCustomer(
                customer_name="Siti Aminah",
                customer_username="siti",
                customer_pin="654321",
                customer_phone="081234567891",
                customer_email="siti@example.com",
                cif_number="CIF002",
                ib_status="A",
                mb_status="A",
                failed_login_attempts=0
            ),
            MCustomer(
                customer_name="Ahmad Rizki",
                customer_username="ahmad",
                customer_pin="111222",
                customer_phone="081234567892",
                customer_email="ahmad@example.com",
                cif_number="CIF003",
                ib_status="A",
                mb_status="A",
                failed_login_attempts=0
            )
        ]
        
        for customer in customers:
            db.add(customer)
        
        db.commit()
        print(f"✅ Created {len(customers)} customers")
        
        # Refresh to get IDs
        for customer in customers:
            db.refresh(customer)
        
        # 2. Create accounts for each customer
        print("📝 Creating accounts...")
        accounts = [
            # Budi's accounts (Tabungan + Giro)
            MPortfolioAccount(
                m_customer_id=customers[0].id,
                account_number="1001234567",
                account_status="A",
                account_name="Tabungan Budi",
                account_type="SA",
                product_code="SAV001",
                product_name="Tabungan Reguler",
                currency_code="IDR",
                branch_code="JKT01",
                plafond=Decimal("0"),
                clear_balance=Decimal("5000000.00"),
                available_balance=Decimal("5000000.00"),
                confidential="N"
            ),
            MPortfolioAccount(
                m_customer_id=customers[0].id,
                account_number="1001234568",
                account_status="A",
                account_name="Giro Budi",
                account_type="CA",
                product_code="GIR001",
                product_name="Giro Bisnis",
                currency_code="IDR",
                branch_code="JKT01",
                plafond=Decimal("0"),
                clear_balance=Decimal("10000000.00"),
                available_balance=Decimal("10000000.00"),
                confidential="N"
            ),
            # Siti's accounts (Tabungan + Giro)
            MPortfolioAccount(
                m_customer_id=customers[1].id,
                account_number="2001234567",
                account_status="A",
                account_name="Tabungan Siti",
                account_type="SA",
                product_code="SAV001",
                product_name="Tabungan Reguler",
                currency_code="IDR",
                branch_code="BDG01",
                plafond=Decimal("0"),
                clear_balance=Decimal("7500000.00"),
                available_balance=Decimal("7500000.00"),
                confidential="N"
            ),
            MPortfolioAccount(
                m_customer_id=customers[1].id,
                account_number="2001234568",
                account_status="A",
                account_name="Giro Siti",
                account_type="CA",
                product_code="GIR001",
                product_name="Giro Bisnis",
                currency_code="IDR",
                branch_code="BDG01",
                plafond=Decimal("0"),
                clear_balance=Decimal("8000000.00"),
                available_balance=Decimal("8000000.00"),
                confidential="N"
            ),
            # Ahmad's accounts (Tabungan + Giro)
            MPortfolioAccount(
                m_customer_id=customers[2].id,
                account_number="3001234567",
                account_status="A",
                account_name="Tabungan Ahmad",
                account_type="SA",
                product_code="SAV001",
                product_name="Tabungan Reguler",
                currency_code="IDR",
                branch_code="SBY01",
                plafond=Decimal("0"),
                clear_balance=Decimal("3000000.00"),
                available_balance=Decimal("3000000.00"),
                confidential="N"
            ),
            MPortfolioAccount(
                m_customer_id=customers[2].id,
                account_number="3001234568",
                account_status="A",
                account_name="Giro Ahmad",
                account_type="CA",
                product_code="GIR001",
                product_name="Giro Bisnis",
                currency_code="IDR",
                branch_code="SBY01",
                plafond=Decimal("0"),
                clear_balance=Decimal("4000000.00"),
                available_balance=Decimal("4000000.00"),
                confidential="N"
            )
        ]
        
        for account in accounts:
            db.add(account)
        
        db.commit()
        print(f"✅ Created {len(accounts)} accounts")
        
        # 3. Create sample transactions
        print("📝 Creating sample transactions...")
        transactions = [
            TTransaction(
                m_customer_id=customers[0].id,
                transaction_type="TR",
                transaction_amount=Decimal("100000.00"),
                from_account_number="1001234567",
                to_account_number="2001234567",
                description="Transfer ke Siti",
                status="SUCCESS",
                transaction_date=datetime.now(),
                transmission_date=datetime.now(),
                value_date=datetime.now()
            ),
            TTransaction(
                m_customer_id=customers[1].id,
                transaction_type="DP",
                transaction_amount=Decimal("500000.00"),
                to_account_number="2001234567",
                description="Setoran Tunai",
                status="SUCCESS",
                transaction_date=datetime.now(),
                transmission_date=datetime.now(),
                value_date=datetime.now()
            )
        ]
        
        for trx in transactions:
            db.add(trx)
        
        db.commit()
        print(f"✅ Created {len(transactions)} sample transactions")
        
        print("\n" + "="*60)
        print("✅ DATABASE SETUP COMPLETED!")
        print("="*60)
        print(f"\n📁 Database file: {os.path.abspath(DB_FILE)}")
        print("\n📋 Test Accounts:")
        print("-" * 60)
        for i, customer in enumerate(customers):
            print(f"\n{i+1}. 👤 Customer: {customer.customer_name}")
            print(f"   Username: {customer.customer_username}")
            print(f"   PIN: {customer.customer_pin}")
            print(f"   Customer ID: {customer.id}")
            
            # Get accounts for this customer
            customer_accounts = [acc for acc in accounts if acc.m_customer_id == customer.id]
            for acc in customer_accounts:
                print(f"   💳 Account: {acc.account_number} ({acc.account_name}) - Rp {acc.available_balance:,.2f}")
        
        print("\n" + "="*60)
        print("🚀 You can now login to the mobile app!")
        print("="*60 + "\n")
        
    except Exception as e:
        db.rollback()
        print(f"❌ Error inserting dummy data: {e}")
        raise
    finally:
        db.close()
        engine.dispose()

def main():
    print("🔧 Starting SQLite Database Setup...")
    print("="*60)
    print("ℹ️  Using SQLite (no PostgreSQL needed)")
    print("="*60)
    
    try:
        # Step 1: Create tables
        print("\n1️⃣  Creating tables...")
        create_tables()
        
        # Step 2: Insert dummy data
        print("\n2️⃣  Inserting dummy data...")
        insert_dummy_data()
        
    except Exception as e:
        print(f"\n❌ Setup failed: {e}")
        import traceback
        traceback.print_exc()
        exit(1)

if __name__ == "__main__":
    main()
