from datetime import datetime
from decimal import Decimal

from config.database import get_db
from fastapi import APIRouter, Depends, HTTPException
from models.t_transaction import TTransaction
from sqlalchemy.orm import Session

transaction_router = APIRouter()

# ------------------------------------------------------
# CREATE NEW TRANSACTION (PENDING)
# ------------------------------------------------------
@transaction_router.post("/create")
def create_transaction(payload: dict, db: Session = Depends(get_db)):
    try:
        trx = TTransaction(
            m_customer_id = payload.get("m_customer_id"),
            mti = payload.get("mti"),
            transaction_type = payload.get("transaction_type"),
            card_number = payload.get("card_number"),
            transaction_amount = payload.get("transaction_amount"),
            fee_indicator = payload.get("fee_indicator"),
            fee = payload.get("fee"),
            transmission_date = datetime.now(),
            transaction_date = datetime.now(),
            value_date = datetime.now(),
            conversion_rate = payload.get("conversion_rate"),
            stan = payload.get("stan"),
            merchant_type = payload.get("merchant_type"),
            terminal_id = payload.get("terminal_id"),
            reference_number = payload.get("reference_number"),
            approval_number = payload.get("approval_number"),
            response_code = payload.get("response_code"),
            currency_code = payload.get("currency_code"),
            customer_reference = payload.get("customer_reference"),
            biller_name = payload.get("biller_name"),
            from_account_number = payload.get("from_account_number"),
            to_account_number = payload.get("to_account_number"),
            from_account_type = payload.get("from_account_type", "00"),
            to_account_type = payload.get("to_account_type", "00"),
            balance = payload.get("balance"),
            description = payload.get("description"),
            to_bank_code = payload.get("to_bank_code"),
            execution_type = payload.get("execution_type", "N"),
            status = "PENDING",
            translation_code = payload.get("translation_code"),
            free_data1 = payload.get("free_data1"),
            free_data2 = payload.get("free_data2"),
            free_data3 = payload.get("free_data3"),
            free_data4 = payload.get("free_data4"),
            free_data5 = payload.get("free_data5"),
            delivery_channel = payload.get("delivery_channel"),
            delivery_channel_id = payload.get("delivery_channel_id"),
            biller_id = payload.get("biller_id"),
            product_id = payload.get("product_id")
        )

        db.add(trx)
        db.commit()
        db.refresh(trx)

        return {
            "status": "success",
            "message": "Transaction created",
            "transaction_id": trx.id
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ------------------------------------------------------
# UPDATE TRANSACTION STATUS (SUCCESS / FAILED)
# ------------------------------------------------------
@transaction_router.post("/update-status")
def update_transaction_status(payload: dict, db: Session = Depends(get_db)):
    trx_id = payload.get("transaction_id")
    new_status = payload.get("new_status")

    if new_status not in ["SUCCESS", "FAILED"]:
        raise HTTPException(status_code=400, detail="Invalid status")

    trx = db.query(TTransaction).filter(
        TTransaction.id == trx_id
    ).first()

    if not trx:
        raise HTTPException(status_code=404, detail="Transaction not found")

    trx.status = new_status
    trx.updated = datetime.now()

    db.commit()

    return {
        "status": "success",
        "message": "Transaction updated",
        "transaction_id": trx.id,
        "new_status": new_status
    }

# ------------------------------------------------------
# GET HISTORY FOR A CUSTOMER
# ------------------------------------------------------
@transaction_router.get("/history/{customer_id}")
def get_transaction_history(customer_id: int, db: Session = Depends(get_db)):
    from models.m_portfolio_account import MPortfolioAccount

    # Get all account numbers for this customer
    customer_accounts = db.query(MPortfolioAccount).filter(
        MPortfolioAccount.m_customer_id == customer_id
    ).all()
    
    account_numbers = [acc.account_number for acc in customer_accounts]
    
    # Get transactions where customer is sender OR receiver
    history = db.query(TTransaction).filter(
        (TTransaction.m_customer_id == customer_id) | 
        (TTransaction.to_account_number.in_(account_numbers))
    ).order_by(TTransaction.created.desc()).all()

    data = []
    for trx in history:
        # Determine if this is incoming or outgoing transaction
        is_incoming = trx.to_account_number in account_numbers and trx.m_customer_id != customer_id
        
        data.append({
            "transaction_id": trx.id,
            "type": trx.transaction_type,
            "amount": float(trx.transaction_amount or 0),
            "from": trx.from_account_number,
            "to": trx.to_account_number,
            "status": trx.status,
            "date": trx.transaction_date,
            "direction": "IN" if is_incoming else "OUT"  # New field
        })

    return {
        "status": "success",
        "count": len(data),
        "history": data
    }

# ------------------------------------------------------
# GET TRANSACTION DETAILS
# ------------------------------------------------------
@transaction_router.get("/{transaction_id}")
def get_transaction_detail(transaction_id: int, db: Session = Depends(get_db)):
    trx = db.query(TTransaction).filter(
        TTransaction.id == transaction_id
    ).first()

    if not trx:
        raise HTTPException(status_code=404, detail="Transaction not found")

    return {
        "status": "success",
        "transaction": {
            "id": trx.id,
            "type": trx.transaction_type,
            "amount": float(trx.transaction_amount or 0),
            "from": trx.from_account_number,
            "to": trx.to_account_number,
            "status": trx.status,
            "detail": trx.description,
            "created": trx.created,
        }
    }
