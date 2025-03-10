﻿
#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВидимостьПриСменеРежима(ЭтаФорма);
	ТекстЗапроса();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ВидимостьПриСменеРежима(ЭтаФорма);
	ТекстЗапроса();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// Исключаем из проверки реквизиты, заполнение которых стало необязательным:
	МассивНепроверяемыхРеквизитов = Новый Массив();
	Если Режим = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПутьКФайлуSQL");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ИмяСервераSQL");
		МассивНепроверяемыхРеквизитов.Добавить("ПользовательSQL");
		МассивНепроверяемыхРеквизитов.Добавить("ПарольSQL");
		МассивНепроверяемыхРеквизитов.Добавить("БазаДанныхSQL");
	КонецЕсли;
	// Удаляем из проверяемых реквизитов все, по которым автоматическая проверка не нужна:
	УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы 

&НаКлиенте
Процедура ПутьКФайлуSQLНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.ПолноеИмяФайла = ПутьКФайлуSQL;
	ДиалогВыбораФайла.Расширение = "csv";
	ДиалогВыбораФайла.Фильтр = "CSV (разделители - запятые)(*.csv)|*.csv";
	ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ВыборФайлаОкончание", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаОкончание(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		ПутьКФайлуSQL = ВыбранныеФайлы[0];
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура РежимПриИзменении(Элемент)
	ВидимостьПриСменеРежима(ЭтаФорма);
	ТекстЗапроса();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицы 

#КонецОбласти

#Область ОбработчикиКомандФормы 

&НаКлиенте
Процедура Сформировать(Команда)
	Если ЭтаФорма.ПроверитьЗаполнение() Тогда 
		ДеревоSQL.ПолучитьЭлементы().Очистить();
		Если Режим = 0 Тогда
			
			ЗаполнитьДеревоИзБазы();
			СформироватьНаСервере();
			
		Иначе
			
			Файл = Новый Файл(ПутьКФайлуSQL);
			Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПроверкаСуществованияОкончание", ЭтотОбъект));
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура ПроверкаСуществованияОкончание(Существует, ДополнительныеПараметры) Экспорт
	Если Существует Тогда
		Файл = Новый Файл(ПутьКФайлуSQL);
		Файл.НачатьПроверкуЭтоФайл(Новый ОписаниеОповещения("ПроверкаЭтоФайлОкончание", ЭтотОбъект));
	Иначе
		Сообщить("Файл " + ПутьКФайлуSQL + " не существует!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаЭтоФайлОкончание(ЭтоФайл, ДополнительныеПараметры) Экспорт
	Если ЭтоФайл Тогда
		ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКФайлуSQL);
		Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		СформироватьНаСервере();
		//РазвернутьДерево();
	Иначе
		Сообщить("Файл " + ПутьКФайлуSQL + " не существует!");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 
 
&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьПриСменеРежима(Форма)
	Если Форма.Режим = 0 Тогда
		Форма.Элементы.Группа_0.Видимость = Истина;	
		Форма.Элементы.Группа_1.Видимость = Ложь;	
	Иначе	
		Форма.Элементы.Группа_0.Видимость = Ложь;	
		Форма.Элементы.Группа_1.Видимость = Истина;	
	КонецЕсли;	
КонецПроцедуры

// Процедура удаляет из массива МассивРеквизитов элементы, соответствующие именам 
// реквизитов объекта из массива МассивНепроверяемыхРеквизитов.
// Для использования в обработчиках события ОбработкаПроверкиЗаполнения.
//
// Параметры:
//  МассивРеквизитов              - Массив - коллекция имен реквизитов объекта.
//  МассивНепроверяемыхРеквизитов - Массив - коллекция имен реквизитов объекта, не требующих проверки.
//
Процедура УдалитьНепроверяемыеРеквизитыИзМассива(МассивРеквизитов, МассивНепроверяемыхРеквизитов) Экспорт
	
	Для Каждого ЭлементМассива Из МассивНепроверяемыхРеквизитов Цикл
	
		ПорядковыйНомер = МассивРеквизитов.Найти(ЭлементМассива);
		Если ПорядковыйНомер <> Неопределено Тогда
			МассивРеквизитов.Удалить(ПорядковыйНомер);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	ТаблицаРасходения = ТаблицаРасходения();
	//Получаем схему из макета
	СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	// Связь между таблицей значений и именами в СКД 
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("Таблица", ТаблицаРасходения);
	
	Настройки = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	// Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;

	// Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	// Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);

	// Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);

	// Очищаем поле табличного документа
	Результат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

&НаСервере
Функция ТаблицаРасходения()
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ИмяТаблицы1С", Новый ОписаниеТипов("Строка", ,
											 Новый КвалификаторыСтроки(200, ДопустимаяДлина.Переменная))); 
	Таблица.Колонки.Добавить("ИмяТаблицыSQL", Новый ОписаниеТипов("Строка", ,
											 Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная))); 
	Таблица.Колонки.Добавить("ИмяИндекса", Новый ОписаниеТипов("Строка", ,
											 Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная))); 
	Таблица.Колонки.Добавить("ИмяПоля", Новый ОписаниеТипов("Строка", ,
											 Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная))); 
	Таблица.Колонки.Добавить("Скрипт", Новый ОписаниеТипов("Строка", ,
									   Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	Таблица.Колонки.Добавить("ВключенныеКолонки", Новый ОписаниеТипов("Строка", ,
									   Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	Таблица.Колонки.Добавить("Статус", Новый ОписаниеТипов("Строка", ,
									   Новый КвалификаторыСтроки(20, ДопустимаяДлина.Переменная)));
	Таблица.Колонки.Добавить("ПорядокПоля", Новый ОписаниеТипов("Число",
											Новый КвалификаторыЧисла(5, 0, ДопустимыйЗнак.Неотрицательный)));
							 
	Если Режим = 1 Или Режим = 2 Тогда
		ПолучитьДеревоИзФайла();	
	КонецЕсли;
	
	Дерево1С = ПолучитьДерево1С();

	ПроверенныеТаблицы = Новый Массив;
	ШаблонКластер = "
	|ALTER TABLE IF EXISTS public.%2
    |	CLUSTER ON %1";
	ШаблонВключенныхКолонок = "	INCLUDE(%1)";
	Для каждого СтрТаблица_SQL Из ДеревоSQL.ПолучитьЭлементы() Цикл
		ДанныеСтроки = Неопределено;
		СтрТаблица_1С = Дерево1С.Строки.Найти(СтрТаблица_SQL.ИмяТаблицыSQL, "ИмяТаблицыSQL", Ложь);
		ПроверенныеИндексы1С = Новый Массив;
		ПроверенныеТаблицы.Добавить(СтрТаблица_SQL.ИмяТаблицыSQL);
		Для каждого СтрИндекс_SQL Из СтрТаблица_SQL.ПолучитьЭлементы() Цикл
			СовпадениеИндекса = Ложь;
			Если СтрТаблица_1С = Неопределено Тогда
				СтрИндекса_1С = Неопределено;	
			ИначеЕсли СтрТаблица_1С.Строки.Найти(СтрИндекс_SQL.Поля, "Поля") = Неопределено Тогда
				СтрИндекса_1С = СтрТаблица_1С.Строки.Найти(СтрИндекс_SQL.ИмяИндексаДляПоиска, "ИмяИндексаДляПоиска");
			ИначеЕсли Не ЗначениеЗаполнено(СтрИндекс_SQL.ВключенныеКолонки) Тогда
				СовпадениеИндекса = Истина;
			КонецЕсли;
			Если СовпадениеИндекса Тогда
				ПроверенныеИндексы1С.Добавить(СтрИндекс_SQL.Поля);
			Иначе
				ДанныеСтроки = Новый Структура("ИмяТаблицыSQL,ИмяИндекса,Статус,Скрипт,ВключенныеКолонки"); 
				ДанныеСтроки.Вставить("ИмяТаблицы1С", "");
				ДанныеСтроки.ИмяТаблицыSQL 		= СтрТаблица_SQL.ИмяТаблицыSQL;
				ДанныеСтроки.ИмяИндекса 		= СтрИндекс_SQL.ИмяИндекса;
				ДанныеСтроки.ВключенныеКолонки 	= СтрИндекс_SQL.ВключенныеКолонки;
				Если СтрТаблица_1С <> Неопределено Тогда
					ДанныеСтроки.ИмяТаблицы1С = СтрТаблица_1С.ИмяТаблицы1С;
				КонецЕсли;
				
				Если Режим <> 2 Тогда
					Поля = СтрЗаменить(СтрИндекс_SQL.Поля, ",", " ASC NULLS LAST, ") + " ASC NULLS LAST" ;
					Если СтрИндекса_1С = Неопределено Тогда
						Параметр4 = "--";
					Иначе
						Параметр4 = "";
					КонецЕсли;
					Если СтрИндекс_SQL.ТипИндекса = "Clustered index" Тогда
						Параметр5 = СтрШаблон(ШаблонКластер,ДанныеСтроки.ИмяИндекса, ДанныеСтроки.ИмяТаблицыSQL);
					Иначе	
						Параметр5 = "";
					КонецЕсли;
					Если ЗначениеЗаполнено(СтрИндекс_SQL.ВключенныеКолонки) Тогда
						Параметр6 = СтрШаблон(ШаблонВключенныхКолонок,СтрЗаменить(СтрИндекс_SQL.ВключенныеКолонки, ",", ", "));
					Иначе	
						Параметр6 = "";
					КонецЕсли;
					ДанныеСтроки.Скрипт = СтрШаблон(ШаблонСкрипта(), ДанныеСтроки.ИмяИндекса, ДанныеСтроки.ИмяТаблицыSQL, Поля, Параметр4, Параметр5, Параметр6);
				Иначе
					ДанныеСтроки.Скрипт = "";
				КонецЕсли;
				ДанныеСтроки.Статус = "Добавлен";
				
				Сч = 1;
				Для каждого Поле Из СтрРазделить(СтрИндекс_SQL.Поля, ",") Цикл
					НоваяСтрока = Таблица.Добавить(); 
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
					НоваяСтрока.ИмяПоля = Поле;
					НоваяСтрока.ПорядокПоля = Сч;
					Сч = Сч + 1;
				КонецЦикла;
				
				Если СтрИндекса_1С <> Неопределено Тогда
					ДанныеСтроки.Скрипт = "";
					ДанныеСтроки.ВключенныеКолонки = "";
					ДанныеСтроки.Статус = "Удален";  
					ПроверенныеИндексы1С.Добавить(СтрИндекса_1С.Поля);
					Для Сч = 1 По СтрИндекса_1С.Строки.Количество() Цикл
						НоваяСтрока = Таблица.Добавить(); 
						ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
						НоваяСтрока.ИмяПоля = СтрИндекса_1С.Строки[Сч - 1].ИмяПоля;	
						НоваяСтрока.ПорядокПоля = Сч;
					КонецЦикла;
				КонецЕсли;
				
			КонецЕсли;	
		КонецЦикла;		
		
		// Проход по индексам 1С, которые отсутстсвуют в СКЛ по этой же таблице
		Если СтрТаблица_1С <> Неопределено Тогда
			Для Каждого СтрИндекса_1С Из СтрТаблица_1С.Строки Цикл
				Если ПроверенныеИндексы1С.Найти(СтрИндекса_1С.Поля) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
					
				Если ДанныеСтроки = Неопределено Тогда
					ДанныеСтроки = Новый Структура; 
					ДанныеСтроки.Вставить("ИмяТаблицыSQL", СтрТаблица_SQL.ИмяТаблицыSQL);
					ДанныеСтроки.Вставить("ИмяТаблицы1С", СтрТаблица_1С.ИмяТаблицы1С);
				Иначе
					ДанныеСтроки.Вставить("Скрипт", "");
					ДанныеСтроки.Вставить("ВключенныеКолонки", "");
				КонецЕсли;

				ДополнитьНедостающимиИндексами(Таблица, ДанныеСтроки, СтрИндекса_1С);
	
			КонецЦикла;	
		КонецЕсли;
	КонецЦикла;
	
	// Проход по таблицам 1с, которых не было в SQL. Теоретически такого не может быть
	Для Каждого СтрТаблица_1С Из Дерево1С.Строки Цикл
		ДанныеСтроки = Неопределено;
		Если ПроверенныеТаблицы.Найти(СтрТаблица_1С.ИмяТаблицыSQL) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДанныеСтроки = Неопределено Тогда
			ДанныеСтроки = Новый Структура;
			ДанныеСтроки.Вставить("ИмяТаблицыSQL", СтрТаблица_1С.ИмяТаблицыSQL);
			ДанныеСтроки.Вставить("ИмяТаблицы1С", СтрТаблица_1С.ИмяТаблицы1С);
		КонецЕсли;
					
		Для Каждого СтрИндекса_1С Из СтрТаблица_1С.Строки Цикл
			ДополнитьНедостающимиИндексами(Таблица, ДанныеСтроки, СтрИндекса_1С);
		КонецЦикла;
			
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции


&НаСервере
Функция ШаблонСкрипта()
	ШаблонСкрипта = "-- Index: %1
	|%4 DROP INDEX IF EXISTS public.%1;
    |
	|CREATE UNIQUE INDEX IF NOT EXISTS %1
    |	ON public.%2 USING btree
    |	(%3)
	|%6	TABLESPACE pg_default;
	|%5";
	Возврат ШаблонСкрипта;
КонецФункции


&НаСервере
Процедура ДополнитьНедостающимиИндексами(Таблица, ДанныеСтроки, СтрИндекса_1С)
	
	ДанныеСтроки.Вставить("ИмяИндекса", СтрИндекса_1С.ИмяИндекса);
	ДанныеСтроки.Вставить("Статус", "Удален");
	
	Если Режим = 2 Тогда
		
		Поля = СтрЗаменить(СтрИндекса_1С.Поля, ",", " ASC NULLS LAST, ") + " ASC NULLS LAST" ;
		Параметр4 = "--";
		Параметр5 = "";
		Параметр6 = "";
		ДанныеСтроки.Вставить("Скрипт", СтрШаблон(ШаблонСкрипта(), ДанныеСтроки.ИмяИндекса, ДанныеСтроки.ИмяТаблицыSQL, Поля, Параметр4, Параметр5, Параметр6));
		
	КонецЕсли;
	
	
	Сч = 1;
	Для каждого СтрокаПоля_1С Из СтрИндекса_1С.Строки Цикл
		НоваяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
		НоваяСтрока.ИмяПоля = СтрокаПоля_1С.ИмяПоля;	
		НоваяСтрока.ПорядокПоля = Сч;
		Сч = Сч + 1;
	КонецЦикла;	
КонецПроцедуры


&НаСервере
Процедура ПолучитьДеревоИзФайла()
	
	ИмяВремФайла = ПолучитьИмяВременногоФайла("csv");
	ПолучитьИзВременногоХранилища(Адрес).Записать(ИмяВремФайла);
	ЧтениеТекста = Новый ЧтениеТекста(ИмяВремФайла);
	ТекТаблица = "";
	СтрИндекс = Неопределено;
	Пока Истина Цикл
		Строка = НРег(ЧтениеТекста.ПрочитатьСтроку());
		Если Строка = Неопределено Или ПустаяСтрока(Строка) Тогда
			Прервать;	
		КонецЕсли;
		Строка = СтрЗаменить(Строка, """,""", ";");
		Строка = СтрЗаменить(Строка, ",""", ";");
		Строка = СтрЗаменить(Строка, """,", ";");
		Строка = СтрЗаменить(Строка, """", "");
		Массив = СтрРазделить(Строка, ";", Истина);
		Если Массив[0] = "table_name" Тогда
			Продолжить;	
		КонецЕсли;
		Если Массив[0] <> ТекТаблица Тогда
			СтрТаблица = ДеревоSQL.ПолучитьЭлементы().Добавить();
			СтрТаблица.ИмяТаблицыSQL = Массив[0];
			ТекТаблица = Массив[0];
		КонецЕсли;
		СтрИндекс = СтрТаблица.ПолучитьЭлементы().Добавить();
		СтрИндекс.ИдИндекса = Формат(Массив[1], "ЧГ=0");
		СтрИндекс.ИмяИндекса = Массив[2];
		СтрИндекс.ТипИндекса = Массив[5];
		СтрИндекс.Уникальный = Массив[6] = "Unique";
		СтрИндекс.ИмяИндексаДляПоиска = СтрИндекс.ИмяИндекса;
		СтрИндекс.Поля = Массив[3];
		СтрИндекс.ВключенныеКолонки = Массив[4];
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДерево1С()
	
	ТЗБД=ПолучитьСтруктуруХраненияБазыДанных(,Истина);
	Дерево1С = Новый ДеревоЗначений;
	Дерево1С.Колонки.Добавить("ИмяТаблицы1С");
	Дерево1С.Колонки.Добавить("ИмяТаблицыSQL");
	Дерево1С.Колонки.Добавить("ИмяИндекса");
	Дерево1С.Колонки.Добавить("ИмяИндексаДляПоиска");
	Дерево1С.Колонки.Добавить("ИдИндекса");
	Дерево1С.Колонки.Добавить("ИмяПоля");
	Дерево1С.Колонки.Добавить("ИдПоля");
	Дерево1С.Колонки.Добавить("Поля");
	Для каждого СтрокаТаблицы Из ТЗБД Цикл
		Если СтрокаТаблицы.Индексы.Количество() = 0 Тогда
			Продолжить;	
		КонецЕсли;
		СтрТаблица = Дерево1С.Строки.Добавить();
		СтрТаблица.ИмяТаблицы1С = ?(ЗначениеЗаполнено(СтрокаТаблицы.Метаданные), СтрокаТаблицы.Метаданные, СтрокаТаблицы.Назначение);
		СтрТаблица.ИмяТаблицыSQL = НРег(СтрокаТаблицы.ИмяТаблицыХранения);                                                   
		ИдИндекса = 1;
		Для каждого СтрокаИндекса Из СтрокаТаблицы.Индексы Цикл
			СтрИндекс = СтрТаблица.Строки.Добавить();
			СтрИндекс.ИдИндекса = ИдИндекса;
			СтрИндекс.ИмяИндекса = НРег(СтрокаИндекса.ИмяИндексаХранения);
			СтрИндекс.ИмяИндексаДляПоиска = НРег(СтрокаИндекса.ИмяИндексаХранения);
			ИдПоля = 1;
			Поля = "";
			Для каждого СтрокаПоля Из СтрокаИндекса.Поля Цикл
				НоваяСтрока = СтрИндекс.Строки.Добавить();
				НоваяСтрока.ИмяПоля = СтрокаПоля.ИмяПоляХранения;
				НоваяСтрока.ИдПоля = ИдПоля;
				Поля = Поля + ?(ПустаяСтрока(Поля), "", ",") + НРег(НоваяСтрока.ИмяПоля);
				ИдПоля = ИдПоля + 1;
			КонецЦикла;	
			СтрИндекс.Поля = НРег(Поля);	
			ИдИндекса = ИдИндекса + 1;
		КонецЦикла;	
	КонецЦикла;

	Возврат Дерево1С;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьДеревоИзБазы()
	
	/////////////////////////////////////////
    //Подключение к SQL-серверу
    Попытка
        Соединение  = Новый COMОбъект("ADODB.Connection");
        Команда     = Новый COMОбъект("ADODB.Command");
        Выборка     = Новый COMОбъект("ADODB.RecordSet");
        Соединение.ConnectionString =
            "driver={SQL Server};" +
            "server="+ИмяСервераSQL+";"+
            "uid="+ПользовательSQL+";"+
            "pwd="+ПарольSQL+";"+
            "database="+БазаДанныхSQL+";";
        Соединение.ConnectionTimeout = 30;
        Соединение.CommandTimeout = 600;
        Соединение.Open();
        Команда.ActiveConnection   = Соединение;
    Исключение
        Сообщить(ОписаниеОшибки());
        Возврат;
    КонецПопытки;

    /////////////////////////////////////////
    //Читаем записи
    Попытка
        Команда.CommandText = ТекстЗапроса;
        Выборка = Команда.Execute();
        Если Выборка.BOF = Ложь Тогда
            Выборка.MoveFirst();
			ТекТаблица = "";
			Пока Выборка.EOF = Ложь Цикл
				
				Если Выборка.Fields("table_name").value <> ТекТаблица Тогда
					СтрТаблица = ДеревоSQL.ПолучитьЭлементы().Добавить();
					СтрТаблица.ИмяТаблицыSQL = НРег(Выборка.Fields("table_name").value);
					ТекТаблица = Выборка.Fields("table_name").value;
				КонецЕсли;
				СтрИндекс = СтрТаблица.ПолучитьЭлементы().Добавить();
				СтрИндекс.Поля = НРег(Выборка.Fields("columns").value);
				СтрИндекс.ВключенныеКолонки = НРег(Выборка.Fields("included_columns").value);
				СтрИндекс.ИдИндекса =Формат(Выборка.Fields("index_id").value, "ЧГ=0");
				СтрИндекс.ИмяИндекса = НРег(Выборка.Fields("index_name").value);
				СтрИндекс.ТипИндекса = Выборка.Fields("index_type").value;
				СтрИндекс.Уникальный = Выборка.Fields("unique").value = "Unique";
				СтрИндекс.ИмяИндексаДляПоиска = НРег(СтрИндекс.ИмяИндекса);

				Выборка.MoveNext();
            КонецЦикла;
        КонецЕсли;
    Исключение
        Сообщить(ОписаниеОшибки());
		ЗакрытьСоединение(Соединение); 
		Возврат;
	КонецПопытки;

	ЗакрытьСоединение(Соединение);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСоединение(Соединение)

    Попытка
        Соединение.Close();
    Исключение
        Сообщить("Ошибка закрытия соединения " + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ТекстЗапроса()
	Обработка = РеквизитФормыВЗначение("Отчет");
	Если Режим = 0 Или Режим = 1 Тогда
		Макет = Обработка.ПолучитьМакет("Запрос_MSSQL");
	Иначе
		Макет = Обработка.ПолучитьМакет("Запрос_PG");
	КонецЕсли;	
	ТекстЗапроса = Макет.ПолучитьТекст();	
КонецПроцедуры

#КонецОбласти