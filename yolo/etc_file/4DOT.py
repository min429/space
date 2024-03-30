import cv2
import torch
import time

# YOLOv5 모델 로드
model = torch.hub.load('ultralytics/yolov5', 'custom', path='../yolov5s.pt')

# 웹캠 캡처 객체 초기화
cap = cv2.VideoCapture(0)

# 캠 화면 크기 설정
cv2.namedWindow('YOLOv5 Person Detection', cv2.WINDOW_NORMAL)
cv2.resizeWindow('YOLOv5 Person Detection', 1000, 750)

# 각 점별 시작 시간 및 겹친 시간 초기화
start_times = [0, 0, 0, 0]
overlap_states = [False, False, False, False]  # 각 점의 겹침 상태 저장

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # 화면을 좌우로 반전
    frame = cv2.flip(frame, 1)

    # YOLOv5 모델을 사용하여 객체 탐지
    results = model(frame)

    # 객체 감지 결과에서 사람 객체만 추출
    person_results = results.pred[0][results.pred[0][:, -1] == 0]

    # 바운딩 박스 그리기 및 중앙 점 계산
    output = frame.copy()
    h, w, _ = frame.shape
    points = [(w // 4, h // 4), (3 * w // 4, h // 4), (w // 4, 3 * h // 4), (3 * w // 4, 3 * h // 4)]

    # 현재 시간 저장
    current_time = time.time()

    # 각 점에 대한 처리
    for i, point in enumerate(points):
        cv2.circle(output, point, 5, (0, 0, 255), -1)
        for detection in person_results:
            bbox = detection[:4].cpu().numpy().astype(int)
            cv2.rectangle(output, (bbox[0], bbox[1]), (bbox[2], bbox[3]), (0, 255, 0), 2)

            # 객체의 중심 좌표 계산
            bbox_center = ((bbox[0] + bbox[2]) // 2, (bbox[1] + bbox[3]) // 2)

            # 객체가 점 주변에 있는지 확인
            if abs(point[0] - bbox_center[0]) < w // 8 and abs(point[1] - bbox_center[1]) < h // 8:
                # 겹침 상태 변경
                if not overlap_states[i]:  # 겹친 상태가 아닌 경우에만 시작 시간 업데이트
                    start_times[i] = current_time
                overlap_states[i] = True
                break
        else:  # 겹치지 않은 경우 겹침 상태 변경
            overlap_states[i] = False
            # 겹치지 않은 경우에만 겹친 시간 업데이트
            if start_times[i] != 0:
                elapsed = current_time - start_times[i]
                print(f"Overlap at point {i+1}: {elapsed:.2f} seconds")
                start_times[i] = 0

    # 결과 이미지 표시
    cv2.imshow('YOLOv5 Person Detection', output)

    # 'q' 키를 눌러 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
