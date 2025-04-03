from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes.login import router as login_router


app = FastAPI()

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])


@app.get("/")
def read_root():
    return {"Katamoto ate the frutu hm yam yam hm yam yam"}

# Include login routes
app.include_router(login_router)