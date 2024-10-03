import cv2
import torch
import time
import redis

# Redis 클라이언트 생성 및 연결 시도
redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)
try:
    redis_client.ping()  # Redis 서버에 PING 전송
    print("Redis 서버에 연결되었습니다.")
except redis.ConnectionError:
    print("Redis 서버에 연결할 수 없습니다.")

# YOLOv5 모델 로드
model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5s.pt')

# RTSP 스트리밍 주소
rtsp_url = "rtsp://asdf1013:asdf1013@172.20.10.8:554/stream1"

# 웹캡처 객체 초기화
cap = cv2.VideoCapture(rtsp_url)
cv2.namedWindow('YOLOv5 Person Detection', cv2.WINDOW_NORMAL)
cv2.resizeWindow('YOLOv5 Person Detection', 1000, 550)

# 웹캠 확인
if not cap.isOpened():
    print("웹캠을 열 수 없습니다.")
    exit()

# 사용자 정의 좌표 설정
def get_user_defined_points():
    return [

        (230, 600),   # 1
        (290, 300),   # 2
        (540, 650),  # 3
        (540, 300),  # 4
        (800, 650),  # 5
        (800, 300),  # 6
        (1130, 650),  # 7
        (1050, 300),  # 8

    ]

# 점의 좌표
points = get_user_defined_points()
s10_result = []
start_time = time.time()
count_10_seconds = 0

while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame = cv2.rotate(frame, cv2.ROTATE_180)  # 화면을 180도 회전

    #frame = cv2.flip(frame, 1)  # 좌우 반전
    results = model(frame)  # YOLOv5 객체 탐지
    person_results = results.pred[0][results.pred[0][:, -1] == 0]

    # 바운딩 박스 그리기
    output = frame.copy()
    bbox_list = [(bbox[:4].cpu().numpy().astype(int)) for bbox in person_results]
    for bbox in bbox_list:
        cv2.rectangle(output, (bbox[0], bbox[1]), (bbox[2], bbox[3]), (0, 255, 0), 2)

    # 점을 화면에 표시
    for idx, point in enumerate(points, start=1):
        cv2.circle(output, point, 5, (0, 0, 255), -1)
        cv2.putText(output, str(idx), (point[0] + 10, point[1] - 10), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

    # 10초 경과 체크
    current_time = time.time()
    if current_time - start_time >= 10:
        result_list = []
        for point in points:
            is_overlapped = any(bbox[0] < point[0] < bbox[2] and bbox[1] < point[1] < bbox[3] for bbox in bbox_list)
            result_list.append(1 if is_overlapped else 0)

        s10_result.append(result_list)
        start_time = current_time
        count_10_seconds += 1
        print("10초 경과:", s10_result)

        if count_10_seconds == 6:
            print("1분 경과, 결과 처리 중...")
            minute_result = [1 if sum(result[i] for result in s10_result[-6:]) > 3 else 0 for i in range(8)]
            print("1분 결과:", minute_result)

            # Redis에 데이터 업데이트
            for idx, value in enumerate(minute_result, start=1):
                redis_client.hset(f"seat:{idx}", "isUsed", value)

            # 초기화
            s10_result = []
            count_10_seconds = 0

    cv2.imshow('YOLOv5 Person Detection', output)

    # 'q' 키로 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
