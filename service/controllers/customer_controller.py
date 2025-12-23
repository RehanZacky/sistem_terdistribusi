from config.database import get_db
from fastapi import APIRouter, Depends, HTTPException
from models.m_customer import MCustomer
from sqlalchemy.orm import Session

customer_router = APIRouter()

# ------------------------------------------------------
# INTERNAL: VERIFY LOGIN
# ------------------------------------------------------
@customer_router.post("/verify")
def verify_login(payload: dict, db: Session = Depends(get_db)):
    username = payload.get("username")
    pin = payload.get("pin")

    if not username or not pin:
        raise HTTPException(status_code=400, detail="Username and PIN are required")

    user = db.query(MCustomer).filter(
        MCustomer.customer_username == username
    ).first()

    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    # NOTE:
    # Pada sistem asli, PIN harus berupa hash.
    # Untuk simulasi ini kita anggap PIN disimpan langsung dalam kolom customer_pin.
    if str(user.customer_pin) != str(pin):
        raise HTTPException(status_code=401, detail="Invalid PIN")

    # sukses
    return {
        "status": "success",
        "user_id": user.id,
        "customer_name": user.customer_name,
        "message": "Login verified"
    }

# ------------------------------------------------------
# INTERNAL: GET CUSTOMER BY ID
# ------------------------------------------------------
@customer_router.get("/{customer_id}")
def get_customer(customer_id: int, db: Session = Depends(get_db)):
    customer = db.query(MCustomer).filter(
        MCustomer.id == customer_id
    ).first()

    if customer is None:
        raise HTTPException(status_code=404, detail="Customer not found")

    return {
        "status": "success",
        "data": {
            "id": customer.id,
            "name": customer.customer_name,
            "username": customer.customer_username,
            "phone": customer.customer_phone,
            "email": customer.customer_email,
            "cif_number": customer.cif_number,
            "ib_status": customer.ib_status,
            "mb_status": customer.mb_status
        }
    }

# ------------------------------------------------------
# OPTIONAL: GET ALL CUSTOMERS (DEBUG ONLY)
# ------------------------------------------------------
@customer_router.get("/")
def get_all_customers(db: Session = Depends(get_db)):
    users = db.query(MCustomer).all()

    data = []
    for u in users:
        data.append({
            "id": u.id,
            "name": u.customer_name,
            "username": u.customer_username,
            "phone": u.customer_phone
        })

    return {
        "status": "success",
        "count": len(data),
        "data": data
    }
