from decimal import Decimal

from config.database import get_db
from fastapi import APIRouter, Depends, HTTPException
from models.m_portfolio_account import MPortfolioAccount
from sqlalchemy.orm import Session

account_router = APIRouter()

# ------------------------------------------------------
# GET ALL ACCOUNTS FOR A CUSTOMER (ONLY GIRO/CA)
# ------------------------------------------------------
@account_router.get("/customer/{customer_id}")
def get_accounts_for_customer(customer_id: int, db: Session = Depends(get_db)):
    # Filter hanya rekening Giro (account_type='CA') untuk mobile banking
    accounts = db.query(MPortfolioAccount).filter(
        MPortfolioAccount.m_customer_id == customer_id,
        MPortfolioAccount.account_type == "CA"  # Only Current Account (Giro)
    ).all()

    if not accounts:
        raise HTTPException(status_code=404, detail="No giro accounts found")

    data = []
    for a in accounts:
        data.append({
            "account_id": a.id,
            "account_number": a.account_number,
            "account_name": a.account_name,
            "account_type": a.account_type,
            "currency": a.currency_code,
            "available_balance": float(a.available_balance or 0),
            "clear_balance": float(a.clear_balance or 0),
            "product_name": a.product_name
        })

    return {
        "status": "success",
        "accounts": data
    }

# ------------------------------------------------------
# GET BALANCE OF SPECIFIC ACCOUNT
# ------------------------------------------------------
@account_router.get("/balance/{account_number}")
def get_balance(account_number: str, db: Session = Depends(get_db)):
    account = db.query(MPortfolioAccount).filter(
        MPortfolioAccount.account_number == account_number
    ).first()

    if not account:
        raise HTTPException(status_code=404, detail="Account not found")

    return {
        "status": "success",
        "account_number": account.account_number,
        "available_balance": float(account.available_balance or 0),
        "clear_balance": float(account.clear_balance or 0)
    }

# ------------------------------------------------------
# DEBIT (reduce balance)
# ------------------------------------------------------
@account_router.post("/debit")
def debit_account(payload: dict, db: Session = Depends(get_db)):
    account_number = payload.get("account_number")
    amount = payload.get("amount")

    if not account_number or amount is None:
        raise HTTPException(status_code=400, detail="Account and amount required")

    account = db.query(MPortfolioAccount).filter(
        MPortfolioAccount.account_number == account_number
    ).first()

    if not account:
        raise HTTPException(status_code=404, detail="Account not found")

    amount = Decimal(amount)

    if account.available_balance is None:
        account.available_balance = Decimal(0)

    if account.available_balance < amount:
        raise HTTPException(status_code=400, detail="Insufficient balance")

    account.available_balance -= amount
    account.clear_balance = account.available_balance

    db.commit()

    return {
        "status": "success",
        "message": "Balance debited",
        "remaining_balance": float(account.available_balance)
    }

# ------------------------------------------------------
# CREDIT (add balance)
# ------------------------------------------------------
@account_router.post("/credit")
def credit_account(payload: dict, db: Session = Depends(get_db)):
    account_number = payload.get("account_number")
    amount = payload.get("amount")

    if not account_number or amount is None:
        raise HTTPException(status_code=400, detail="Account and amount required")

    account = db.query(MPortfolioAccount).filter(
        MPortfolioAccount.account_number == account_number
    ).first()

    if not account:
        raise HTTPException(status_code=404, detail="Account not found")

    amount = Decimal(amount)

    if account.available_balance is None:
        account.available_balance = Decimal(0)

    account.available_balance += amount
    account.clear_balance = account.available_balance

    db.commit()

    return {
        "status": "success",
        "message": "Balance credited",
        "new_balance": float(account.available_balance)
    }
