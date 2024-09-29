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
webcam_index = 0

# 웹캠 캡처 객체 초기화
cap = cv2.VideoCapture(rtsp_url)
# cap = cv2.VideoCapture(0)

# 캠 화면 크기 설정
cv2.namedWindow('YOLOv5 Person Detection', cv2.WINDOW_NORMAL)
cv2.resizeWindow('YOLOv5 Person Detection', 1000, 550)  # 원하는 크기로 설정해주세요

# 웹캠이 열려 있는지 확인
if not cap.isOpened():
    print("웹캠을 열 수 없습니다.")
    exit()

# 10초마다 결과를 저장할 리스트
s10_result = []

# 시작 시간 초기화
start_time = time.time()

# 10초 동안의 카운터 초기화
count_10_seconds = 0

# 사용자 정의 좌표 설정 함수
def get_user_defined_points():
    # 여기서 원하는 좌표를 설정할 수 있습니다.
    points = [
        (70, 150),  # 좌표 1
        (250, 150),  # 좌표 2
        (400, 150),  # 좌표 3
        (540, 150), # 좌표 4
        (70, 400),  # 좌표 5
        (250, 400),  # 좌표 6
        (400, 400),  # 좌표 7
        (540, 400), # 좌표 8
    ]
    return points

# 사용자가 정의한 점의 좌표
points = get_user_defined_points()

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # 화면을 좌우로 반전
    frame = cv2.flip(frame, 1)

    # YOLOv5 모델을 사용하여 객체 탐지
    results = model(frame)

    # 객체 감지 결과에서 사람 객체만 추출
    person_results = results.pred[0][results.pred[0][:, -1] == 0]  # 클래스 0은 사람을 나타냄

    # 바운딩 박스 그리기
    output = frame.copy()
    # 객체 바운딩 박스 출력
    bbox_list = []  # 바운딩 박스 좌표를 저장할 리스트
    for bbox in person_results:
        # 바운딩 박스 좌표 추출
        bbox = bbox[:4].cpu().numpy().astype(int)
        # 바운딩 박스 그리기
        cv2.rectangle(output, (bbox[0], bbox[1]), (bbox[2], bbox[3]), (0, 255, 0), 2)
        # 바운딩 박스 좌표를 리스트에 추가
        bbox_list.append(bbox)

    # 점을 웹캠 화면에 표시
    for idx, point in enumerate(points, start=1):
        cv2.circle(output, point, 5, (0, 0, 255), -1)
        cv2.putText(output, str(idx), (point[0] + 10, point[1] - 10), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

    # 현재 시간
    current_time = time.time()

    # 10초가 지난 경우
    if current_time - start_time >= 10:

        # 결과 리스트 초기화
        result_list = []

        # 객체 바운딩 박스와 점이 겹치는지 확인하여 결과 저장
        for point in points:
            is_overlapped = False
            for bbox in bbox_list:
                is_overlap = bbox[0] < point[0] < bbox[2] and bbox[1] < point[1] < bbox[3]
                if is_overlap:
                    is_overlapped = True
                    break
            result_list.append(1 if is_overlapped else 0)

        s10_result.append(result_list)  # 10초 결과 저장
        start_time = current_time  # 시작 시간 재설정
        count_10_seconds += 1
        print("10초 경과:", s10_result)

        # 1분이 지난 경우
        if count_10_seconds == 6:
            print("1분 경과, 결과 처리 중...")
            # 1분 동안의 결과 저장
            minute_result = []
            for i in range(8):  # 좌석 8개에 대한 처리
                count_0 = sum(1 for x in s10_result[-6:] if x[i] == 0)  # 인덱스 i에서 0의 개수
                count_1 = 6 - count_0  # 1의 개수는 총 6개에서 0의 개수를 뺀 것과 같음
                minute_result.append(0 if count_0 > count_1 else 1)  # 더 많은 쪽으로 결정하여 결과 저장
            print("1분 결과:", minute_result)

            # Redis에 데이터 업데이트 (좌석 8개에 대한 처리)
            for idx, value in enumerate(minute_result, start=1):
                seat_id = f"seat:{idx}"
                redis_client.hset(seat_id, "isUsed", value)

            # 1분이 지난 후 초기화
            s10_result = []
            start_time = current_time  # 시작 시간 재설정
            count_10_seconds = 0  # 10초 동안의 카운터 초기화

    # 결과 이미지 표시
    cv2.imshow('YOLOv5 Person Detection', output)

    # 'q' 키를 눌러 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
