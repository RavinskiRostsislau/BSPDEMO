///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// @strict-types

#Область ПрограммныйИнтерфейс

// Возвращает конечную точку для отправки сообщений в менеджер сервиса.
//
// Возвращаемое значение:
//  ПланОбменаСсылка.ОбменСообщениями - узел соответствующий менеджеру сервиса.
//
Функция КонечнаяТочкаМенеджераСервиса() Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.КонечнаяТочкаМенеджераСервиса();
	
КонецФункции

// Параметры:
// 	ДанныеСервера - см. РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса.ДанныеСервера
// 	Таймаут - см. РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса.Таймаут
// 	
// Возвращаемое значение:
// 	См. РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса
//
Функция СоединениеСМенеджеромСервиса(ДанныеСервера, Таймаут = 60) Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса(ДанныеСервера, Таймаут);
	
КонецФункции
 
#КонецОбласти
