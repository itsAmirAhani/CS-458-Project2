from fastapi import FastAPI
from app.routes.login import router as login_router

app = FastAPI()

@app.get("/")
def read_root():
    return {"Katamoto ate the frutu hm yam yam hm yam yam"}

# Include login routes
app.include_router(login_router)