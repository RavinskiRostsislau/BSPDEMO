///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущаяИнициализация;
Перем ТекущееИмяФайла;
Перем ПотокЧтения;
Перем ТекущийОбъект;
Перем ТекущиеАртефакты;
Перем ПропускатьОшибки;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьФайл(Знач ИмяФайла, ИгнорироватьОшибки = Ложь) Экспорт
	
	Если ТекущаяИнициализация Тогда
		
		ВызватьИсключение НСтр("ru = 'Объект уже был инициализирован ранее.'");
		
	Иначе
		
		ТекущееИмяФайла = ИмяФайла;
		
		ПотокЧтения = Новый ЧтениеXML();
		ПотокЧтения.ОткрытьФайл(ИмяФайла);
		ПотокЧтения.ПерейтиКСодержимому();

		Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента
			Или ПотокЧтения.Имя <> "Data" Тогда
			
			ВызватьИсключение(НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента Data.'"));
		КонецЕсли;

		Если НЕ ПотокЧтения.Прочитать() Тогда
			ВызватьИсключение(НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'"));
		КонецЕсли;
		
		ПропускатьОшибки = ИгнорироватьОшибки;
		
		//
		
		ТекущаяИнициализация = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПрочитатьОбъектДанныхИнформационнойБазы() Экспорт
	
	Если ПотокЧтения.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
		
		Если ПотокЧтения.Имя <> "DumpElement" Тогда
			ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента DumpElement.'");
		КонецЕсли;
		
		ПотокЧтения.Прочитать(); // <DumpElement>
		
		ТекущиеАртефакты = Новый Массив();
		
		Если ПотокЧтения.Имя = "Artefacts" Тогда
			
			ПотокЧтения.Прочитать(); // <Artefacts>
			Пока ПотокЧтения.ТипУзла <> ТипУзлаXML.КонецЭлемента Цикл
				
				URIЭлемента = ПотокЧтения.URIПространстваИмен;
				ИмяЭлемента = ПотокЧтения.Имя;
				ТипАртефакта = ФабрикаXDTO.Тип(URIЭлемента, ИмяЭлемента);
				
				Попытка
					
					ФрагментАртефакта = ПрочитатьФрагментПотока();
					ПотокЧтенияАртефакта = ПотокЧтенияФрагмента(ФрагментАртефакта);
					
					Артефакт = ФабрикаXDTO.ПрочитатьXML(ПотокЧтенияАртефакта, ТипАртефакта);
					
				Исключение
					
					ИсходноеИсключение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
					ВызватьИсключениеЧтенияXML(ФрагментАртефакта, ИсходноеИсключение);
					
				КонецПопытки;
				
				ТекущиеАртефакты.Добавить(Артефакт);
				
			КонецЦикла;
			ПотокЧтения.Прочитать(); // </Artefacts>
			
		КонецЕсли;
		
		Попытка
			
			ФрагментОбъекта = ПрочитатьФрагментПотока();
			ПотокЧтенияОбъекта = ПотокЧтенияФрагмента(ФрагментОбъекта);
			
			ТекущийОбъект = СериализаторXDTO.ПрочитатьXML(ПотокЧтенияОбъекта);
			
		Исключение
			
			Если ПропускатьОшибки Тогда
				ПотокЧтения.Прочитать();
				Возврат ПрочитатьОбъектДанныхИнформационнойБазы();				
			КонецЕсли;
			
			ИсходноеИсключение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ВызватьИсключениеЧтенияXML(ФрагментОбъекта, ИсходноеИсключение);
			
		КонецПопытки;
		
		ПотокЧтения.Прочитать(); // </DumpElement>
		
		Возврат Истина;
		
	Иначе
		
		ТекущийОбъект = Неопределено;
		ТекущиеАртефакты = Неопределено;
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ТекущийОбъект() Экспорт
	
	Возврат ТекущийОбъект;
	
КонецФункции

Функция АртефактыТекущегоОбъекта() Экспорт
	
	Возврат ТекущиеАртефакты;
	
КонецФункции

Процедура Закрыть() Экспорт
	
	ПотокЧтения.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Копируется текущий элемент из потока чтения XML.
//
// Параметры:
//	ПотокЧтения - ЧтениеXML - поток чтения выгрузки.
//
// Возвращаемое значение:
//	Строка - текст фрагмента XML.
//
Функция ПрочитатьФрагментПотока()
	
	ЗаписьФрагмента = Новый ЗаписьXML;
	ЗаписьФрагмента.УстановитьСтроку();
	
	ИмяУзлаФрагмента = ПотокЧтения.Имя;
	
	КорневойУзел = Истина;
	Попытка
		
		Пока НЕ (ПотокЧтения.ТипУзла = ТипУзлаXML.КонецЭлемента
				И ПотокЧтения.Имя = ИмяУзлаФрагмента) Цикл
			
			ЗаписьФрагмента.ЗаписатьТекущий(ПотокЧтения);
			
			Если ПотокЧтения.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				Если КорневойУзел Тогда
					URIПространствИмен = ПотокЧтения.КонтекстПространствИмен.URIПространствИмен();
					Для Каждого URI Из URIПространствИмен Цикл
						ЗаписьФрагмента.ЗаписатьСоответствиеПространстваИмен(ПотокЧтения.КонтекстПространствИмен.НайтиПрефикс(URI), URI);
					КонецЦикла;
					КорневойУзел = Ложь;
				КонецЕсли;
				
				ПрефиксыURIПространствИменЭлемента = ПотокЧтения.КонтекстПространствИмен.СоответствияПространствИмен();
				Для Каждого КлючИЗначение Из ПрефиксыURIПространствИменЭлемента Цикл
					Префикс = КлючИЗначение.Ключ;
					URI = КлючИЗначение.Значение;
					ЗаписьФрагмента.ЗаписатьСоответствиеПространстваИмен(Префикс, URI);
				КонецЦикла;
				
			КонецЕсли;
			
			ПотокЧтения.Прочитать();
		КонецЦикла;
		
		ЗаписьФрагмента.ЗаписатьТекущий(ПотокЧтения);
		
		ПотокЧтения.Прочитать();
	Исключение
		ТекстЖР = СтрШаблон(НСтр("ru = 'Ошибка копирования фрагмента исходного файла. Частично скопированный фрагмент:
                  |%1'"),
				ЗаписьФрагмента.Закрыть());
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выгрузка/загрузка данных.Ошибка чтения XML'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , ТекстЖР);
		ВызватьИсключение;
	КонецПопытки;
	
	Фрагмент = ЗаписьФрагмента.Закрыть();
	
	Возврат Фрагмент;
	
КонецФункции

Функция ПотокЧтенияФрагмента(Знач Фрагмент)
	
	ЧтениеФрагмента = Новый ЧтениеXML();
	ЧтениеФрагмента.УстановитьСтроку(Фрагмент);
	ЧтениеФрагмента.ПерейтиКСодержимому();
	
	Возврат ЧтениеФрагмента;
	
КонецФункции

Процедура ВызватьИсключениеЧтенияXML(Знач Фрагмент, Знач ТекстОшибки)
	
	ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка при чтении данных из файла %1: при чтении фрагмента
              |
              |%2
              |
              |произошла ошибка:
              |
              |%3.'"),
		ТекущееИмяФайла,
		Фрагмент,
		ТекстОшибки);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ТекущаяИнициализация = Ложь;

#КонецОбласти

#КонецЕсли