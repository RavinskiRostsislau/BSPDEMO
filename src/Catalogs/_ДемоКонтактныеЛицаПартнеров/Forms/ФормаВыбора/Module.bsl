///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОпределитьОтображениеСпискаКонтактныхЛиц(Параметры.ТолькоСВнешнимДоступом);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьОтображениеСпискаКонтактныхЛиц(ТолькоСВнешнимДоступом)
	
	ПодтекстЗапросаВыбрать = "";
	ПодтекстЗапросаИз      = "";
	ПодтекстЗапросаГде     = "";
	
	// Проверка на подсистему
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ВнешниеПользователи) Тогда
		ПодтекстЗапросаВыбрать = "ВЫРАЗИТЬ((ВЫРАЗИТЬ(НЕ ВнешниеПользователи.Ссылка ЕСТЬ NULL КАК БУЛЕВО)
		| И НЕ ВнешниеПользователи.Недействителен И НЕ ВнешниеПользователи.ПометкаУдаления) КАК БУЛЕВО) Как ВнешнийДоступ,";
		ПодтекстЗапросаИз = " ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователи
		| ПО Справочник_ДемоКонтактныеЛицаПартнеров.Ссылка = ВнешниеПользователи.ОбъектАвторизации";
		Элементы.ВнешнийДоступ.Видимость = Истина;
		
		Если ТолькоСВнешнимДоступом Тогда
			ПодтекстЗапросаГде = " ГДЕ ВЫРАЗИТЬ(НЕ ВнешниеПользователи.Ссылка ЕСТЬ NULL КАК БУЛЕВО)
			| И НЕ ВнешниеПользователи.Недействителен И НЕ ВнешниеПользователи.ПометкаУдаления = ИСТИНА";
		КонецЕсли;
	КонецЕсли;
	
	ШаблонЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ %1
	| Справочник_ДемоКонтактныеЛицаПартнеров.Ссылка,
	| Справочник_ДемоКонтактныеЛицаПартнеров.Наименование
	| ИЗ Справочник._ДемоКонтактныеЛицаПартнеров КАК Справочник_ДемоКонтактныеЛицаПартнеров %2 %3";
	
	ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗапроса,
		ПодтекстЗапросаВыбрать, ПодтекстЗапросаИз, ПодтекстЗапросаГде);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица              = "Справочник._ДемоКонтактныеЛицаПартнеров";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса                 = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры


#КонецОбласти