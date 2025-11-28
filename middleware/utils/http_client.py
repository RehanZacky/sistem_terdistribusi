import httpx

async def post_json(url, data):
    async with httpx.AsyncClient() as client:
        response = await client.post(url, json=data)
        return response.json()
