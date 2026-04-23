from flask import Flask, Response
from cv2 import CAP_FFMPEG, Mat, VideoCapture, imencode, CAP_PROP_FOURCC, CAP_PROP_FRAME_WIDTH, CAP_PROP_FRAME_HEIGHT, VideoWriter_fourcc

app = Flask(__name__)

cap = VideoCapture(0)

# cap.set(CAP_PROP_FRAME_HEIGHT, 1920)
# cap.set(CAP_PROP_FRAME_WIDTH, 1080)
cap.set(CAP_PROP_FOURCC, VideoWriter_fourcc(*'MJPG'))

def gen(camera: VideoCapture):
    while True:
        ret, raw_frame = camera.read()
        if not ret:
          break
        
        _, buffer = imencode(".jpg", raw_frame)
        frame = buffer.tobytes()

        if ret:
            yield (b"--frame\r\n" b"Content-Type: image/jpeg\r\n\r\n" + frame + b"\r\n")

@app.route("/video_feed")
def video_feed():
    return Response(gen(cap), mimetype="multipart/x-mixed-replace; boundary=frame")

@app.route("/")
def index():
    """Home page with embedded video stream"""
    return """
    <html>
        <head>
            <title>Camera Stream</title>
            <style>
                body {
                    margin: 0;
                    padding: 20px;
                    background-color: #1e1e1e;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    font-family: Arial, sans-serif;
                }
                h1 {
                    color: #ffffff;
                }
                img {
                    border: 2px solid #444;
                    border-radius: 8px;
                    max-width: 90%;
                }
            </style>
        </head>
        <body>
            <h1>Live Camera Feed</h1>
            <img src="/video_feed" alt="Camera Stream">
        </body>
    </html>
    """

if __name__ == "__main__":
    print("Starting camera web server...")
    print("Open your browser and go to: http://localhost:5000")
    try:
        app.run(host="0.0.0.0", port=5000, debug=False, threaded=True)
    finally:
        cap.release()
        print("Camera released")
