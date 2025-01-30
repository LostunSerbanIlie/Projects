import cv2  # biblioteca OpenCV pentru procesarea imaginilor și a videoclipurilor
import numpy as np #  biblioteca NumPy pentru operații matematice pe matrice și vectori

# Deschide videoclipul pentru prelucrare; 'Lane Detection Test Video.mp4' este fișierul video sursă
cam = cv2.VideoCapture('Lane Detection Test Video.mp4')


# Bucla care rulează până când toate cadrele din video au fost procesate
while True:
    ret, frame = cam.read()  # Citește un cadru din videoclip; 'ret' indică dacă citirea a fost reușită

    # daca am ajuns la sfarsitul videoclipului, ne intoarcem la inceput si continuam
    if ret is False:
        cam.set(cv2.CAP_PROP_POS_FRAMES, 0) # CAP_PROP_POS_FRAMES = 0 -> seteaza frame-ul curent la 0
        continue

    # daca citirea cadrului eșueaza (de ex., s-a ajuns la sfârșitul videoclipului), iesim din bucla
    # if ret is False:
    #     break

    # ------------------------------------ Exercitiul 1 --------------------------------------------------------------
    #afișează cadrul original intr-o fereastra denumita 'Original'
    # cv2.imshow('Original', frame)



    # ------------------------------------ Exercitiul 2 --------------------------------------------------------------
    # Shrink the frame to 1/3 of its size
    height, width, channels = frame.shape  # obține dimensiunile cadrului (înălțime, lățime, canale de culaore )
    #print(height, width, channels)  # afișează dimensiunile cadrului

    new_width = width // 3 # // - divizare întreagă
    new_height = height // 3
    #print(new_height, new_width, channels)  # afișează dimensiunile cadrului

    resized_frame= cv2.resize(frame, (new_width, new_height))  # resize la 640x480
    cv2.imshow('Resized', resized_frame)


    # ------------------------------------ Exercitiul 3 --------------------------------------------------------------
    # Convert the frame to Grayscale
    gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)  # converteste cadrul la alb-negru
    gray_frame_resized= cv2.resize(gray_frame, (new_width, new_height))  # resize la 180x426
    cv2.imshow('Gray Frame (Auto)', gray_frame_resized)


    # Varianta a doua de a transforma imaginea in grayscale (cu foruri -> mai lent)
    # folosim formula de conversie in grayscale pentru fiecare pixel din imagine
    # 0.299 * R + 0.587 * G + 0.114 * B prin accesarea canalelor de culoare ale fiecarui pixel

    # manual_gray_frame = np.zeros((new_height, new_width), np.uint8)  # creează un cadru nou de dimensiunea 180x426
    # for i in range(new_height):
    #     for j in range(new_width):
    #         # Extrage valorile pentru B, G și R ale pixelului curent
    #         blue = resized_frame[i, j, 0]
    #         green = resized_frame[i, j, 1]
    #         red = resized_frame[i, j, 2]
    #
    #         # formula de conversie în gri cu ponderi
    #         gray_value = int(0.299 * red + 0.587 * green + 0.114 * blue)
    #
    #         # Setează valoarea de gri în noul cadru
    #         manual_gray_frame[i, j] = gray_value
    #
    # # Afișează cadrul rezultat
    # cv2.imshow('Gray Frame (Manual)', manual_gray_frame)


    # folosim operatiile vectorizate ale NumPy pentru a face conversia mai eficient
    # manual_gray_frame = (0.299 * resized_frame[:, :, 2] +
    #                      0.587 * resized_frame[:, :, 1] +
    #                      0.114 * resized_frame[:, :, 0]).astype(np.uint8)
    #
    # cv2.imshow('Gray Frame (Manual)', manual_gray_frame)


    # ------------------------------------ Exercitiul 4 --------------------------------------------------------------
    # Select only the road !
    # the road is the lower half of the frame and almost a trapezoid
    trapezoid_frame= np.zeros((new_height, new_width), dtype= np.uint8)  # creează un cadru nou de dimensiunea 180x426
    # cv2.imshow('Black Frame', black_frame)

    # Trapez ajustat treptat
    # Adjust the trapezoid coordinates to lower it
    upper_left = (int(new_width * 0.4), int(new_height * 0.767))
    upper_right = (int(new_width * 0.55), int(new_height * 0.767))
    lower_left = (int(new_width * 0.1), new_height)
    lower_right = (int(new_width * 0.9), new_height)

    trapezoid_points = np.array([upper_right, upper_left, lower_left, lower_right], dtype= np.int32) # creează un array de puncte de forma (x,y)
    cv2.fillConvexPoly(trapezoid_frame, trapezoid_points, 1) # umple trapezul cu valoarea 1 = alb
    # cv2.imshow("Trapezoid", trapezoid_frame * 255) # afișează trapezul umplut cu alb (valoarea 255) pe un fundal negru (valoarea 0)

    trapezoid_area_road= gray_frame_resized * trapezoid_frame # inmultirea element cu element a celor doua matrici
    cv2.imshow("Only Road Shown (Multiplication)", trapezoid_area_road) # afișează doar partea de jos (drumul)

    # Alta varianta este sa facem si pe biti intre masca trapezoidala si imaginea grayscale
    # cv2.imshow('Only Road Shown', cv2.bitwise_and(gray_frame_resized, trapezoid_frame * 255)) # afișează doar partea de jos a drumului

    # ------------------------------------ Exercitiul 5 --------------------------------------------------------------
    # Get a top_down view! (sometimes called a bird's eye view)
    # Getting the coordinates for the area we want to stretch the trapezoid to
    top_right = (int(new_width), 0)
    top_left = (0, 0)
    bottom_left = (0, new_height)
    bottom_right = (int(new_width), new_height)

    trapezoid_bounds = np.float32(trapezoid_points)
    frame_bounds= np.array([top_right, top_left, bottom_left, bottom_right], dtype=np.float32)

    # Get the perspective transform matrix (magical matrix)
    magical_matrix = cv2.getPerspectiveTransform(trapezoid_bounds, frame_bounds)

    # stretching the trapezoid to the frame
    birds_eye_view = cv2.warpPerspective(trapezoid_area_road, magical_matrix, (new_width, new_height))
    cv2.imshow("Bird's Eye View", birds_eye_view)

    # ------------------------------------ Exercitiul 6 --------------------------------------------------------------
    # Add a bit of blur!
    blurred_frame = cv2.blur(birds_eye_view, (9,9))  # blur the frame with a nxn kernel
    cv2.imshow("Blurred Frame", blurred_frame)



    # ------------------------------------ Exercitiul 7 --------------------------------------------------------------
    # Do edge detection! - we will use the Sobel filter

    sobel_vertical= np.float32([[-1, -2, -1],
                                [0, 0, 0],
                                [1, 2, 1]]) # matricea Sobel pentru detectarea marginilor verticale

    sobel_horizontal= np.transpose(sobel_vertical) # transpusa matricei sobel_vertical pentru a obtine matricea sobel_horizontal

    # aplică filtrul Sobel pe imaginea blurată pentru a detecta marginile verticale
    sobel_vertical_edges= cv2.filter2D(blurred_frame, -1, sobel_vertical)
    sobel_horizontal_edges= cv2.filter2D(blurred_frame, -1, sobel_horizontal)

    cv2.imshow("Vertical Edges", sobel_vertical_edges)
    cv2.imshow("Horizontal Edges", sobel_horizontal_edges)

    sobel_vertical_edges32 = cv2.filter2D(blurred_frame, -1, sobel_vertical)
    sobel_horizontal_edges32 = cv2.filter2D(blurred_frame, -1, sobel_horizontal)

    # convertim la tipul float32 pentru a putea face operatii matematice
    sobel_vertical_edges32 = np.float32(sobel_vertical_edges32)
    sobel_horizontal_edges32 = np.float32(sobel_horizontal_edges32)

    sobel_filtered = np.sqrt(np.square(sobel_vertical_edges32) + np.square(sobel_horizontal_edges32))

    # normalizam valorile, clip = limita valorile intre 0 si 255
    sobel_filtered = np.uint8(np.clip(sobel_filtered, 0, 255))
    cv2.imshow("Filtered Edges", sobel_filtered)



    # ------------------------------------ Exercitiul 8 --------------------------------------------------------------
    # Binarize the frame!
    # we define a threshold to convert the edges into a binary image (black and white)
    treshold = 73

    # folosim metoda cv2.threshold pentru a binariza imaginea filtrata cu sobel
    # _, inseamna ca nu ne intereseaza valoarea returnata de functie
    _, binary_frame= cv2.threshold(sobel_filtered, treshold, 255, cv2.THRESH_BINARY)
    cv2.imshow("Binary Frame", binary_frame)



    # ------------------------------------ Exercitiul 9 --------------------------------------------------------------
    # Get the coordinates of street markings on each side of the road!

    binary_frame_copy= binary_frame.copy()
    margin_LR= int(new_width*0.05) # marginile sunt de 5% din lățimea cadrului
    margin_UD= int(new_height*0.12) # marginile sunt de 5% din înălțimea cadrului

    # Setez primele 5% si ultimele 5% din coloane ca fiind 0 (negru)
    binary_frame_copy[:,:margin_LR]= 0
    binary_frame_copy[:, -margin_LR:]= 0
    binary_frame_copy[:margin_UD, :]= 0
    binary_frame_copy[-margin_UD:, :]= 0

    # slicing the image into 2 halves to get the coordinates for each half
    left_half= binary_frame_copy[:, :new_width//2] # jumatatea stanga a imaginii [y, x] -> [inaltime, latime]
    right_half= binary_frame_copy[:, new_width//2:] # jumatatea dreapta a imaginii

    #  coordonatele punctelor albe (cele care au valoarea 255) în fiecare jumătate
    left_coords = np.argwhere(left_half == 255)
    # print(left_coords)
    right_coords = np.argwhere(right_half == 255)
    # print(right_coords)
    # ajustez coordonatele pentru partea dreaptă (adaugă width // 2 la coordonata x)
    right_coords[:, 1] += new_width // 2  # selectez toate elementele (:) de pe coloana 1 (x)

    cv2.imshow("Binary Frame 5% Margin", binary_frame_copy)



    # ------------------------------------ Exercitiul 10 --------------------------------------------------------------
    # Find the lines that detect the edges of the lane!

    if len(left_coords) > 0:
        # Verificam daca exista puncte albe in partea stanga a cadrului
        left_y_coords = left_coords[:, 0]  # Extragem coordonatele y ale punctelor din stanga
        left_x_coords = left_coords[:, 1]  # Extragem coordonatele x ale punctelor din stanga

        # Aplicam o interpolare polinomiala de gradul 1 (linia dreapta) pe punctele din stanga
        left_points = np.polynomial.polynomial.polyfit(left_x_coords, left_y_coords, deg=1)
        left_b = left_points[0]  # Interceptul liniei
        left_a = left_points[1]  # Panta liniei

        # Calculam punctul de sus al liniei din stanga (y=0)
        left_top_y = 0
        left_top_x = (left_top_y - left_b) / left_a

        # Calculam punctul de jos al liniei din stanga (y=new_height)
        left_bottom_y = new_height
        left_bottom_x = (left_bottom_y - left_b) / left_a

        # Desenam linia din stanga daca coordonatele sunt finite
        if np.isfinite(left_top_x) and np.isfinite(left_bottom_x):
            cv2.line(binary_frame_copy, (int(left_top_x), int(left_top_y)),  # Punctul de sus
                     (int(left_bottom_x), int(left_bottom_y)),  # Punctul de jos
                     (100, 0, 0), 3)  # Desenam linia in albastru (grosime=3)
    else:
        # Daca nu exista puncte albe in partea stanga, panta si interceptul devin None
        left_a, left_b = None, None

    if len(right_coords) > 0:
        # Verificam daca exista puncte albe in partea dreapta a cadrului
        right_y_coords = right_coords[:, 0]  # Extragem coordonatele y ale punctelor din dreapta
        right_x_coords = right_coords[:, 1]  # Extragem coordonatele x ale punctelor din dreapta

        # Aplicam o interpolare polinomiala de gradul 1 (linia dreapta) pe punctele din dreapta
        right_points = np.polynomial.polynomial.polyfit(right_x_coords, right_y_coords, deg=1)
        right_b = right_points[0]  # Interceptul liniei
        right_a = right_points[1]  # Panta liniei

        # Calculam punctul de sus al liniei din dreapta (y=0)
        right_top_y = 0
        right_top_x = (right_top_y - right_b) / right_a

        # Calculam punctul de jos al liniei din dreapta (y=new_height)
        right_bottom_y = new_height
        right_bottom_x = (right_bottom_y - right_b) / right_a

        # Desenam linia din dreapta daca coordonatele sunt finite
        if np.isfinite(right_top_x) and np.isfinite(right_bottom_x):
            cv2.line(binary_frame_copy, (int(right_top_x), int(right_top_y)),  # Punctul de sus
                     (int(right_bottom_x), int(right_bottom_y)),  # Punctul de jos
                     (100, 0, 0), 3)  # Desenam linia in albastru (grosime=3)
    else:
        # Daca nu exista puncte albe in partea dreapta, panta si interceptul devin None
        right_a, right_b = None, None

    # Desenam o linie verticala in mijlocul cadrului pentru a separa cele doua jumatati
    cv2.line(binary_frame_copy, (new_width // 2, 0),  # Punctul de start sus centru
             (new_width // 2, new_height),  # Punctul de sfarsit jos centru
             (255, 0, 0), 1)  # Desenam linia in rosu (grosime=1)

    # desenează o linie verticală în mijlocul cadrului pentru a separa cele două jumătăți
    cv2.line(binary_frame_copy, (new_width // 2, 0), (new_width // 2, new_height), (255, 0, 0), 1)

    cv2.imshow("Binary Frame with Line", binary_frame_copy)

    # ------------------------------------ Exercitiul 11 --------------------------------------------------------------
    # Create a final visualization!
    # Cadrul și linia stângă
    lane_frame_left = np.zeros((new_height, new_width), dtype=np.uint8)
    cv2.line(lane_frame_left, (int(left_top_x), left_top_y), (int(left_bottom_x), left_bottom_y), (255, 0, 0), 5)

    # Matrice de transformare pentru linia stângă
    magical_matrix_left = cv2.getPerspectiveTransform(frame_bounds, trapezoid_bounds)
    transformed_lane_frame_left = cv2.warpPerspective(lane_frame_left, magical_matrix_left, (new_width, new_height))

    # Coordonate linie stângă
    left_coords_transformed = np.argwhere(transformed_lane_frame_left == 255)

    # Cadrul și linia dreaptă
    lane_frame_right = np.zeros((new_height, new_width), dtype=np.uint8)
    cv2.line(lane_frame_right, (int(right_top_x), right_top_y), (int(right_bottom_x), right_bottom_y), (255, 0, 0), 5)

    # Matrice de transformare pentru linia dreaptă
    magical_matrix_right = cv2.getPerspectiveTransform(frame_bounds, trapezoid_bounds)
    transformed_lane_frame_right = cv2.warpPerspective(lane_frame_right, magical_matrix_right, (new_width, new_height))

    # Coordonate linie dreaptă
    right_coords_transformed = np.argwhere(transformed_lane_frame_right == 255)

    # Creați o copie a imaginii pentru a desena ambele linii
    final_frame = resized_frame.copy()

    # Desenează linia stângă pe cadrul final
    for coord in left_coords_transformed:
        y, x = coord
        final_frame[y, x] = (50, 50, 250)  # roșu

    # Desenează linia dreaptă pe cadrul final
    for coord in right_coords_transformed:
        y, x = coord
        final_frame[y, x] = (50, 250, 50)  # verde

    # Afișare
    cv2.imshow('Final Lane Detection', final_frame)


    # aștept 1 ms pt apasarea unei taste; daca tasta 'q' este apasata, ies din bucla
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Eliberează resursele folosite pentru redarea video-ului și închide toate ferestrele
cam.release()
cv2.destroyAllWindows()
