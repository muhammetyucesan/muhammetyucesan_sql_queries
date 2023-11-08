--86.Bu ülkeler hangileri..?
select distinct ship_country, count(ship_country)
from orders
group by ship_country
order by ship_country;

--87.En Pahalı 5 ürün
select unit_price
from products
order by unit_price desc
limit 5 ;

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select count (*) as siparisSayisi
from orders
where customer_id='ALFKI';

--89. Ürünlerimin toplam maliyeti
select sum (unit_price * units_in_stock) as ToplamMaliyet
from products ;

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum (quantity*unit_price) as ToplamCiro
from order_details ;

--91. Ortalama Ürün Fiyatım
select avg(unit_price) as OrtalamaÜrünFiyatı
from products ;

--92. En Pahalı Ürünün Adı
select product_name, unit_price
from products
order by unit_price desc
limit 1 ;

--93. En az kazandıran sipariş
select order_id, min (unit_price*quantity) as minGain
from order_details
group by order_id 
order by minGain
limit 1 ;

--94. Müşterilerimin içinde en uzun isimli müşteri
select customer_id, company_name
from customers
order by length(company_name) desc
limit 1 ;

--95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name, last_name, 
extract(year from age(birth_date)) as YAS
from employees 
order by YAS desc ;

--96. Hangi üründen toplam kaç adet alınmış..?
select products.product_name, 
sum(order_details.quantity) as ToplamSatisAdet
from products 
inner join order_details 
on products.product_id= order_details.product_id
group by products.product_name 
order by ToplamSatisAdet desc ;

--97.Hangi siparişte toplam ne kadar kazanmışım..?
select orders.order_id, 
sum(order_details.unit_price*order_details.quantity)
as toplamKazanc
from orders
inner join order_details
on orders.order_id= order_details.order_id
group by orders.order_id
order by toplamkazanc desc ;

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select categories.category_name, 
count(products.product_id) as urunAdet
from categories
inner join products 
on categories.category_id = products.category_id
group by categories.category_name 
order by urunAdet asc;

--99. 1000 Adetten fazla satılan ürünler?
SELECT product_name --select product_name, total_quantity
FROM products --from   (select products.product_name, sum(order_details.quantity)
WHERE product_id IN ( --as total_quantity from products
  SELECT product_id  --inner join order_details on products.product_id = order_details.product_id
  FROM order_details --group by products.product_name) as subquery
  GROUP BY product_id  --where total_quantity > 1000
  HAVING SUM(quantity) > 1000  --order by total_quantity;
);


--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select customer_id, company_name
from customers
where not exists (select 1 from orders 
				  where customers.customer_id=
				 orders.customer_id) ;
				 
--101. Hangi tedarikçi hangi ürünü sağlıyor ?
SELECT suppliers.supplier_id, suppliers.company_name, products.product_name
FROM suppliers
JOIN products ON suppliers.supplier_id = products.supplier_id;

--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?

--103. Hangi siparişi hangi müşteri verir..?
SELECT orders.order_id, customers.customer_id, customers.company_name
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id;

--104. Hangi çalışan, toplam kaç sipariş almış..?
SELECT employees.employee_id, employees.first_name, employees.last_name, COUNT(orders.order_id) AS total_orders
FROM employees
LEFT JOIN orders ON employees.employee_id = orders.employee_id
GROUP BY employees.employee_id, employees.first_name, employees.last_name;

--105. En fazla siparişi kim almış..?
SELECT employees.employee_id, employees.first_name, employees.last_name, COUNT(orders.order_id) AS total_orders
FROM employees
LEFT JOIN orders ON employees.employee_id = orders.employee_id
GROUP BY employees.employee_id, employees.first_name, employees.last_name
ORDER BY total_orders DESC
LIMIT 1;

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
SELECT orders.order_id, employees.first_name AS employee_first_name, employees.last_name AS employee_last_name, customers.company_name AS customer_company_name
FROM orders
JOIN employees ON orders.employee_id = employees.employee_id
JOIN customers ON orders.customer_id = customers.customer_id;

--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
SELECT products.product_name, categories.category_name, suppliers.company_name
FROM products
JOIN categories ON products.category_id = categories.category_id
JOIN suppliers ON products.supplier_id = suppliers.supplier_id;

--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış

--109. Altında ürün bulunmayan kategoriler
SELECT categories.category_id, categories.category_name
FROM categories
LEFT JOIN products ON categories.category_id = products.category_id
WHERE products.product_id IS NULL;

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
SELECT company_name 
FROM customers
WHERE contact_title = 'Manager';

--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
SELECT company_name 
FROM customers
WHERE LEFT(customer_id, 2) = 'FR' AND LENGTH(customer_id) = 5;

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
SELECT company_name 
FROM customers
WHERE phone LIKE '%(171)%';

--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
SELECT customers.contact_name AS MusteriAdi, 
customers.phone AS Telefon
FROM customers
WHERE customers.country IN ('France', 'Germany') 
AND customers.contact_title = 'Manager';


--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;

--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
SELECT customer_id, company_name, city, country
FROM customers
ORDER BY country, city;

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
SELECT first_name AS "Ad", last_name AS "Soyad",
       DATE_PART('year', CURRENT_DATE) - DATE_PART('year', birth_date) AS "Yaş"
FROM employees;


--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
SELECT order_id, order_date
FROM orders
WHERE shipped_date IS NULL AND (current_date - order_date) > 35;


--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
SELECT category_name
FROM categories
WHERE category_id = (
  SELECT category_id
  FROM products
  ORDER BY unit_price DESC
  LIMIT 1
);

--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)

--121. Konbu adlı üründen kaç adet satılmıştır.
SELECT SUM(quantity) AS total_sold
FROM order_details
WHERE product_id = (
  SELECT product_id
  FROM products
  WHERE product_name = 'Konbu'
);

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
SELECT COUNT(DISTINCT product_id) AS unique_products
FROM products
WHERE supplier_id IN (
  SELECT supplier_id
  FROM suppliers
  WHERE country = 'Japan'
);

--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
SELECT
  MAX(freight) AS max_freight,
  MIN(freight) AS min_freight,
  AVG(freight) AS avg_freight
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 1997;

--124. Faks numarası olan tüm müşterileri listeleyiniz.
SELECT company_name 
FROM customers
WHERE fax IS NOT NULL;

--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
SELECT order_id 
FROM orders
WHERE shipped_date BETWEEN '1996-07-16' AND '1996-07-30';

































