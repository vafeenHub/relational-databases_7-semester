-- ==================================================================
-- 1. СПРАВОЧНИКИ
-- ==================================================================

-- Единицы измерения запчастей: id, полное название, сокращение
INSERT INTO unit VALUES (1, 'штука', 'шт');
INSERT INTO unit VALUES (2, 'комплект', 'компл');

-- Категории запчастей (для анализа и отчётов)
INSERT INTO part_category VALUES (1, 'Тормозная система');
INSERT INTO part_category VALUES (2, 'Подвеска');
INSERT INTO part_category VALUES (3, 'Электрика');

-- Категории автомобилей (легковой, внедорожник и т.д.)
INSERT INTO category VALUES (1, 'Легковой');
INSERT INTO category VALUES (2, 'Внедорожник');
INSERT INTO category VALUES (3, 'Коммерческий');

-- Типы кузовов
INSERT INTO body_type VALUES (1, 'Седан');
INSERT INTO body_type VALUES (2, 'Хэтчбек');
INSERT INTO body_type VALUES (3, 'Универсал');

-- Марки автомобилей
INSERT INTO brand VALUES (1, 'Toyota');
INSERT INTO brand VALUES (2, 'Honda');
INSERT INTO brand VALUES (3, 'Ford');
INSERT INTO brand VALUES (4, 'BMW');

-- Модели автомобилей (id, название, id_марки)
INSERT INTO model VALUES (1, 'Camry', 1);      -- Toyota
INSERT INTO model VALUES (2, 'Corolla', 1);   -- Toyota
INSERT INTO model VALUES (3, 'Civic', 2);     -- Honda
INSERT INTO model VALUES (4, 'Focus', 3);     -- Ford
INSERT INTO model VALUES (5, 'X5', 4);        -- BMW

-- ==================================================================
-- 2. ОСНОВНЫЕ СУЩНОСТИ
-- ==================================================================

-- Владельцы: (id, фамилия, имя, отчество, телефон)
INSERT INTO owner VALUES (1, 'Иванов', 'Иван', 'Иванович', '+79001112233');
INSERT INTO owner VALUES (2, 'Петров', 'Пётр', 'Петрович', '+79002223344');
INSERT INTO owner VALUES (3, 'Сидоров', 'Сергей', 'Александрович', '+79003334455');
INSERT INTO owner VALUES (4, 'Кузнецов', 'Андрей', 'Владимирович', '+79004445566');
INSERT INTO owner VALUES (5, 'Морозов', 'Дмитрий', 'Сергеевич', '+79005556677');
INSERT INTO owner VALUES (6, 'Соколов', 'Артём', 'Юрьевич', '+79006667788');
INSERT INTO owner VALUES (7, 'Лебедев', 'Михаил', 'Павлович', '+79007778899');

-- Автомобили: (id, госномер, год, id_марки, id_модели, id_категории, id_кузова, id_владельца)
INSERT INTO car VALUES (1, 'А123АА77', 2010, 1, 1, 1, 1, 1); -- Toyota Camry, Иванов И.И.
INSERT INTO car VALUES (2, 'Б456ББ77', 2015, 1, 2, 1, 1, 2); -- Toyota Corolla, Петров П.П.
INSERT INTO car VALUES (3, 'В789ВВ77', 2005, 2, 3, 1, 1, 3); -- Honda Civic, Сидоров С.А.
INSERT INTO car VALUES (4, 'Г012ГГ77', 2020, 3, 4, 1, 1, 4); -- Ford Focus, Кузнецов А.В.
INSERT INTO car VALUES (5, 'Д345ДД77', 2018, 4, 5, 2, 1, 5); -- BMW X5 (Внедорожник), Морозов Д.С.
INSERT INTO car VALUES (6, 'Е678ЕЕ77', 2018, 1, 1, 1, 1, 1); -- Toyota Camry, Иванов И.И. (второй авто)
INSERT INTO car VALUES (7, 'А124АА77', 2010, 1, 1, 1, 1, 1); -- Toyota Camry, Иванов И.И. (третий авто)
INSERT INTO car VALUES (8, 'Ж111ЖЖ77', 2016, 1, 2, 1, 1, 6); -- Toyota Corolla, Соколов А.Ю.
INSERT INTO car VALUES (9, 'К222КК77', 2019, 3, 4, 1, 1, 7); -- Ford Focus, Лебедев М.П.
INSERT INTO car VALUES (10, 'Л333ЛЛ77', 2021, 3, 5, 2, 1, 7); -- Ford X5, Лебедев М.П.
INSERT INTO car VALUES (11, 'М444ММ77', 2015, 1, 2, 1, 1, 6); -- Toyota Corolla 2015, Соколов А.Ю.

-- Мастера: (id, ФИО, телефон, дата_рождения, специализация, стаж, доля_ставки)
INSERT INTO master VALUES (1, 'Смирнов', 'Алексей', 'Олегович', '+79101112233', DATE '1985-03-12', 'Двигатель', 12, 1.0);
INSERT INTO master VALUES (2, 'Козлов', 'Дмитрий', 'Игоревич', '+79102223344', DATE '1990-07-22', 'Ходовая', 8, 0.8);
INSERT INTO master VALUES (3, 'Волков', 'Роман', 'Сергеевич', '+79103334455', DATE '1980-11-05', 'Электрика', 18, 1.0);
INSERT INTO master VALUES (4, 'Орлов', 'Максим', 'Викторович', '+79104445566', DATE '1995-01-30', 'Кузов', 5, 0.5);

-- Неисправности: (id, описание)
INSERT INTO defect VALUES (1, 'Скрип тормозов');
INSERT INTO defect VALUES (2, 'Стук подвески');
INSERT INTO defect VALUES (3, 'Не заводится');
INSERT INTO defect VALUES (4, 'Течь радиатора');
INSERT INTO defect VALUES (5, 'Потеря заряда');

-- Виды работ: (id, название)
INSERT INTO work VALUES (1, 'Замена колодок');
INSERT INTO work VALUES (2, 'Замена амортизатора');
INSERT INTO work VALUES (3, 'Диагностика генератора');
INSERT INTO work VALUES (4, 'Замена радиатора');
INSERT INTO work VALUES (5, 'Проверка АКБ');

-- Запчасти: (id, артикул, название, id_категории, характеристики, остаток, id_единицы, цена_за_единицу)
INSERT INTO part VALUES (1, 'P001', 'Колодки тормозные передние', 1, 'Для Camry 2010+', 10, 1, 2500.00);
INSERT INTO part VALUES (2, 'P002', 'Амортизатор передний', 2, 'Для Focus 2020', 5, 1, 4500.00);
INSERT INTO part VALUES (3, 'P003', 'Генератор', 3, 'Универсальный', 3, 1, 12000.00);
INSERT INTO part VALUES (4, 'P004', 'Колодки тормозные задние', 1, 'Для Corolla', 8, 1, 2200.00);
INSERT INTO part VALUES (5, 'P005', 'Радиатор', 3, 'Для X5', 2, 1, 18000.00);
INSERT INTO part VALUES (6, 'P006', 'Лампа H7', 3, 'Для всех авто', 20, 1, 200.00);
INSERT INTO part VALUES (7, 'P007', 'Турбина', 3, 'Для X5', 1, 1, 250000.00);

-- Поставщики: (id, название, адрес, телефон, ФИО_менеджера)
INSERT INTO supplier VALUES (1, 'Авто-Деталь', 'Москва, ул. Ленина 10', '+74951112233', 'Фёдоров', 'Антон', 'Валерьевич');
INSERT INTO supplier VALUES (2, 'Запчасть-Сервис', 'СПб, Невский пр. 50', '+78122223344', 'Григорьев', 'Илья', 'Сергеевич');

-- ==================================================================
-- 3. ЗАКАЗЫ ПОСТАВОК
-- ==================================================================

-- Заказы поставок: (id, id_поставщика, дата_заказа, планируемая_дата_прибытия, фактическая_дата_прибытия)
-- Заказ 1: от "Авто-Деталь", сделан 10.01.2024, прибыл на 1 день позже срока
INSERT INTO supply_order VALUES (1, 1, DATE '2024-01-10', DATE '2024-01-15', DATE '2024-01-16');
-- Заказ 2: от "Запчасть-Сервис", сделан 01.02.2024, прибыл на 1 день раньше срока
INSERT INTO supply_order VALUES (2, 2, DATE '2024-02-01', DATE '2024-02-05', DATE '2024-02-04');

-- Состав заказов поставок: (id_заказа_поставки, id_запчасти, количество, общая_стоимость_позиции)
-- Заказ 1 (Авто-Деталь):
--   - 5 шт колодок передних (5 × 2500 = 12 500)
--   - 2 шт генераторов (2 × 12 000 = 24 000)
INSERT INTO supply_order_item VALUES (1, 1, 5, 12500.00);
INSERT INTO supply_order_item VALUES (1, 3, 2, 24000.00);
-- Заказ 2 (Запчасть-Сервис):
--   - 3 шт амортизаторов (3 × 4500 = 13 500)
--   - 1 шт радиатора (1 × 18 000 = 18 000)
INSERT INTO supply_order_item VALUES (2, 2, 3, 13500.00);
INSERT INTO supply_order_item VALUES (2, 5, 1, 18000.00);

-- ==================================================================
-- 4. ЗАКАЗЫ НА РЕМОНТ
-- ==================================================================
-- Формат repair_order:
-- (id, id_авто, id_мастера, дата_заказа, планируемая_дата_выполнения, фактическая_дата_выполнения, итоговая_стоимость, комментарий)

-- АВТОМОБИЛЬ А123АА77 (Toyota Camry, Иванов И.И.) — 3 ремонта, все с колодками передними
-- Заказ 1: 10.03.2025, план — 12.03, факт — 13.03 → ПРОСРОЧЕН на 1 день
INSERT INTO repair_order VALUES (1, 1, 2, DATE '2025-03-10', DATE '2025-03-12', DATE '2025-03-13', 3000.00, 'Замена передних колодок');
-- Неисправность: Скрип тормозов (id=1)
INSERT INTO repair_defect VALUES (1, 1);
-- Работа: Замена колодок (id=1)
INSERT INTO repair_work VALUES (1, 1);
-- Запчасть: 1 шт колодок передних (id=1)
INSERT INTO repair_part VALUES (1, 1, 1);

-- Заказ 7: 01.05.2025, план — 02.05, факт — 02.05 → В СРОК → последнее обращение для А123АА77
INSERT INTO repair_order VALUES (7, 1, 2, DATE '2025-05-01', DATE '2025-05-02', DATE '2025-05-02', 3000.00, 'Повторная замена');
INSERT INTO repair_defect VALUES (7, 1);
INSERT INTO repair_work VALUES (7, 1);
INSERT INTO repair_part VALUES (7, 1, 1);

-- Заказ 23: 10.03.2025, план — 12.03, факт — 14.03 → ПРОСРОЧЕН на 2 дня (для статистики по марту)
INSERT INTO repair_order VALUES (23, 1, 1, DATE '2025-03-10', DATE '2025-03-12', DATE '2025-03-14', 3000.00, 'Просрочено 2');
INSERT INTO repair_defect VALUES (23, 1);
INSERT INTO repair_work VALUES (23, 1);
INSERT INTO repair_part VALUES (23, 1, 1);

-- АВТОМОБИЛЬ Б456ББ77 (Toyota Corolla, Петров П.П.) — 2 ремонта, оба с колодками задними
-- Заказ 2: 15.03.2025, план — 16.03, факт — 16.03 → В СРОК
INSERT INTO repair_order VALUES (2, 2, 2, DATE '2025-03-15', DATE '2025-03-16', DATE '2025-03-16', 2700.00, 'Замена задних колодок');
INSERT INTO repair_defect VALUES (2, 1);
INSERT INTO repair_work VALUES (2, 1);
INSERT INTO repair_part VALUES (2, 4, 1);

-- Заказ 19: 10.05.2025, план — 11.05, факт — 10.05 → РАНЬШЕ СРОКА → последнее обращение
INSERT INTO repair_order VALUES (19, 2, 2, DATE '2025-05-10', DATE '2025-05-11', DATE '2025-05-10', 2200.00, 'Повторная замена задних колодок');
INSERT INTO repair_defect VALUES (19, 1);
INSERT INTO repair_work VALUES (19, 1);
INSERT INTO repair_part VALUES (19, 4, 1);

-- Заказ 27: 20.05.2025, план — 22.05, факт — 22.05 → В СРОК (для статистики по маю)
INSERT INTO repair_order VALUES (27, 2, 1, DATE '2025-05-20', DATE '2025-05-22', DATE '2025-05-22', 2700.00, 'В срок (May)');
INSERT INTO repair_defect VALUES (27, 1);
INSERT INTO repair_work VALUES (27, 1);
INSERT INTO repair_part VALUES (27, 4, 1);

-- АВТОМОБИЛЬ В789ВВ77 (Honda Civic, Сидоров С.А.) — 2 ремонта генератора + 1 просроченный + 1 раньше срока
-- Заказ 3: 20.02.2025, план — 22.02, факт — 21.02 → РАНЬШЕ СРОКА
INSERT INTO repair_order VALUES (3, 3, 3, DATE '2025-02-20', DATE '2025-02-22', DATE '2025-02-21', 13000.00, 'Замена генератора');
INSERT INTO repair_defect VALUES (3, 3);
INSERT INTO repair_work VALUES (3, 3);
INSERT INTO repair_part VALUES (3, 3, 1);

-- Заказ 17: 01.03.2025, план — 03.03, факт — 01.03 → РАНЬШЕ СРОКА → последнее обращение
INSERT INTO repair_order VALUES (17, 3, 3, DATE '2025-03-01', DATE '2025-03-03', DATE '2025-03-01', 12000.00, 'Повторная замена генератора');
INSERT INTO repair_defect VALUES (17, 3);
INSERT INTO repair_work VALUES (17, 3);
INSERT INTO repair_part VALUES (17, 3, 1);

-- Заказ 15: 01.03.2025, план — 03.03, факт — 05.03 → ПРОСРОЧЕН на 2 дня
INSERT INTO repair_order VALUES (15, 3, 1, DATE '2025-03-01', DATE '2025-03-03', DATE '2025-03-05', 3000.00, 'Просрочено');
INSERT INTO repair_defect VALUES (15, 3);
INSERT INTO repair_work VALUES (15, 3);
INSERT INTO repair_part VALUES (15, 3, 1);

-- Заказ 28: 10.05.2025, план — 12.05, факт — 11.05 → РАНЬШЕ СРОКА
INSERT INTO repair_order VALUES (28, 3, 1, DATE '2025-05-10', DATE '2025-05-12', DATE '2025-05-11', 13000.00, 'Раньше срока (May)');
INSERT INTO repair_defect VALUES (28, 3);
INSERT INTO repair_work VALUES (28, 3);
INSERT INTO repair_part VALUES (28, 3, 1);

-- АВТОМОБИЛЬ Г012ГГ77 (Ford Focus, Кузнецов А.В.) — 3 ремонта амортизатора
-- Заказ 4: 01.04.2025, план — 03.04, факт — 02.04 → РАНЬШЕ СРОКА
INSERT INTO repair_order VALUES (4, 4, 2, DATE '2025-04-01', DATE '2025-04-03', DATE '2025-04-02', 5000.00, 'Замена переднего амортизатора');
INSERT INTO repair_defect VALUES (4, 2);
INSERT INTO repair_work VALUES (4, 2);
INSERT INTO repair_part VALUES (4, 2, 1);

-- Заказ 18: 01.05.2025, план — 03.05, факт — 02.05 → РАНЬШЕ СРОКА
INSERT INTO repair_order VALUES (18, 4, 2, DATE '2025-05-01', DATE '2025-05-03', DATE '2025-05-02', 4500.00, 'Повторная замена амортизатора');
INSERT INTO repair_defect VALUES (18, 2);
INSERT INTO repair_work VALUES (18, 2);
INSERT INTO repair_part VALUES (18, 2, 1);

-- Заказ 20: 15.05.2025, план — 17.05, факт — 15.05 → РАНЬШЕ СРОКА → последнее обращение
INSERT INTO repair_order VALUES (20, 4, 2, DATE '2025-05-15', DATE '2025-05-17', DATE '2025-05-15', 4500.00, 'Третья замена амортизатора');
INSERT INTO repair_defect VALUES (20, 2);
INSERT INTO repair_work VALUES (20, 2);
INSERT INTO repair_part VALUES (20, 2, 1);

-- Заказ 16: 10.03.2025, план — 12.03, факт — 11.03 → РАНЬШЕ СРОКА (для статистики по марту)
INSERT INTO repair_order VALUES (16, 4, 1, DATE '2025-03-10', DATE '2025-03-12', DATE '2025-03-11', 3000.00, 'Раньше срока');
INSERT INTO repair_defect VALUES (16, 2);
INSERT INTO repair_work VALUES (16, 2);
INSERT INTO repair_part VALUES (16, 2, 1);

-- АВТОМОБИЛЬ Д345ДД77 (BMW X5, Морозов Д.С.) — 3 разные запчасти (лампа, радиатор, турбина)
-- Заказ 10: 20.03.2025, план — 21.03, факт — 20.03 → РАНЬШЕ СРОКА → лампа H7
INSERT INTO repair_order VALUES (10, 5, 3, DATE '2025-03-20', DATE '2025-03-21', DATE '2025-03-20', 300.00, 'Замена лампы на X5');
INSERT INTO repair_defect VALUES (10, 5);
INSERT INTO repair_work VALUES (10, 5);
INSERT INTO repair_part VALUES (10, 6, 1);

-- Заказ 5: 05.04.2025, план — 07.04, факт — 06.04 → РАНЬШЕ СРОКА → радиатор
INSERT INTO repair_order VALUES (5, 5, 3, DATE '2025-04-05', DATE '2025-04-07', DATE '2025-04-06', 19000.00, 'Замена радиатора');
INSERT INTO repair_defect VALUES (5, 4);
INSERT INTO repair_work VALUES (5, 4);
INSERT INTO repair_part VALUES (5, 5, 1);

-- Заказ 9: 05.05.2025, план — 10.05, факт — 05.05 → РАНЬШЕ СРОКА → турбина (самый дорогой заказ)
INSERT INTO repair_order VALUES (9, 5, 3, DATE '2025-05-05', DATE '2025-05-10', DATE '2025-05-05', 260000.00, 'Замена турбины');
INSERT INTO repair_defect VALUES (9, 3);
INSERT INTO repair_work VALUES (9, 3);
INSERT INTO repair_part VALUES (9, 7, 1);

-- Заказ 25: 10.04.2025, план — 12.04, факт — 11.04 → РАНЬШЕ СРОКА (для статистики по апрелю)
INSERT INTO repair_order VALUES (25, 5, 1, DATE '2025-04-10', DATE '2025-04-12', DATE '2025-04-11', 19000.00, 'Раньше срока 2 (Apr)');
INSERT INTO repair_defect VALUES (25, 4);
INSERT INTO repair_work VALUES (25, 4);
INSERT INTO repair_part VALUES (25, 5, 1);

-- АВТОМОБИЛЬ Е678ЕЕ77 (Toyota Camry, Иванов И.И.) — 1 ремонт колодок
-- Заказ 21: 10.04.2025, план — 11.04, факт — 10.04 → РАНЬШЕ СРОКА → последнее обращение
INSERT INTO repair_order VALUES (21, 6, 2, DATE '2025-04-10', DATE '2025-04-11', DATE '2025-04-10', 3000.00, 'Замена передних колодок');
INSERT INTO repair_defect VALUES (21, 1);
INSERT INTO repair_work VALUES (21, 1);
INSERT INTO repair_part VALUES (21, 1, 1);

-- Заказ 24: 20.03.2025, план — 22.03, факт — 22.03 → В СРОК (для статистики по марту)
INSERT INTO repair_order VALUES (24, 6, 1, DATE '2025-03-20', DATE '2025-03-22', DATE '2025-03-22', 3000.00, 'В срок 2 (Mar)');
INSERT INTO repair_defect VALUES (24, 1);
INSERT INTO repair_work VALUES (24, 1);
INSERT INTO repair_part VALUES (24, 1, 1);

-- АВТОМОБИЛЬ М444ММ77 (Toyota Corolla 2015, Соколов А.Ю.) — 1 ремонт
-- Заказ 14: 10.01.2025, план — 11.01, факт — 10.01 → РАНЬШЕ СРОКА → последнее обращение
INSERT INTO repair_order VALUES (14, 11, 2, DATE '2025-01-10', DATE '2025-01-11', DATE '2025-01-10', 2700.00, 'Ремонт второй Corolla 2015');
INSERT INTO repair_defect VALUES (14, 1);
INSERT INTO repair_work VALUES (14, 1);
INSERT INTO repair_part VALUES (14, 4, 1);

-- Заказ 26: 20.04.2025, план — 22.04, факт — 22.04 → В СРОК (для статистики по апрелю)
INSERT INTO repair_order VALUES (26, 11, 1, DATE '2025-04-20', DATE '2025-04-22', DATE '2025-04-22', 2700.00, 'В срок 2 (Apr)');
INSERT INTO repair_defect VALUES (26, 1);
INSERT INTO repair_work VALUES (26, 1);
INSERT INTO repair_part VALUES (26, 4, 1);

-- Заказ 22: 10.02.2025, план — 12.02, факт — 12.02 → В СРОК (для статистики по февралю)
INSERT INTO repair_order VALUES (22, 2, 2, DATE '2025-02-10', DATE '2025-02-12', DATE '2025-02-12', 2700.00, 'В срок (Feb)');
INSERT INTO repair_defect VALUES (22, 1);
INSERT INTO repair_work VALUES (22, 1);
INSERT INTO repair_part VALUES (22, 4, 1);

-- АВТОМОБИЛЬ Г012ГГ77: дополнительный заказ для мастера Волкова (чтобы он работал с подвеской)
-- Заказ 12: 15.05.2025, план — 17.05, факт — 16.05 → РАНЬШЕ СРОКА, мастер Волков (id=3)
INSERT INTO repair_order VALUES (12, 4, 3, DATE '2025-05-15', DATE '2025-05-17', DATE '2025-05-16', 5000.00, 'Замена амортизатора — Волков');
INSERT INTO repair_defect VALUES (12, 2);
INSERT INTO repair_work VALUES (12, 2);
INSERT INTO repair_part VALUES (12, 2, 1);
