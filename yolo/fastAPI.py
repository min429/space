from fastapi import FastAPI, BackgroundTasks
import asyncio
import redis

# FastAPI 앱 생성
app = FastAPI()


# Redis 클라이언트 생성 및 연결 시도
redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)

# Redis에서 seat:1 해시 필드의 isUsed 값을 1로 설정
redis_client.hset("seat:1", "isUsed", 1)
try:
    redis_client.ping()  # Redis 서버에 PING 전송
    print("Redis 서버에 연결되었습니다.")
except redis.ConnectionError:
    print("Redis 서버에 연결할 수 없습니다.")

# 백그라운드에서 주기적으로 실행될 함수
async def repeat_every(interval: int):
    while True:
        # 백그라운드에서 수행할 작업
        print("Background 작업 실행")

        await asyncio.sleep(interval)

# 앱이 시작될 때 실행될 이벤트 핸들러
@app.on_event("startup")
async def startup_event():
    # 백그라운드 태스크 생성
    background_tasks = BackgroundTasks()
    # 백그라운드 태스크에 주기적으로 실행할 함수 추가
    background_tasks.add_task(repeat_every, 10)

# "/" 엔드포인트에 대한 GET 요청 핸들러
@app.get("/")
async def read_root():
    # 응답으로 "Hello World" 메시지 반환
    return {"message": "Hello World"}

