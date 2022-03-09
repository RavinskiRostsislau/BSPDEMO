///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// Устанавливает параметры загрузки данных из файла.
//
// Параметры:
//     Параметры - Структура:
//         * Заголовок - Строка - заголовок окна.
//         * ОбязательныеКолонки - Массив - список имен колонок обязательных для заполнения.
//         * ТипДанныхКолонки - Соответствие - Ключ - Имя колонки, Значение - Описание типа данных.
//
Процедура ОпределитьПараметрыЗагрузкиДанныхИзФайла(Параметры) Экспорт
	
	Параметры.Заголовок = НСтр("ru = 'Демо: Номенклатура'");
	
	ОписаниеТипаШтрихкод =  Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(13));
	ОписаниеТипаНаименование =  Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100));
	Параметры.ТипДанныхКолонки.Вставить("Штрихкод", ОписаниеТипаШтрихкод);
	Параметры.ТипДанныхКолонки.Вставить("Наименование", ОписаниеТипаНаименование);

КонецПроцедуры

// Производит сопоставление загружаемых данных с данными в ИБ.
//
// Параметры:
//   ЗагружаемыеДанные - ТаблицаЗначений - таблица значений с загружаемыми данными:
//     * СопоставленныйОбъект - СправочникСсылка - ссылка на сопоставленный объект. Заполняется внутри процедуры
//     * <другие колонки>     - Произвольный - состав колонок соответствует макету "ЗагрузкаИзФайла".
//
Процедура СопоставитьЗагружаемыеДанныеИзФайла(ЗагружаемыеДанные) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДляСопоставления.Штрихкод КАК Штрихкод,
	|	ДанныеДляСопоставления.Наименование КАК Наименование,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ДанныеДляСопоставления
	|ИЗ
	|	&ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДанныеДляСопоставления.Штрихкод,
	|	ДанныеДляСопоставления.Наименование,
	|	ДанныеДляСопоставления.Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	_ДемоНоменклатура.Ссылка КАК Ссылка,
	|	_ДемоНоменклатура.Штрихкод КАК Штрихкод,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ СопоставленнаяНоменклатураПоШтрихкоду
	|ИЗ
	|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник._ДемоНоменклатура КАК _ДемоНоменклатура
	|		ПО (_ДемоНоменклатура.Штрихкод = ДанныеДляСопоставления.Штрихкод)
	|			И (_ДемоНоменклатура.Штрихкод <> """")
	|			И (_ДемоНоменклатура.ПометкаУдаления = ЛОЖЬ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДляСопоставления.Наименование КАК Наименование,
	|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ ДанныеДляСопоставленияПоНаименованию
	|ИЗ
	|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СопоставленнаяНоменклатураПоШтрихкоду КАК СопоставленнаяНоменклатураПоШтрихкоду
	|		ПО ДанныеДляСопоставления.Штрихкод = СопоставленнаяНоменклатураПоШтрихкоду.Штрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	_ДемоНоменклатура.Ссылка КАК Номенклатура,
	|	ДанныеДляСопоставленияПоНаименованию.Идентификатор КАК Идентификатор
	|ИЗ
	|	ДанныеДляСопоставленияПоНаименованию КАК ДанныеДляСопоставленияПоНаименованию
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник._ДемоНоменклатура КАК _ДемоНоменклатура
	|		ПО (_ДемоНоменклатура.Наименование = ДанныеДляСопоставленияПоНаименованию.Наименование)
	|			И (_ДемоНоменклатура.ПометкаУдаления = ЛОЖЬ)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СопоставленнаяНоменклатураПоШтрихкоду.Ссылка,
	|	СопоставленнаяНоменклатураПоШтрихкоду.Идентификатор
	|ИЗ
	|	СопоставленнаяНоменклатураПоШтрихкоду КАК СопоставленнаяНоменклатураПоШтрихкоду";
	
	Запрос.УстановитьПараметр("ДанныеДляСопоставления", ЗагружаемыеДанные);

	РезультатЗапроса = Запрос.Выполнить().Выбрать();

	Пока РезультатЗапроса.Следующий() Цикл
		Фильтр = Новый Структура("Идентификатор", РезультатЗапроса.Идентификатор);
		Строки = ЗагружаемыеДанные.НайтиСтроки(Фильтр);
		Для Каждого Строка Из Строки Цикл
			Строка.ОбъектСопоставления = РезультатЗапроса.Номенклатура;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Загрузка данных из файла.
//
// Параметры:
//  ЗагружаемыеДанные -ТаблицаЗначений:
//       * СопоставленныйОбъект         - СправочникСсылка - ссылка на сопоставленный объект.
//       * РезультатСопоставленияСтроки - Строка       - статус загрузки, возможны варианты: Создан, Обновлен, Пропущен.
//       * ОписаниеОшибки               - Строка       - расшифровка ошибки загрузки данных.
//       * Идентификатор                - Число        - уникальный номер строки
//       <другие колонки>               - Произвольный - Строки за загружаемого файла в соответствие с макетом.
//  ПараметрыЗагрузки                  - Структура:
//       * СоздаватьНовые               - Булево       - требуется ли создавать новые элементы справочника.
//       * ОбновлятьСуществующие        - Булево       - требуется ли обновлять элементы справочника.
//  Отказ - Булево                     - отмена загрузки.
//
Процедура ЗагрузитьИзФайла(ЗагружаемыеДанные, ПараметрыЗагрузки, Отказ) Экспорт
	
	Для каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл
		ОбъектСопоставленияЗаполнен = ЗначениеЗаполнено(СтрокаТаблицы.ОбъектСопоставления);
		
		Если (ОбъектСопоставленияЗаполнен
			И ПараметрыЗагрузки.ОбновлятьСуществующие = 0)
			ИЛИ (НЕ ОбъектСопоставленияЗаполнен
			И ПараметрыЗагрузки.СоздаватьНовые = 0) Тогда
				СтрокаТаблицы.РезультатСопоставленияСтроки = "Пропущен";
				Продолжить;
		КонецЕсли;
		
		УправлениеДоступом.ОтключитьОбновлениеКлючейДоступа(Истина);
		НачатьТранзакцию();
		Попытка
			
			Если ОбъектСопоставленияЗаполнен Тогда
				
				Блокировка        = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("Справочник._ДемоНоменклатура");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", СтрокаТаблицы.ОбъектСопоставления);
				Блокировка.Заблокировать();
				
				ЭлементСправочника = СтрокаТаблицы.ОбъектСопоставления.ПолучитьОбъект();
				
				Если ЭлементСправочника = Неопределено Тогда
					ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Номенклатура с артикулом %1 не существует.'"), СтрокаТаблицы.Артикул);
				КонецЕсли;
				СтрокаТаблицы.РезультатСопоставленияСтроки = "Обновлен";
				
			Иначе
				
				ЭлементСправочника                         = СоздатьЭлемент();
				СтрокаТаблицы.РезультатСопоставленияСтроки = "Создан";
				
			КонецЕсли;
			
			ЭлементСправочника.Наименование = СтрокаТаблицы.Наименование;
			ЭлементСправочника.Штрихкод = СтрокаТаблицы.Штрихкод;
			Если ЗначениеЗаполнено(СтрокаТаблицы.Страна) Тогда
				ЭлементСправочника.СтранаПроисхождения = Справочники.СтраныМира.НайтиПоНаименованию(СтрокаТаблицы.Страна);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТаблицы.Родитель) Тогда
				Родитель = НайтиПоНаименованию(СтрокаТаблицы.Родитель, Истина);
				Если Родитель = Неопределено ИЛИ НЕ Родитель.ЭтоГруппа ИЛИ Родитель.Пустая() Тогда
					Родитель = СоздатьГруппу();
					Родитель.Наименование = СтрокаТаблицы.Родитель;
					Родитель.Записать();
				КонецЕсли;
				ЭлементСправочника.Родитель = Родитель.Ссылка;
			КонецЕсли;
			
			ВидНоменклатуры = Справочники._ДемоВидыНоменклатуры.НайтиПоНаименованию(СтрокаТаблицы.ВидНоменклатуры, Истина);
			Если ВидНоменклатуры = Неопределено ИЛИ ВидНоменклатуры.Пустая() Тогда
				ВидНоменклатуры = Справочники._ДемоВидыНоменклатуры.СоздатьЭлемент();
				ВидНоменклатуры.Наименование = СтрокаТаблицы.ВидНоменклатуры;
				ВидНоменклатуры.Записать();
			КонецЕсли;
			
			ЭлементСправочника.ВидНоменклатуры = ВидНоменклатуры.Ссылка;
			Если НЕ ЭлементСправочника.ПроверитьЗаполнение() Тогда
				СтрокаТаблицы.РезультатСопоставленияСтроки = "Пропущен";
				СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
				Если СообщенияПользователю.Количество()>0 Тогда
					ТекстСообщений = "";
					Для каждого СообщениеПользователю Из СообщенияПользователю Цикл
						ТекстСообщений  = ТекстСообщений + СообщениеПользователю.Текст + Символы.ПС;
					КонецЦикла;
					СтрокаТаблицы.ОписаниеОшибки = ТекстСообщений;
				КонецЕсли;
				ОтменитьТранзакцию();
			Иначе
				ЭлементСправочника.Записать();
				СтрокаТаблицы.ОбъектСопоставления = ЭлементСправочника.Ссылка;
				УправлениеДоступом.ОтключитьОбновлениеКлючейДоступа(Ложь);
				ЗафиксироватьТранзакцию();
			КонецЕсли;
		Исключение
			ОтменитьТранзакцию();
			УправлениеДоступом.ОтключитьОбновлениеКлючейДоступа(Ложь, Ложь);
			Причина = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			СтрокаТаблицы.РезультатСопоставленияСтроки = "Пропущен";
			СтрокаТаблицы.ОписаниеОшибки = НСтр("ru = 'Невозможна запись из-за некорректности данных. По причине:'" + Причина);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

// Производит сопоставление данных, загружаемых в табличную часть Аналоги,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
//
// Параметры:
//   АдресЗагружаемыхДанных    - Строка - адрес временного хранилища с таблицей значений, в которой
//                                        находятся загруженные данные из файла. Состав колонок:
//     * Идентификатор - Число - порядковый номер строки;
//     * остальные колонки соответствуют колонкам макета ЗагрузкаИзФайла.
//   АдресТаблицыСопоставления - Строка - адрес временного хранилища с пустой таблицей значений,
//                                        являющейся копией табличной части документа, 
//                                        которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
//   СписокНеоднозначностей - ТаблицаЗначений - список неоднозначных значений, для которых в ИБ имеется несколько
//                                              подходящих вариантов:
//     * Колонка       - Строка - имя колонки, в которой была обнаружена неоднозначность;
//     * Идентификатор - Число  - идентификатор строки, в которой была обнаружена неоднозначность.
//   ПолноеИмяТабличнойЧасти   - Строка - полное имя табличной части, в которую загружаются данные.
//   ДополнительныеПараметры   - Произвольный - любые дополнительные сведения.
//
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	Аналоги =  ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления); // СправочникТабличнаяЧасть._ДемоНоменклатура.Аналоги
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	// совместимость номенклатуры
	СовместимостьНоменклатуры = Новый Соответствие;
	Для каждого Значение Из Метаданные.Перечисления._ДемоСовместимостьНоменклатуры.ЗначенияПеречисления Цикл
		Имя = ВРег(Значение.Представление());
		СовместимостьНоменклатуры.Вставить(Имя, Перечисления._ДемоСовместимостьНоменклатуры[Значение.Имя]);
	КонецЦикла;
	
	Для каждого СтрокаТаблицы Из ЗагружаемыеДанные Цикл
		Аналог = Аналоги.Добавить();
		Аналог.Идентификатор = СтрокаТаблицы.Идентификатор;
		Аналог.Аналог = НайтиПоНаименованию(СтрокаТаблицы.Наименование);
		Аналог.Совместимость = СовместимостьНоменклатуры.Получить(ВРег(СтрокаТаблицы.Совместимость));
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Аналоги, АдресТаблицыСопоставления);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	
	НеРедактируемыеРеквизиты.Добавить("СкрытыйРеквизит");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Код");
	БлокируемыеРеквизиты.Добавить("ВидНоменклатуры");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// СтандартныеПодсистемы.ПоискИУдалениеДублей

// См. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииВозможностиЗаменыЭлементов.
//
Функция ВозможностьЗаменыЭлементов(Знач ПарыЗамен, Знач Параметры = Неопределено) Экспорт
	
	СпособУдаления = "";
	Если Параметры <> Неопределено Тогда
		Параметры.Свойство("СпособУдаления", СпособУдаления);
	КонецЕсли;
	
	// В качестве примера: запрещено заменять номенклатуру с кодом 000000001.
	ЗапрещеннаяСсылка = НайтиПоКоду("000000001");
	
	Результат = Новый Соответствие;
	Для Каждого КлючЗначение Из ПарыЗамен Цикл
		ТекущаяСсылка = КлючЗначение.Ключ;
		ЦелеваяСсылка = КлючЗначение.Значение;
		
		Если ТекущаяСсылка = ЦелеваяСсылка Тогда
			Продолжить;
			
		ИначеЕсли ТекущаяСсылка = ЗапрещеннаяСсылка Тогда
			Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Номенклатуру ""%1"" с кодом 000000001 заменять запрещено.'"),
				ТекущаяСсылка);
			Результат.Вставить(ТекущаяСсылка, Ошибка);
			Продолжить;
		КонецЕсли;
		
		// Разрешаем заменять одну ссылку номенклатуры на другую только если они одного вида 
		// или вид номенклатуры не заполнен.
		ТекущийВид = ТекущаяСсылка.ВидНоменклатуры;
		ЦелевойВид = ЦелеваяСсылка.ВидНоменклатуры;
		МожноЗаменять = ТекущийВид.Пустая() Или ЦелевойВид.Пустая() Или ТекущийВид = ЦелевойВид;
			
		Если МожноЗаменять Тогда
			// Проверим по флагам, возможно объект нельзя будет удалять, так как он нам важен.
			Если СпособУдаления = "Непосредственно" И ТекущаяСсылка = ЗапрещеннаяСсылка Тогда
				Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Номенклатуру ""%1"" с кодом 000000001 запрещено удалять безвозвратно.'"), 
					ТекущаяСсылка);
				Результат.Вставить(ТекущаяСсылка, Ошибка);
			КонецЕсли;
		Иначе
			Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'У элемента ""%1"" вид номенклатуры ""%2"", а у ""%3"" - ""%4""'"),
				ТекущаяСсылка, ТекущийВид, ЦелеваяСсылка, ЦелевойВид);
			Результат.Вставить(ТекущаяСсылка, Ошибка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// См. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииПараметровПоискаДублей.
//
// Параметры:
//  ПараметрыПоиска - см. ПоискИУдалениеДублей.ПараметрыПоискаДублей
//  ДополнительныеПараметры - Неопределено
//
Процедура ПараметрыПоискаДублей(ПараметрыПоиска, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОграниченияСравнения = ПараметрыПоиска.ОграниченияСравнения;
	ПравилаПоиска        = ПараметрыПоиска.ПравилаПоиска;
	КомпоновщикОтбора    = ПараметрыПоиска.КомпоновщикОтбора;
	
	// Общие ограничения для всех случаев.
	
	// Общие ограничения
	Ограничение = Новый Структура;
	Ограничение.Вставить("Представление",      НСтр("ru = 'Вид номенклатуры у сравниваемых элементов одинаков.'"));
	Ограничение.Вставить("ДополнительныеПоля", "ВидНоменклатуры");
	ОграниченияСравнения.Добавить(Ограничение);
	
	// Размер таблицы для передачи в обработчик.
	ПараметрыПоиска.КоличествоЭлементовДляСравнения = 100;
	
	// Анализ режима работы - варианта вызова.
	Если ДополнительныеПараметры = Неопределено Тогда
		// Внешний вызов из обработки, больше ничего делать не надо, но можно отредактировать параметры пользователя.
		Возврат;
	КонецЕсли;
	
	// Вызов из программного интерфейса.
	ЭлементыОтбора = КомпоновщикОтбора.Настройки.Отбор.Элементы;
	ЭлементыОтбора.Очистить();
	ПравилаПоиска.Очистить();
	
	Если ДополнительныеПараметры.Режим = "КонтрольПоНаименованию" Тогда
		// Ищем среди неудаленных таких же по равенству Наименования и ВидаНоменклатуры.
		
		// Фиксируем условия отбора
		Отбор = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.Использование  = Истина;
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение = Ложь;
		
		СтрокаПравила = ПравилаПоиска.Добавить();
		СтрокаПравила.Реквизит = "Наименование";
		СтрокаПравила.Правило  = "Равно";
		
		СтрокаПравила = ПравилаПоиска.Добавить();
		СтрокаПравила.Реквизит = "ВидНоменклатуры";
		СтрокаПравила.Правило  = "Равно";
		
	ИначеЕсли ДополнительныеПараметры.Режим = "ПоискПохожихПоНаименованию" Тогда
		// Ищем все похожие по наименованию.
		
		СтрокаПравила = ПравилаПоиска.Добавить();
		СтрокаПравила.Реквизит = "Наименование";
		СтрокаПравила.Правило  = "Подобно";
	КонецЕсли;
	
КонецПроцедуры

// См. ПоискИУдалениеДублейПереопределяемый.ПриПоискеДублей.
//
// Параметры:
//  ТаблицаКандидатов - ТаблицаЗначений
//  ДополнительныеПараметры - Неопределено
//                          - Структура:
//                              * Режим - Строка
//                              * Ссылка - ЛюбаяСсылка
//
Процедура ПриПоискеДублей(ТаблицаКандидатов, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		
		// Общие проверки
		Для Каждого Вариант Из ТаблицаКандидатов Цикл
			Если Вариант.Поля1.ВидНоменклатуры = Вариант.Поля2.ВидНоменклатуры Тогда
				Вариант.ЭтоДубли = Истина;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ДополнительныеПараметры.Режим = "КонтрольПоНаименованию" Тогда
		
		// Исключим себя самого
		Для Каждого Вариант Из ТаблицаКандидатов Цикл
			Если Вариант.Ссылка1 <> ДополнительныеПараметры.Ссылка
				Или Вариант.Ссылка2 <> ДополнительныеПараметры.Ссылка Тогда
				Вариант.ЭтоДубли = Истина;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ДополнительныеПараметры.Режим = "ПоискПохожихПоНаименованию" Тогда
		
		// Общие проверки
		Для Каждого Вариант Из ТаблицаКандидатов Цикл
			Если Вариант.Поля1.ВидНоменклатуры = Вариант.Поля2.ВидНоменклатуры Тогда
				Вариант.ЭтоДубли = Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ИСТИНА
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЭтоГруппа
	|	ИЛИ ЗначениеРазрешено(Ссылка)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли