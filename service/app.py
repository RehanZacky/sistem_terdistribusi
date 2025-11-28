from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Import Routers
from .controllers.customer_controller import customer_router
from .controllers.account_controller import account_router
from .controllers.transaction_controller import transaction_router
from .controllers.transfer_controller import transfer_router

app = FastAPI(
    title="Service Layer API",
    description="Internal service for customer, account, and transaction operations",
    version="1.0.0"
)

# --------------------------------------------------
# OPTIONAL: CORS (supaya middleware bisa akses)
# --------------------------------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # bisa dipersempit jika perlu
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --------------------------------------------------
# REGISTER ROUTERS
# Semua endpoint berada di jalur /internal/
# --------------------------------------------------

app.include_router(
    customer_router,
    prefix="/internal/customer",
    tags=["Customer Service"],
)

app.include_router(
    account_router,
    prefix="/internal/account",
    tags=["Account Service"],
)

app.include_router(
    transaction_router,
    prefix="/internal/transaction",
    tags=["Transaction Service"],
)

app.include_router(
    transfer_router,
    prefix="/internal/transfer",
    tags=["Transfer Service"],
)

# --------------------------------------------------
# HEALTH CHECK
# --------------------------------------------------
@app.get("/")
def root():
    return {
        "message": "Service Layer API is running",
        "status": "OK"
    }
