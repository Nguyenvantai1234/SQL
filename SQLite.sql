-- nhập các bảng lại với nhau
CREATE TABLE AppleStore_description_combine AS
SELECT * FROM appleStore_description1
UNION
SELECT * FROM appleStore_description2
UNION
SELECT * FROM appleStore_description3
UNION
SELECT * FROM appleStore_description4

SELEct * From AppleStore_description_combine
SELECT * FROM AppleStore
-- Kiểm tra số lượng app trog 2 bảng
SELECT COUNT(DISTINCT id) FROM AppleStore 

SELECT COUNT(DISTINCT id) FROM AppleStore_description_combine
-- Kiểm tra các dữ liệu bị thiếu
SELECT COUNT(*) AS MissingValue
FROM AppleStore
WHERE track_name IS NULL OR cont_rating ISNULL OR prime_genre ISNULL

SELECT COUNT(*) AS MissingValue
FROM AppleStore_description_combine
WHERE track_name IS NULL OR size_bytes ISNULL OR app_desc ISNULL
-- đếm bao nhiêu app theo số lượng
SELECT prime_genre,COUNT(*) AS number_of_app_per_genre
FROM AppleStore
GROUP BY prime_genre
ORDER BY number_of_app_per_genre DESC
-- xem min,max và avg ratings 
SELECT MIN(user_rating) Min_ratings, MAX(user_rating) Max_ratings, AVG(user_rating) avg_rating 
FROM AppleStore
-- phân loại tính trung bình paid app và free app
SELECT CASE WHEN price > 0 THEN 'paid_app' ELSE 'free_app' END AS type_app, count(*) number_of_app, AVG(user_rating) avf
FROM AppleStore
GROUP BY type_app

-- Xem paid app nhiều tiên và ít tiền nhất bao nhiêu?
SELECT Max(price) max_price, MIN(price) min_price
FROM AppleStore
WHERE price>0;
-- trung bình đánh giá dựa trên số lượng ngôn ngữ 
SELECT CASE WHEN lang_num < 10 THEN '10 lang' 
		WHEN lang_num BETWEEN 10 AND 30 THEn '10-30 lang'
        ELSE '>30 lang' END AS type_app, 
        AVG(user_rating) avf
FROM AppleStore
GROUP BY type_app
-- trung bình đánh giá trên thể loại
SELECT prime_genre, AVG(user_rating) avf
FROM AppleStore
GROUP BY prime_genre
ORDER BY  AVG(user_rating) DESC
-- trung bình đánh giá trên độ dài description
SELECT CASE WHEN LENGTH(o.app_desc) < 500 THEN 'short'
	WHEN LENGTH(o.app_desc) BETWEEN 500 AND 1000 THEN 'medium'
    ELSE 'long' END AS type_app,
    AVG(user_rating) avf
FROM AppleStore AS a
JOIN AppleStore_description_combine o ON a.id = o.id
GROUP BY type_app
ORDER BY avf DESC
-- đánh giá cao nhất 
SELECT track_name, prime_genre, MAX(user_rating) AS top_rating_app
FROM AppleStore
GROUP BY prime_genre
-- đánh giá cao nhất ở mỗi loại 
SELECT track_name, prime_genre, user_rating
FROM (
    SELECT track_name, prime_genre, user_rating,
    RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC) AS top_rating_app
    FROM AppleStore
) AS a
WHERE top_rating_app = 1;
