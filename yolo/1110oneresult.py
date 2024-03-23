import cv2
import torch

# YOLOv5 모델 로드
model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5s.pt')

# 웹캠 캡처 객체 초기화
cap = cv2.VideoCapture(0)

# 캠 화면 크기 설정
cv2.namedWindow('YOLOv5 Person Detection', cv2.WINDOW_NORMAL)
cv2.resizeWindow('YOLOv5 Person Detection', 1000, 750)  # 원하는 크기로 설정해주세요

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
    for bbox in person_results:
        # 바운딩 박스 좌표 추출
        bbox = bbox[:4].cpu().numpy().astype(int)
        # 바운딩 박스 그리기
        cv2.rectangle(output, (bbox[0], bbox[1]), (bbox[2], bbox[3]), (0, 255, 0), 2)

    # 점의 좌표 설정
    points = [(100, 100), (100, frame.shape[0]-100), (frame.shape[1]-100, 100), (frame.shape[1]-100, frame.shape[0]-100)]

    # 점을 웹캠 화면에 표시
    for idx, point in enumerate(points, start=1):
        cv2.circle(output, point, 5, (0, 0, 255), -1)
        cv2.putText(output, str(idx), (point[0] + 10, point[1] - 10), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)


    # 객체 바운딩 박스와 점이 겹치는지 확인하여 결과 출력
    result_str = ''
    for point in points:
        is_overlapped = False
        for bbox in person_results:
            is_overlap = bbox[0] < point[0] < bbox[2] and bbox[1] < point[1] < bbox[3]
            if is_overlap:
                is_overlapped = True
                break
        result_str += '1' if is_overlapped else '0'
        result_str += ' '

    print(result_str.strip())

    # 결과 이미지 표시
    cv2.imshow('YOLOv5 Person Detection', output)

    # 'q' 키를 눌러 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
