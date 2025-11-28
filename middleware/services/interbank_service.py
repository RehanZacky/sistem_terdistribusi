import httpx

from ..config.settings import BANK_LAIN_ENDPOINT, SERVICE_CALLBACK_URL
from ..utils.http_client import post_json


async def process_interbank_transfer(payload):

    # 1. Kirim dana ke bank lain
    bank_response = await post_json(BANK_LAIN_ENDPOINT, payload)

    status = "SUCCESS" if bank_response.get("status") == "OK" else "FAILED"

    # 2. Beri tahu SERVICE tentang hasil transaksi
    callback_data = {
        "transaction_id": payload.get("transaction_id"),
        "new_status": status
    }

    async with httpx.AsyncClient() as client:
        await client.post(SERVICE_CALLBACK_URL, json=callback_data)

    return {
        "status": "sent",
        "bank_response": bank_response
    }
