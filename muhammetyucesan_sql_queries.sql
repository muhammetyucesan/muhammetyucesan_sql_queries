--1
select product_name, quantity_per_unit from products ;

--2
select product_id, product_name from products
where discontinued = 0 ;

--3
select product_id, product_name, discontinued from products
where discontinued = 1 ;

--4
select product_id, product_name, unit_price from products
where unit_price < 20
order by unit_price desc ;

--5
select product_id, product_name, unit_price from products
--where unit_price between 15 and 25
where 15 < unit_price and unit_price < 25;

--6
select product_name, units_in_stock, units_on_order 
from products
where units_in_stock < units_on_order ;

--7
select product_name from products
where product_name like 'a%' ; 
--yüzde sonda olunca baştan başlar

--8
select product_name from products
where product_name like '%i' ;

--9
select product_name, unit_price, 
(unit_price*1.18) as unit_price_kdv
from products ;

--10
select count(*) as product_counts 
from products
where unit_price > 30 ;

--11.Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
select lower(product_name) as lower_product_name, unit_price
from products
order by unit_price desc ;

--12.Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
select concat (first_name, ' ', last_name) as full_name
from employees ;

--13. Region alanı NULL olan kaç tedarikçim var?

--14. a.Null olmayanlar?

--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
select upper('TR ' || product_name) as upper_product_name
from products ;

--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
select ('TR ' || product_name) as tr_product_name, unit_price
from products
where unit_price < 20 ;

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price
from products
where unit_price = (select max(unit_price) from products) ;

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price 
from products
order by unit_price desc
limit 10 ;

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın
select product_name, unit_price
from products
where unit_price > (select avg(unit_price) from products) ;

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select units_in_stock, count(*) as product_count
from products
group by units_in_stock ;

--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın

--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select products.product_name, products.unit_price, 
categories.category_name
from Products
inner join categories on products.category_id = categories.category_id
order by products.unit_price desc
limit 1 ;

--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı


--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT Products.Product_ID, Products.Product_Name, Suppliers.Company_Name, Suppliers.Phone
FROM Products
LEFT JOIN Suppliers --tüm ürünleri ve bu ürünlere bağlı tedarikçileri getirir, ancak ürüne bağlı tedarikçi olmayan ürünler de listelenir.
ON Products.Supplier_ID = Suppliers.Supplier_ID --"Products" tablosunu "Suppliers" tablosu ile "SupplierID" sütunu aracılığıyla birleştirir. 
WHERE Products.Units_In_Stock = 0 ;--stokta bulunmayan ürünleri seçer.

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
--28. 1997 yılı şubat ayında kaç siparişim var?
SELECT COUNT(*) AS Order_Number
FROM Orders
WHERE EXTRACT(YEAR FROM Order_Date) = 1997
  AND EXTRACT(MONTH FROM Order_Date) = 2 ;
  
--29. London şehrinden 1998 yılında kaç siparişim var?
SELECT COUNT(*) AS Order_Number
FROM Customers 
JOIN Orders 
ON Customers.Customer_ID = Orders.Customer_ID
WHERE EXTRACT(YEAR FROM Orders.Order_Date) = 1998
  AND Customers.City = 'London' ;
  
--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT Customers.Contact_Name, Customers.Phone
FROM Customers 
JOIN Orders 
ON Customers.Customer_ID = Orders.Customer_ID
WHERE EXTRACT(YEAR FROM Orders.Order_Date) = 1997 ;

--31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT *
FROM Orders
WHERE Freight >= 40;

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT Orders.Ship_City AS Order_Cityy, Customers.Contact_Name AS customerName
FROM Orders 
JOIN Customers 
ON Orders.Customer_ID = Customers.Customer_ID
WHERE Orders.Freight >= 40 ;

--33.1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
SELECT
    TO_CHAR(Orders.Order_Date, 'YYYY-MM-DD') AS Tarih,
    Customers.City AS Şehir,
    UPPER(CONCAT(Employees.First_Name, ' ', Employees.Last_Name)) AS ÇalışanAdSoyad
FROM
    Orders
JOIN
    Customers ON Orders.Customer_ID = Customers.Customer_ID
JOIN
    Employees ON Orders.Employee_ID = Employees.Employee_ID
WHERE
    EXTRACT(YEAR FROM Orders.Order_Date) = 1997;

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
SELECT
    C.Contact_Name AS IletisimAdi,
    REPLACE(REPLACE(REPLACE(C.Phone, '(', ''), ')', ''), ' ', '') AS TelefonNumarasi
FROM
    Customers AS C
WHERE
    C.Customer_ID IN (SELECT DISTINCT Customer_ID FROM Orders WHERE EXTRACT(YEAR FROM Order_Date) = 1997);

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad 
SELECT
    O.Order_Date AS SiparisTarihi,
    C.Contact_Name AS MusteriIletisimAdi,
    E.First_Name AS CalisanAdi,
    E.Last_Name AS CalisanSoyadi
FROM
    Orders AS O
JOIN
    Customers AS C ON O.Customer_ID = C.Customer_ID
JOIN
    Employees AS E ON O.Employee_ID = E.Employee_ID ;

--36. Geciken siparişlerim?
SELECT Order_ID, Customer_ID, Required_Date, Shipped_Date
FROM Orders
WHERE Shipped_Date > Required_Date ;

--37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT O.Shipped_Date AS SiparisTarihi, C.Contact_Name AS MusteriAdi
FROM Orders AS O
JOIN Customers AS C ON O.Customer_ID = C.Customer_ID
WHERE O.Shipped_Date > O.Required_Date;

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT P.Product_Name AS UrunAdi, C.Category_Name AS KategoriAdi, OD.Quantity AS Adet
FROM Order_Details AS OD
JOIN Products AS P ON OD.Product_ID = P.Product_ID
JOIN Categories AS C ON P.Category_ID = C.Category_ID
WHERE OD.Order_ID = 10248;

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT P.Product_Name AS UrunAdi, S.company_Name AS TedarikciAdi
FROM Order_Details AS OD
JOIN Products AS P ON OD.Product_ID = P.Product_ID
JOIN Suppliers AS S ON P.Supplier_ID = S.Supplier_ID
WHERE OD.Order_ID = 10248 ;

--40.3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT P.Product_Name AS UrunAdi, OD.Quantity AS Adet
FROM Employees AS E
JOIN Orders AS O ON E.Employee_ID = O.Employee_ID
JOIN Order_Details AS OD ON O.Order_ID = OD.Order_ID
JOIN Products AS P ON OD.Product_ID = P.Product_ID
WHERE E.Employee_ID = 3
  AND EXTRACT(YEAR FROM O.Order_Date) = 1997 ;
  
--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad


--42.

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT P.Product_Name AS UrunAdi, P.Unit_Price AS Fiyat, C.Category_Name AS KategoriAdi
FROM Products AS P
JOIN Categories AS C ON P.Category_ID = C.Category_ID
ORDER BY P.Unit_Price DESC
LIMIT 1;

--44. 
SELECT E.First_Name AS PersonelAdi, E.Last_Name AS PersonelSoyadi, 
O.Order_Date AS SiparisTarihi, O.Order_ID AS SiparisID
FROM Employees AS E
JOIN Orders AS O ON E.Employee_ID = O.Employee_ID
ORDER BY O.Order_Date;

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT AVG(OD.Unit_Price) AS OrtalamaFiyat, O.Order_ID AS SiparisID
FROM Orders AS O
JOIN Order_Details AS OD ON O.Order_ID = OD.Order_ID
GROUP BY O.Order_ID
ORDER BY O.Order_Date DESC
LIMIT 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT P.Product_Name AS UrunAdi, 
C.Category_Name AS KategoriAdi, 
SUM(OD.Quantity) AS ToplamSatisMiktari
FROM Orders AS O
JOIN Order_Details AS OD ON O.Order_ID = OD.Order_ID
JOIN Products AS P ON OD.Product_ID = P.Product_ID
JOIN Categories AS C ON P.Category_ID = C.Category_ID
WHERE EXTRACT(MONTH FROM O.Order_Date) = 1
GROUP BY P.Product_Name, C.Category_Name ;

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

--49.Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT Country) AS UlkeSayisi
FROM Customers;

--50.3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT E.Employee_ID, E.First_Name, E.Last_Name, 
SUM(OD.Quantity) AS ToplamSatisMiktari
FROM Employees AS E
JOIN Orders AS O ON E.Employee_ID = O.Employee_ID
JOIN Order_Details AS OD ON O.Order_ID = OD.Order_ID
WHERE E.Employee_ID = 3
  AND O.Order_Date >= '2023-01-01' -- Ocak 2023'ten bugüne
GROUP BY E.Employee_ID, E.First_Name, E.Last_Name;

-- 2. ÖDEV --

--51. - 59. aynı sorular olduğu için silmiştik.
--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

--62. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT Country) AS UlkeSayisi
FROM Customers;

--63. Hangi ülkeden kaç müşterimiz var

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT contact_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT Company_Name, Contact_Name AS RepresentativeName, Address, City, Country
FROM Customers
WHERE Country = 'Brazil';

--69. Brezilya’da olmayan müşteriler
SELECT Company_Name, Contact_Name AS Representative_Name, Address, City, Country
FROM Customers
WHERE Country != 'Brazil';

--70.Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT Company_Name, Contact_Name AS Representative_Name, Address, City, Country
FROM Customers
WHERE Country IN ('Spain', 'France', 'Germany');

--71. Faks numarasını bilmediğim müşteriler
SELECT Company_Name, Contact_Name AS Representative_Name, Address, City, Country
FROM Customers
WHERE Fax IS NULL;

--72. Londra’da ya da Paris’de bulunan müşterilerim
SELECT Company_Name, Contact_Name AS Representative_Name, Address, City, Country
FROM Customers
WHERE City IN ('London', 'Paris');

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT Product_Name, Unit_Price
FROM Products
WHERE Product_Name LIKE 'C%';

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT First_Name AS Name, Last_Name AS Surname, Birth_Date
FROM Employees
WHERE First_Name LIKE 'A%';

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT Company_Name
FROM Customers
WHERE Company_Name LIKE '%RESTAURANT%';

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT Product_Name, unit_Price
FROM Products
WHERE unit_Price >= 50 AND unit_Price <= 100;

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT Order_ID, Order_Date
FROM Orders
WHERE Order_Date >= '1996-07-01' AND Order_Date <= '1996-12-31';

--79.Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT Company_Name, Contact_Name AS RepresentativeName, Address, City, Country
FROM Customers
WHERE Country IN ('Spain', 'France', 'Germany');

--80. Faks numarasını bilmediğim müşteriler
SELECT Company_Name, Contact_Name AS RepresentativeName, Address, City, Country
FROM Customers
WHERE Fax IS NULL;

--81. Müşterilerimi ülkeye göre sıralıyorum:
SELECT DISTINCT Country
FROM Customers
ORDER BY Country;

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT Product_Name, unit_Price
FROM Products
ORDER BY unit_Price DESC;

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT Product_Name, unit_Price, Units_In_Stock
FROM Products
ORDER BY unit_Price DESC, Units_In_Stock;

--84. 1 Numaralı kategoride kaç ürün vardır..?
SELECT COUNT(*) AS Product_Count
FROM Products
WHERE Category_ID = 1;

--85.Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT Ship_Country) AS Country_Count
FROM Orders;

--2.Ödev Sonu--

















































