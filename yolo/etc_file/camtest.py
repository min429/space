import cv2

# # Set up camera connection details
# ip_address = '192.168.0.XX' # Replace with the IP address of your camera
# port = '554'          # Replace with the port number for your camera
# username = 'admin'    # Replace with the username for your camera
# password = 'password' # Replace with the password for your camera
#
# # Construct the RTSP stream URLs using variables
# url_640x480 = f"rtsp://{username}:{password}@{ip_address}:{port}/stream2"
# url_1080p = f"rtsp://{username}:{password}@{ip_address}:{port}/stream1"

# RTSP 스트리밍 주소
rtsp_url = "rtsp://asdf1013:asdf1013@172.20.10.8:554/stream1"

# VideoCapture 객체 생성
cap = cv2.VideoCapture(rtsp_url)

# VideoCapture 객체 초기화 확인
if not cap.isOpened():
    print("RTSP 스트리밍을 열 수 없습니다.")
    exit()

while True:
    ret, frame = cap.read()  # 카메라로부터 프레임을 읽어옴

    if not ret:  # 프레임을 제대로 읽어오지 못한 경우
        print("RTSP 스트리밍에서 프레임을 읽어오지 못했습니다.")
        break

    cv2.imshow('RTSP Streaming', frame)  # 읽어온 프레임을 화면에 표시

    # 'q' 키를 눌러 종료
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# VideoCapture 객체 해제
cap.release()
cv2.destroyAllWindows()





