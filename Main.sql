SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE autocomplect_queries AS
    PROCEDURE query_28;
    PROCEDURE query_29;
    PROCEDURE query_30;
    PROCEDURE query_31;
    PROCEDURE query_32;
    PROCEDURE query_33;
    PROCEDURE query_34;
    PROCEDURE query_35;
    PROCEDURE query_36;
    PROCEDURE query_37;
    PROCEDURE query_38;
    PROCEDURE query_39;
    PROCEDURE query_40;
    PROCEDURE query_41;
    PROCEDURE query_42;
    PROCEDURE query_43;
    PROCEDURE query_44;
    PROCEDURE query_45;
    PROCEDURE query_46;
    PROCEDURE query_47;
    PROCEDURE query_48;
    PROCEDURE query_49;
    PROCEDURE query_50;
    PROCEDURE query_51;
    PROCEDURE query_52;
END autocomplect_queries;
/

CREATE OR REPLACE PACKAGE BODY autocomplect_queries AS

    -- 28. Госномер, дата последнего обращения, количество заменённых запчастей (если были)
    PROCEDURE query_28 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 28: Выбрать госномер автомобиля, дату последнего обращения и, если были замены запчастей, то их количество.');
        DBMS_OUTPUT.PUT_LINE('Госномер     | Дата обращения | Кол-во запчастей');
        DBMS_OUTPUT.PUT_LINE('-------------|----------------|------------------');
        FOR r IN (
            SELECT 
                c.license_plate,
                MAX(ro.order_date) AS last_visit,
                COALESCE(SUM(rp.quantity), 0) AS parts_count
            FROM car c
            LEFT JOIN repair_order ro ON c.id_car = ro.id_car
            LEFT JOIN repair_part rp ON ro.id_repair_order = rp.id_repair_order
            GROUP BY c.license_plate
            ORDER BY c.license_plate
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(NVL(r.license_plate, 'NULL'), 12) || ' | ' ||
                TO_CHAR(r.last_visit, 'DD.MM.YY') || '        | ' ||
                LPAD(r.parts_count, 16)
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 29. Госномер, дата последнего обращения, наименования запчастей
    PROCEDURE query_29 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 29: Выбрать госномер автомобиля, дату последнего обращения и, если были замены запчастей, то наименования запчастей.');
        DBMS_OUTPUT.PUT_LINE('Госномер     | Дата обращения | Запчасти');
        DBMS_OUTPUT.PUT_LINE('-------------|----------------|----------------------------------------');
        FOR r IN (
            SELECT 
                c.license_plate,
                MAX(ro.order_date) AS last_visit,
                LISTAGG(p.name, ', ') WITHIN GROUP (ORDER BY p.name) AS parts_list
            FROM car c
            LEFT JOIN repair_order ro ON c.id_car = ro.id_car
            LEFT JOIN repair_part rp ON ro.id_repair_order = rp.id_repair_order
            LEFT JOIN part p ON rp.id_part = p.id_part
            GROUP BY c.license_plate
            ORDER BY c.license_plate
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(NVL(r.license_plate, 'NULL'), 12) || ' | ' ||
                TO_CHAR(r.last_visit, 'DD.MM.YY') || '        | ' ||
                SUBSTR(NVL(r.parts_list, 'нет запчастей'), 1, 40)
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 30. Марки и модели, которых нет в БД
    PROCEDURE query_30 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 30: Выбрать название марки и название моделей, автомобили которых не представлены в БД.');
        DBMS_OUTPUT.PUT_LINE('Марка        | Модель');
        DBMS_OUTPUT.PUT_LINE('-------------|------------------');
        FOR r IN (
            SELECT b.name AS brand_name, m.name AS model_name
            FROM brand b
            CROSS JOIN model m
            WHERE NOT EXISTS (
                SELECT 1 FROM car c WHERE c.id_brand = b.id_brand AND c.id_model = m.id_model
            )
            ORDER BY b.name, m.name
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(NVL(r.brand_name, 'NULL'), 12) || ' | ' ||
                r.model_name
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 31. Автомобиль, которому каждый раз меняют одну и ту же запчасть
    PROCEDURE query_31 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 31: Выбрать номер автомобиля, которому каждый раз делают замену одной и той же запчасти.');
        DBMS_OUTPUT.PUT_LINE('Госномер');
        DBMS_OUTPUT.PUT_LINE('--------');
        FOR r IN (
            SELECT c.license_plate
            FROM car c
            JOIN repair_order ro ON c.id_car = ro.id_car
            JOIN repair_part rp ON ro.id_repair_order = rp.id_repair_order
            GROUP BY c.id_car, c.license_plate
            HAVING COUNT(DISTINCT rp.id_part) = 1 AND COUNT(*) > 1
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.license_plate);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 32. Для каждого поставщика — категории, которые он НЕ поставляет
    PROCEDURE query_32 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 32: Для каждого поставщика вывести названия категорий запчастей, которые он не поставляет.');
        DBMS_OUTPUT.PUT_LINE('Поставщик               | Категория');
        DBMS_OUTPUT.PUT_LINE('------------------------|------------------');
        FOR r IN (
            SELECT s.name AS supplier, pc.name AS missing_category
            FROM supplier s
            CROSS JOIN part_category pc
            WHERE NOT EXISTS (
                SELECT 1
                FROM supply_order so
                JOIN supply_order_item soi ON so.id_supply_order = soi.id_supply_order
                JOIN part p ON soi.id_part = p.id_part
                WHERE so.id_supplier = s.id_supplier AND p.id_part_category = pc.id_part_category
            )
            ORDER BY s.name, pc.name
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(NVL(r.supplier, 'NULL'), 23) || ' | ' ||
                r.missing_category
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 33. Мастера: сначала без заказов в текущем месяце, потом макс заказов, потом остальные
    PROCEDURE query_33 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 33: Выбрать  фамилии,  имена,  отчества  мастеров  и  размер ставки.  Результат  отсортировать  следующим  образом:  в  первую очередь тех, кто не выполнил ни одного заказа за текущий месяц, затем тех, кто выполнил максимальное количество заказов за текущий месяц, в последнюю очередь все остальные.');
        DBMS_OUTPUT.PUT_LINE('ФИО мастера                     | Ставка');
        DBMS_OUTPUT.PUT_LINE('--------------------------------|--------');
        FOR r IN (
            SELECT m.surname, m.name, m.patronymic, m.rate_share,
                   COUNT(ro.id_repair_order) AS orders_count
            FROM master m
            LEFT JOIN repair_order ro ON m.id_master = ro.id_master
                AND EXTRACT(YEAR FROM ro.order_date) = EXTRACT(YEAR FROM SYSDATE)
                AND EXTRACT(MONTH FROM ro.order_date) = EXTRACT(MONTH FROM SYSDATE)
            GROUP BY m.id_master, m.surname, m.name, m.patronymic, m.rate_share
            ORDER BY 
                CASE WHEN COUNT(ro.id_repair_order) = 0 THEN 0
                     WHEN COUNT(ro.id_repair_order) = (
                         SELECT MAX(cnt) FROM (
                             SELECT COUNT(*) AS cnt
                             FROM repair_order
                             WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM SYSDATE)
                               AND EXTRACT(MONTH FROM order_date) = EXTRACT(MONTH FROM SYSDATE)
                             GROUP BY id_master
                         )
                     ) THEN 1
                     ELSE 2
                END,
                orders_count DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(NVL(r.surname || ' ' || r.name || ' ' || NVL(r.patronymic, ''), 'NULL'), 31) || ' | ' ||
                LPAD(TO_CHAR(r.rate_share, '990.00'), 6)
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 34. Для каждого поставщика — все категории + кол-во запчастей (0 если нет)
    PROCEDURE query_34 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 34: Для каждого поставщика выбрать названия всех категорий запчастей и количество различных запчастей...');
        DBMS_OUTPUT.PUT_LINE('Поставщик               | Категория        | Кол-во');
        DBMS_OUTPUT.PUT_LINE('------------------------|------------------|-------');
        FOR r IN (
            SELECT 
                s.name AS supplier,
                pc.name AS category,
                COALESCE(COUNT(DISTINCT p.id_part), 0) AS part_count
            FROM supplier s
            CROSS JOIN part_category pc
            LEFT JOIN supply_order so ON s.id_supplier = so.id_supplier
            LEFT JOIN supply_order_item soi ON so.id_supply_order = soi.id_supply_order
            LEFT JOIN part p ON soi.id_part = p.id_part AND p.id_part_category = pc.id_part_category
            GROUP BY s.id_supplier, s.name, pc.id_part_category, pc.name
            ORDER BY s.id_supplier, pc.name
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(NVL(r.supplier, 'NULL'), 23) || ' | ' ||
                RPAD(NVL(r.category, 'NULL'), 16) || ' | ' ||
                LPAD(r.part_count, 5)
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 35. Владельцы с двумя авто одной модели
    PROCEDURE query_35 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 35: Выбрать фамилию, имя, отчество владельца двух автомобилей одной модели.');
        DBMS_OUTPUT.PUT_LINE('ФИО владельца');
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
        FOR r IN (
            SELECT o.surname, o.name, o.patronymic
            FROM owner o
            JOIN car c ON o.id_owner = c.id_owner
            GROUP BY o.id_owner, o.surname, o.name, o.patronymic
            HAVING COUNT(*) >= 2
               AND COUNT(DISTINCT c.id_model) = 1
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.surname || ' ' || r.name || ' ' || NVL(r.patronymic, ''));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 36. Авто одной модели и года, отремонтированные одинаковое число раз
    PROCEDURE query_36 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 36: Выбрать госномера, названия модели и марки автомобилей одной модели и одного года выпуска, которые ремонтировались одинаковое количество раз.');
        DBMS_OUTPUT.PUT_LINE('Госномер     | Марка   | Модель');
        DBMS_OUTPUT.PUT_LINE('-------------|---------|--------');
        FOR r IN (
            SELECT c.license_plate, b.name AS brand, m.name AS model
            FROM car c
            JOIN model m ON c.id_model = m.id_model
            JOIN brand b ON c.id_brand = b.id_brand
            JOIN (
                SELECT id_car, COUNT(*) AS cnt
                FROM repair_order
                GROUP BY id_car
            ) ro ON c.id_car = ro.id_car
            WHERE EXISTS (
                SELECT 1
                FROM car c2
                JOIN (
                    SELECT id_car, COUNT(*) AS cnt
                    FROM repair_order
                    GROUP BY id_car
                ) ro2 ON c2.id_car = ro2.id_car
                WHERE c2.id_model = c.id_model
                  AND c2.year = c.year
                  AND ro2.cnt = ro.cnt
                  AND c2.id_car != c.id_car
            )
            ORDER BY b.name, m.name, c.license_plate
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.license_plate, 12) || ' | ' ||
                RPAD(r.brand, 7) || ' | ' ||
                r.model
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 37. Самая часто ремонтируемая марка+модель
    PROCEDURE query_37 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 37: Выбрать название марки и модели, автомобили которой ремонтировались чаще других.');
        DBMS_OUTPUT.PUT_LINE('Марка   | Модель');
        DBMS_OUTPUT.PUT_LINE('--------|--------');
        FOR r IN (
            SELECT b.name AS brand, m.name AS model
            FROM car c
            JOIN brand b ON c.id_brand = b.id_brand
            JOIN model m ON c.id_model = m.id_model
            JOIN repair_order ro ON c.id_car = ro.id_car
            GROUP BY b.name, m.name
            ORDER BY COUNT(*) DESC
            FETCH FIRST 1 ROW ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.brand, 7) || ' | ' || r.model);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 38. Авто без замены запчастей
    PROCEDURE query_38 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 38: Выбрать все данные об автомобилях, для которых не производились замены запчастей.');
        DBMS_OUTPUT.PUT_LINE('Госномер     | Год | Марка   | Модель  | Владелец');
        DBMS_OUTPUT.PUT_LINE('-------------|-----|---------|---------|----------');
        FOR r IN (
            SELECT c.license_plate, c.year, b.name AS brand, m.name AS model, o.surname
            FROM car c
            JOIN brand b ON c.id_brand = b.id_brand
            JOIN model m ON c.id_model = m.id_model
            JOIN owner o ON c.id_owner = o.id_owner
            LEFT JOIN repair_order ro ON c.id_car = ro.id_car
            LEFT JOIN repair_part rp ON ro.id_repair_order = rp.id_repair_order
            WHERE rp.id_repair_order IS NULL
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.license_plate, 12) || ' | ' ||
                LPAD(r.year, 3) || ' | ' ||
                RPAD(r.brand, 7) || ' | ' ||
                RPAD(r.model, 7) || ' | ' ||
                r.surname
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 39. Заказ с самым долгим сроком исполнения
    PROCEDURE query_39 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 39: Выбрать все данные о заказе с самым продолжительным сроком исполнения.');
        DBMS_OUTPUT.PUT_LINE('ID заказа | Авто       | Длительность (дн)');
        DBMS_OUTPUT.PUT_LINE('----------|------------|-------------------');
        FOR r IN (
            SELECT ro.id_repair_order, c.license_plate, (ro.actual_completion - ro.order_date) AS duration
            FROM repair_order ro
            JOIN car c ON ro.id_car = c.id_car
            WHERE ro.actual_completion IS NOT NULL
            ORDER BY (ro.actual_completion - ro.order_date) DESC
            FETCH FIRST 1 ROW ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                LPAD(r.id_repair_order, 9) || ' | ' ||
                RPAD(r.license_plate, 10) || ' | ' ||
                LPAD(r.duration, 18)
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 40. Самый дорогой заказ — владелец и авто
    PROCEDURE query_40 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 40: Выбрать фамилию, имя, отчество владельца, госномер автомобиля, на который был сделан самый дорогой заказ.');
        DBMS_OUTPUT.PUT_LINE('ФИО владельца               | Госномер');
        DBMS_OUTPUT.PUT_LINE('----------------------------|----------');
        FOR r IN (
            SELECT o.surname, o.name, o.patronymic, c.license_plate
            FROM repair_order ro
            JOIN car c ON ro.id_car = c.id_car
            JOIN owner o ON c.id_owner = o.id_owner
            ORDER BY ro.total_cost DESC
            FETCH FIRST 1 ROW ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.surname || ' ' || r.name || ' ' || NVL(r.patronymic, ''), 27) || ' | ' ||
                r.license_plate
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 41. Самая часто меняющаяся запчасть для модели
    PROCEDURE query_41 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 41: Выбрать название марки, название модели и название запчасти, которую приходится менять для данной модели чаще других.');
        DBMS_OUTPUT.PUT_LINE('Марка   | Модель  | Запчасть');
        DBMS_OUTPUT.PUT_LINE('--------|---------|------------------------');
        FOR r IN (
            SELECT b.name AS brand, m.name AS model, p.name AS part
            FROM repair_part rp
            JOIN repair_order ro ON rp.id_repair_order = ro.id_repair_order
            JOIN car c ON ro.id_car = c.id_car
            JOIN brand b ON c.id_brand = b.id_brand
            JOIN model m ON c.id_model = m.id_model
            JOIN part p ON rp.id_part = p.id_part
            GROUP BY b.name, m.name, p.name
            ORDER BY COUNT(*) DESC
            FETCH FIRST 1 ROW ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.brand, 7) || ' | ' ||
                RPAD(r.model, 7) || ' | ' ||
                SUBSTR(r.part, 1, 22)
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 42. За последний год: просроченные / в срок / раньше срока
    PROCEDURE query_42 IS
        v_year NUMBER := EXTRACT(YEAR FROM SYSDATE);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 42: Для последнего года выбрать количество просроченных заказов, в срок, раньше срока.');
        DBMS_OUTPUT.PUT_LINE('Тип заказа                | Кол-во');
        DBMS_OUTPUT.PUT_LINE('--------------------------|-------');
        FOR r IN (
            SELECT 'Просроченные заказы' AS type, COUNT(*) AS cnt
            FROM repair_order
            WHERE EXTRACT(YEAR FROM order_date) = v_year
              AND actual_completion > planned_completion
            UNION ALL
            SELECT 'Заказы в срок', COUNT(*)
            FROM repair_order
            WHERE EXTRACT(YEAR FROM order_date) = v_year
              AND actual_completion = planned_completion
            UNION ALL
            SELECT 'Заказы раньше срока', COUNT(*)
            FROM repair_order
            WHERE EXTRACT(YEAR FROM order_date) = v_year
              AND actual_completion < planned_completion
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.type, 25) || ' | ' || LPAD(r.cnt, 5));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 43. По месяцам — статистика выполнения
    PROCEDURE query_43 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 43: Для каждого месяца выбрать количество просроченных заказов, в срок, раньше срока.');
        DBMS_OUTPUT.PUT_LINE('Месяц      | Тип заказа            | Кол-во');
        DBMS_OUTPUT.PUT_LINE('-----------|-----------------------|-------');
        FOR r IN (
            SELECT 
                TO_CHAR(order_date, 'Mon') AS month_abbr,
                CASE 
                    WHEN actual_completion > planned_completion THEN 'Просроченные заказы'
                    WHEN actual_completion = planned_completion THEN 'Заказы в срок'
                    ELSE 'Заказы раньше срока'
                END AS status,
                COUNT(*) AS cnt
            FROM repair_order
            WHERE actual_completion IS NOT NULL
            GROUP BY TO_CHAR(order_date, 'Mon'), 
                     CASE 
                         WHEN actual_completion > planned_completion THEN 'Просроченные заказы'
                         WHEN actual_completion = planned_completion THEN 'Заказы в срок'
                         ELSE 'Заказы раньше срока'
                     END
            ORDER BY MIN(order_date)
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.month_abbr, 10) || ' | ' ||
                RPAD(r.status, 21) || ' | ' ||
                LPAD(r.cnt, 5)
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 44. Авто, на котором ни одну запчасть не меняли дважды
    PROCEDURE query_44 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 44: Выбрать автомобиль, на котором ни одну запчасть не меняли дважды.');
        DBMS_OUTPUT.PUT_LINE('Госномер');
        DBMS_OUTPUT.PUT_LINE('--------');
        FOR r IN (
            SELECT c.license_plate
            FROM car c
            JOIN repair_order ro ON c.id_car = ro.id_car
            JOIN repair_part rp ON ro.id_repair_order = rp.id_repair_order
            GROUP BY c.id_car, c.license_plate
            HAVING MAX(rp.quantity) = 1 AND COUNT(*) = COUNT(DISTINCT rp.id_part)
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.license_plate);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 45. Мастер, чинивший авто всех категорий
    PROCEDURE query_45 IS
        v_total_categories NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total_categories FROM category;
        DBMS_OUTPUT.PUT_LINE('Задание 45: Выбрать фамилию, имя, отчество мастера, который чинил автомобили всех категорий.');
        DBMS_OUTPUT.PUT_LINE('ФИО мастера');
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
        FOR r IN (
            SELECT m.surname, m.name, m.patronymic
            FROM master m
            JOIN repair_order ro ON m.id_master = ro.id_master
            JOIN car c ON ro.id_car = c.id_car
            GROUP BY m.id_master, m.surname, m.name, m.patronymic
            HAVING COUNT(DISTINCT c.id_category) = v_total_categories
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.surname || ' ' || r.name || ' ' || NVL(r.patronymic, ''));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 46. Владельцы с 2 авто разных категорий, но одной марки
    PROCEDURE query_46 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 46: Выбрать фамилии, имена, отчества владельцев транспортных средств двух разных категорий, которые имеют два автомобиля одной марки.');
        DBMS_OUTPUT.PUT_LINE('ФИО владельца');
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
        FOR r IN (
            SELECT o.surname, o.name, o.patronymic
            FROM owner o
            JOIN car c ON o.id_owner = c.id_owner
            GROUP BY o.id_owner, o.surname, o.name, o.patronymic
            HAVING COUNT(*) >= 2
               AND COUNT(DISTINCT c.id_category) >= 2
               AND COUNT(DISTINCT c.id_brand) = 1
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.surname || ' ' || r.name || ' ' || NVL(r.patronymic, ''));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 47. Запчасти на самые старые авто
    PROCEDURE query_47 IS
        v_min_year NUMBER;
    BEGIN
        SELECT MIN(year) INTO v_min_year FROM car;
        DBMS_OUTPUT.PUT_LINE('Задание 47: Выбрать названия запчастей, которые устанавливались на самые старые автомобили.');
        DBMS_OUTPUT.PUT_LINE('Запчасть');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        FOR r IN (
            SELECT DISTINCT p.name
            FROM part p
            JOIN repair_part rp ON p.id_part = rp.id_part
            JOIN repair_order ro ON rp.id_repair_order = ro.id_repair_order
            JOIN car c ON ro.id_car = c.id_car
            WHERE c.year = v_min_year
            ORDER BY p.name
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(SUBSTR(r.name, 1, 40));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 48. Авто, на которых меняли и самую дорогую, и самую дешёвую запчасть
    PROCEDURE query_48 IS
        v_max_price NUMBER;
        v_min_price NUMBER;
    BEGIN
        SELECT MAX(price) INTO v_max_price FROM part;
        SELECT MIN(price) INTO v_min_price FROM part;
        DBMS_OUTPUT.PUT_LINE('Задание 48: Выбрать марку, модель, госномер автомобилей, на которых делали замену, как самой дорогой, так и самой дешевой запчасти.');
        DBMS_OUTPUT.PUT_LINE('Марка   | Модель  | Госномер');
        DBMS_OUTPUT.PUT_LINE('--------|---------|----------');
        FOR r IN (
            SELECT DISTINCT c.license_plate, b.name AS brand, m.name AS model
            FROM car c
            JOIN repair_order ro ON c.id_car = ro.id_car
            JOIN repair_part rp ON ro.id_repair_order = rp.id_repair_order
            JOIN part p ON rp.id_part = p.id_part
            JOIN brand b ON c.id_brand = b.id_brand
            JOIN model m ON c.id_model = m.id_model
            WHERE c.id_car IN (
                SELECT c1.id_car
                FROM car c1
                JOIN repair_order ro1 ON c1.id_car = ro1.id_car
                JOIN repair_part rp1 ON ro1.id_repair_order = rp1.id_repair_order
                JOIN part p1 ON rp1.id_part = p1.id_part
                WHERE p1.price = v_max_price
            )
            AND c.id_car IN (
                SELECT c2.id_car
                FROM car c2
                JOIN repair_order ro2 ON c2.id_car = ro2.id_car
                JOIN repair_part rp2 ON ro2.id_repair_order = rp2.id_repair_order
                JOIN part p2 ON rp2.id_part = p2.id_part
                WHERE p2.price = v_min_price
            )
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.brand, 7) || ' | ' ||
                RPAD(r.model, 7) || ' | ' ||
                r.license_plate
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 49. Владельцы с ≥2 авто, без тёзок/однофамильцев
    PROCEDURE query_49 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 49: Вывести фамилии, имена, отчества владельцев, которые обладают 2 автомобилями и более, но не имеют тезок и/или однофамильцев.');
        DBMS_OUTPUT.PUT_LINE('ФИО владельца');
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
        FOR r IN (
            SELECT o.surname, o.name, o.patronymic
            FROM owner o
            WHERE (SELECT COUNT(*) FROM car WHERE id_owner = o.id_owner) >= 2
              AND NOT EXISTS (
                  SELECT 1 FROM owner o2
                  WHERE o2.id_owner != o.id_owner
                    AND (o2.surname = o.surname OR o2.name = o.name)
              )
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.surname || ' ' || r.name || ' ' || NVL(r.patronymic, ''));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 50. Три самых старых авто
    PROCEDURE query_50 IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Задание 50: Выбрать тройку самых старых автомобилей.');
        DBMS_OUTPUT.PUT_LINE('Госномер     | Год выпуска');
        DBMS_OUTPUT.PUT_LINE('-------------|------------');
        FOR r IN (
            SELECT license_plate, year
            FROM car
            ORDER BY year ASC
            FETCH FIRST 3 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(r.license_plate, 12) || ' | ' || r.year);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 51. Даты прошлого месяца без замены запчастей
    PROCEDURE query_51 IS
        v_year NUMBER := EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -1));
        v_month NUMBER := EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, -1));
        v_days NUMBER;
    BEGIN
        SELECT EXTRACT(DAY FROM LAST_DAY(ADD_MONTHS(SYSDATE, -1))) INTO v_days FROM dual;
        DBMS_OUTPUT.PUT_LINE('Задание 51: Выбрать все даты прошлого месяца, в которые не осуществляли замену запчастей.');
        DBMS_OUTPUT.PUT_LINE('Дата');
        DBMS_OUTPUT.PUT_LINE('----------');
        FOR d IN 1..v_days LOOP
            DECLARE
                v_date DATE := TO_DATE(v_year || '-' || LPAD(v_month, 2, '0') || '-' || LPAD(d, 2, '0'), 'YYYY-MM-DD');
                v_exists NUMBER;
            BEGIN
                SELECT COUNT(*) INTO v_exists
                FROM repair_part rp
                JOIN repair_order ro ON rp.id_repair_order = ro.id_repair_order
                WHERE ro.order_date = v_date;
                IF v_exists = 0 THEN
                    DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_date, 'DD.MM.YYYY'));
                END IF;
            END;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

    -- 52. Поставщики: заказы в прошлом году, % от общего
    PROCEDURE query_52 IS
        v_total_orders NUMBER;
        v_year NUMBER := EXTRACT(YEAR FROM SYSDATE) - 1;
    BEGIN
        SELECT COUNT(*) INTO v_total_orders
        FROM supply_order
        WHERE EXTRACT(YEAR FROM order_date) = v_year;

        DBMS_OUTPUT.PUT_LINE('Задание 52: Выбрать названия поставщиков, количество заказов в прошлом году, процентное отношение ко всем заказам прошлого года.');
        DBMS_OUTPUT.PUT_LINE('Поставщик               | Заказов | Процент');
        DBMS_OUTPUT.PUT_LINE('------------------------|---------|--------');
        FOR r IN (
            SELECT 
                s.name,
                COUNT(so.id_supply_order) AS orders,
                ROUND(COUNT(so.id_supply_order) * 100.0 / NULLIF(v_total_orders, 0), 2) AS percent
            FROM supplier s
            LEFT JOIN supply_order so ON s.id_supplier = so.id_supplier
                AND EXTRACT(YEAR FROM so.order_date) = v_year
            GROUP BY s.id_supplier, s.name
            ORDER BY orders DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(NVL(r.name, 'NULL'), 23) || ' | ' ||
                LPAD(NVL(r.orders, 0), 7) || ' | ' ||
                LPAD(NVL(r.percent, 0), 6)
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END;

END autocomplect_queries;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(' ');
    autocomplect_queries.query_28;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_29;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_30;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_31;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_32;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_33;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_34;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_35;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_36;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_37;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_38;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_39;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_40;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_41;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_42;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_43;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_44;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_45;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_46;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_47;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_48;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_49;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_50;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_51;
    DBMS_OUTPUT.PUT_LINE(' ');
    
    autocomplect_queries.query_52;
    DBMS_OUTPUT.PUT_LINE(' ');
END;
/