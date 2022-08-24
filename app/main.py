################################################
#               API HANDLER
################################################

# RUN: uvicorn main:app --reload or poetry run uvicorn main:app --reload
# Open your browser at http://127.0.0.1:8000.
# Interactive API docs: http://127.0.0.1:8000/docs.

from typing import Union

import uvicorn
from fastapi import FastAPI, Request
from pydantic import BaseModel, Field

# Declare your data model as a class that inherits from BaseModel
class Interaction(BaseModel):
    # body -> application/JSON
    user_id: str = Field(example='id1234567')  # required
    item_id: str = Field(example='id1234567')  # required
    action: int = Field(example=4)  # required
    value: Union[float, None] = Field(default=None, example=3.2)  # float (optional)

app = FastAPI()

################################################
#               ENDPOINTS
################################################

@app.get("/")
async def root():
    return {"message": "Hello World! This message was sent from Kubernetes! This was updated automatically! V20"}

# Record a user/item interaction
@app.post("/interaction/")
async def interact(interation: Interaction, request: Request):
    # client's IP address/host
    client_host = request.client.host

    json = interation.dict()

    return json

# Get recommendations for a user
@app.get('/get/')
async def recommend(user_id: str, request: Request):
    # client's IP address/host
    client_host = request.client.host

    return {'user_id': user_id, 'client_host': client_host}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)