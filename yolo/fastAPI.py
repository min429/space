from fastapi import FastAPI

# FastAPI 인스턴스 생성
app = FastAPI()

# / 경로에 대한 핸들러 정의
@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

# 실행 명령어 uvicorn main:app --reload