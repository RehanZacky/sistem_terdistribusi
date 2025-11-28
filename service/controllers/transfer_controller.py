from datetime import datetime
from decimal import Decimal

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import exc
from sqlalchemy.orm import Session

from ..config.database import get_db
from ..models.m_portfolio_account import MPortfolioAccount
from ..models.t_transaction import TTransaction

transfer_router = APIRouter()

# ------------------------------------------------------
# TRANSFER LOKAL (debit + kredit)
# ------------------------------------------------------
@transfer_router.post("/local")
def transfer_local(payload: dict, db: Session = Depends(get_db)):
    from_acc = payload.get("from_account")
    to_acc = payload.get("to_account")
    amount = payload.get("amount")
    customer_id = payload.get("customer_id")  # untuk histori dan validasi ownership
    description = payload.get("description", "Local Transfer")

    if not from_acc or not to_acc or amount is None:
        raise HTTPException(status_code=400, detail="Missing required fields")
    
    if not customer_id:
        raise HTTPException(status_code=400, detail="Customer ID is required for security")

    if from_acc == to_acc:
        raise HTTPException(status_code=400, detail="Cannot transfer to the same account")

    amount = Decimal(amount)

    try:
        # START DB TRANSACTION
        # --------------------------------------------------

        # Ambil akun asal
        from_account = db.query(MPortfolioAccount).filter(
            MPortfolioAccount.account_number == from_acc
        ).with_for_update().first()  # LOCK ROW

        if not from_account:
            raise HTTPException(status_code=404, detail="Source account not found")
        
        # SECURITY: Validasi bahwa akun sumber adalah milik customer yang login
        if from_account.m_customer_id != customer_id:
            raise HTTPException(
                status_code=403, 
                detail="Unauthorized: You can only transfer from your own accounts"
            )

        # Ambil akun tujuan
        to_account = db.query(MPortfolioAccount).filter(
            MPortfolioAccount.account_number == to_acc
        ).with_for_update().first()  # LOCK ROW

        if not to_account:
            raise HTTPException(status_code=404, detail="Destination account not found")

        # Validasi saldo
        if from_account.available_balance < amount:
            raise HTTPException(status_code=400, detail="Insufficient balance")

        # DEBIT sumber
        from_account.available_balance -= amount
        from_account.clear_balance = from_account.available_balance

        # CREDIT tujuan
        to_account.available_balance += amount
        to_account.clear_balance = to_account.available_balance

        # Catat transaksi di t_transaction
        trx = TTransaction(
            m_customer_id = customer_id,
            transaction_type = "TR",
            transaction_amount = amount,
            from_account_number = from_acc,
            to_account_number = to_acc,
            description = description,
            status = "SUCCESS",
            transaction_date = datetime.now(),
            transmission_date = datetime.now(),
            value_date = datetime.now(),
            created = datetime.now()
        )

        db.add(trx)

        # Commit transaksi
        db.commit()
        db.refresh(trx)

        # END DB TRANSACTION
        # --------------------------------------------------

        return {
            "status": "success",
            "message": "Local transfer successful",
            "transaction_id": trx.id,
            "from_account": from_acc,
            "to_account": to_acc,
            "amount": float(amount)
        }

    except exc.SQLAlchemyError as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"DB Error: {str(e)}")

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    