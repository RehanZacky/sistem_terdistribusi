from fastapi import APIRouter, HTTPException

from ..services.interbank_service import process_interbank_transfer

interbank_router = APIRouter()

@interbank_router.post("/send")
async def send_to_other_bank(payload: dict):
    try:
        result = await process_interbank_transfer(payload)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
