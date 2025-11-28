from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .controllers.interbank_controller import interbank_router

app = FastAPI(
    title="Middleware Interbank API",
    description="Middleware untuk komunikasi antar bank",
    version="1.0.0"
)

# Izinkan komunikasi dari SERVICE
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(
    interbank_router,
    prefix="/interbank",
    tags=["Interbank Middleware"]
)

@app.get("/")
def root():
    return {"message": "Middleware Interbank Running"}
