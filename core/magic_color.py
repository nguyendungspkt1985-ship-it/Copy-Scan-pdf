import cv2
import numpy as np

def apply_magic_color(image):
    """
    Xử lý Magic Color cao cấp:
    - Trắng nền tuyệt đối
    - Tăng độ nét chữ đen / chữ màu
    - Khử bóng đổ hoàn toàn
    """
    # 1. Khử bóng bằng Morphological Closing
    planes = cv2.split(image)
    result_planes = []
    for plane in planes:
        dilated_img = cv2.dilate(plane, np.ones((7, 7), np.uint8))
        bg_img = cv2.medianBlur(dilated_img, 21)
        diff_img = 255 - cv2.absdiff(plane, bg_img)
        norm_img = cv2.normalize(diff_img, None, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8UC1)
        result_planes.append(norm_img)

    no_shadow = cv2.merge(result_planes)

    # 2. Chuyển sang không gian LAB để nâng Contrast phần sáng/tối
    lab = cv2.cvtColor(no_shadow, cv2.COLOR_BGR2LAB)
    l, a, b = cv2.split(lab)
    
    clahe = cv2.createCLAHE(clipLimit=2.5, tileGridSize=(8, 8))
    cl = clahe.apply(l)
    
    limg = cv2.merge((cl, a, b))
    enhanced = cv2.cvtColor(limg, cv2.COLOR_LAB2BGR)

    # 3. Lọc sắc nét chữ và làm nổi màu nét vẽ/con dấu
    kernel = np.array([[0, -1, 0],
                       [-1, 5, -1],
                       [0, -1, 0]])
    sharp = cv2.filter2D(enhanced, -1, kernel)

    # 4. Ngưỡng hóa thích ứng giữ lại chi tiết nét màu
    gray = cv2.cvtColor(sharp, cv2.COLOR_BGR2GRAY)
    _, mask = cv2.threshold(gray, 220, 255, cv2.THRESH_BINARY)
    
    # Ép nền xám nhẹ thành nền trắng tinh (Pure White Background)
    sharp[mask == 255] = [255, 255, 255]

    return sharp