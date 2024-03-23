import cv2
import torch
import time

# YOLOv5 모델 로드
model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5s.pt')

# 웹캠 캡처 객체 초기화
cap = cv2.VideoCapture(0)

# 캠 화면 크기 설정
cv2.namedWindow('YOLOv5 Person Detection', cv2.WINDOW_NORMAL)
cv2.resizeWindow('YOLOv5 Person Detection', 1000, 750)  # 원하는 크기로 설정해주세요

# 캠 화면 중앙 좌표 계산
center_x = None
center_y = None

# 시작 시간 초기화
start_time = 0

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

    for detection in person_results:
        bbox = detection[:4].cpu().numpy().astype(int)  # 텐서를 넘파이 배열로 변환한 후 형변환
        cv2.rectangle(output, (bbox[0], bbox[1]), (bbox[2], bbox[3]), (0, 255, 0), 2)

        # 캠 화면 중앙 좌표 설정
        center_x = frame.shape[1] // 2
        center_y = frame.shape[0] // 2

        # 중앙에 점 찍기
        cv2.circle(output, (center_x, center_y), 5, (0, 0, 255), -1)

        # 객체 바운딩 박스와 중앙 좌표가 겹치는지 확인
        bbox_center_x = (bbox[0] + bbox[2]) // 2
        bbox_center_y = (bbox[1] + bbox[3]) // 2

        if abs(center_x - bbox_center_x) < (frame.shape[1] // 4) and abs(center_y - bbox_center_y) < (frame.shape[0] // 4):
            if start_time == 0:
                start_time = time.time()  # 시작 시간 기록
            else:
                elapsed_time = time.time() - start_time  # 경과 시간 계산
                print("Person detected at the center for {} seconds".format(elapsed_time))
        else:
            # 중앙에서 벗어났으므로 시간 초기화
            start_time = 0

    # 결과 이미지 표시
    cv2.imshow('YOLOv5 Person Detection', output)

    # 'q' 키를 눌러 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
