// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Plural format key: "%#@VARIABLE@"
  internal static func numberOfDays(_ p1: Int) -> String {
    return L10n.tr("Localizable", "numberOfDays", p1, fallback: "Plural format key: \"%#@VARIABLE@\"")
  }
  internal enum Alert {
    /// Хорошо
    internal static let button = L10n.tr("Localizable", "alert.button", fallback: "Хорошо")
    /// Привет
    internal static let header = L10n.tr("Localizable", "alert.header", fallback: "Привет")
  }
  internal enum Base {
    /// init(coder:) has not been implemented
    internal static let error = L10n.tr("Localizable", "base.error", fallback: "init(coder:) has not been implemented")
  }
  internal enum CategoryScreen {
    /// Ошибка удаления категории. Пожалуйста, сначала удалите все трекеры в этой категории.
    internal static let errorDelete = L10n.tr("Localizable", "categoryScreen.errorDelete", fallback: "Ошибка удаления категории. Пожалуйста, сначала удалите все трекеры в этой категории.")
    /// Удалить
    internal static let menuDelete = L10n.tr("Localizable", "categoryScreen.menuDelete", fallback: "Удалить")
    /// Редактировать
    internal static let menuEdit = L10n.tr("Localizable", "categoryScreen.menuEdit", fallback: "Редактировать")
    /// Категория
    internal static let title = L10n.tr("Localizable", "categoryScreen.title", fallback: "Категория")
  }
  internal enum CreateCategoryScreen {
    /// Добавить категорию
    internal static let buttonAdd = L10n.tr("Localizable", "createCategoryScreen.buttonAdd", fallback: "Добавить категорию")
    /// Введите название категории
    internal static let placeholder = L10n.tr("Localizable", "createCategoryScreen.placeholder", fallback: "Введите название категории")
    /// Новая категория
    internal static let title = L10n.tr("Localizable", "createCategoryScreen.title", fallback: "Новая категория")
  }
  internal enum CreateTracker {
    /// Отменить
    internal static let buttonCancel = L10n.tr("Localizable", "createTracker.buttonCancel", fallback: "Отменить")
    /// Создать
    internal static let buttonCreate = L10n.tr("Localizable", "createTracker.buttonCreate", fallback: "Создать")
    /// Сохранить
    internal static let buttonSave = L10n.tr("Localizable", "createTracker.buttonSave", fallback: "Сохранить")
    /// Введите название трекера
    internal static let inputName = L10n.tr("Localizable", "createTracker.inputName", fallback: "Введите название трекера")
    /// Новая привычка
    internal static let title = L10n.tr("Localizable", "createTracker.title", fallback: "Новая привычка")
    internal enum Category {
      /// Категория
      internal static let buttonName = L10n.tr("Localizable", "createTracker.category.buttonName", fallback: "Категория")
    }
    internal enum Scheduler {
      /// Расписание
      internal static let buttonName = L10n.tr("Localizable", "createTracker.scheduler.buttonName", fallback: "Расписание")
      /// Новое нерегулярное событие
      internal static let title = L10n.tr("Localizable", "createTracker.scheduler.title", fallback: "Новое нерегулярное событие")
    }
  }
  internal enum EditCategoryScreen {
    /// Готово
    internal static let buttonAdd = L10n.tr("Localizable", "editCategoryScreen.buttonAdd", fallback: "Готово")
    /// Ошибка редактирования категории
    internal static let errorEdit = L10n.tr("Localizable", "editCategoryScreen.errorEdit", fallback: "Ошибка редактирования категории")
    /// Введите название категории
    internal static let placeholder = L10n.tr("Localizable", "editCategoryScreen.placeholder", fallback: "Введите название категории")
    /// Редактирование категории
    internal static let title = L10n.tr("Localizable", "editCategoryScreen.title", fallback: "Редактирование категории")
  }
  internal enum EditTracker {
    /// Редактирование привычки
    internal static let title = L10n.tr("Localizable", "editTracker.title", fallback: "Редактирование привычки")
    internal enum Scheduler {
      /// Редактирование нерегулярного события
      internal static let title = L10n.tr("Localizable", "editTracker.scheduler.title", fallback: "Редактирование нерегулярного события")
    }
  }
  internal enum Filter {
    /// Все
    internal static let all = L10n.tr("Localizable", "filter.all", fallback: "Все")
    /// Завершенные
    internal static let completed = L10n.tr("Localizable", "filter.completed", fallback: "Завершенные")
    /// Трекеры на сегодня
    internal static let today = L10n.tr("Localizable", "filter.today", fallback: "Трекеры на сегодня")
    /// Не завершенные
    internal static let uncompleted = L10n.tr("Localizable", "filter.uncompleted", fallback: "Не завершенные")
  }
  internal enum Navbar {
    /// Трекеры
    internal static let text1 = L10n.tr("Localizable", "navbar.text1", fallback: "Трекеры")
    /// Статистика
    internal static let text2 = L10n.tr("Localizable", "navbar.text2", fallback: "Статистика")
  }
  internal enum Onbording {
    internal enum Button {
      /// Вот это технологии!
      internal static let text = L10n.tr("Localizable", "onbording.button.text", fallback: "Вот это технологии!")
    }
    internal enum Screen1 {
      /// Отслеживайте только то, что хотите
      internal static let text = L10n.tr("Localizable", "onbording.screen1.text", fallback: "Отслеживайте только то, что хотите")
    }
    internal enum Screen2 {
      /// Даже если это
      /// не литры воды и йога
      internal static let text = L10n.tr("Localizable", "onbording.screen2.text", fallback: "Даже если это\nне литры воды и йога")
    }
  }
  internal enum Schedule {
    /// Готово
    internal static let buttonCreate = L10n.tr("Localizable", "schedule.buttonCreate", fallback: "Готово")
    /// Расписание
    internal static let title = L10n.tr("Localizable", "schedule.title", fallback: "Расписание")
  }
  internal enum SelectTypeTracker {
    /// Нерегулярное событие
    internal static let irregularTracker = L10n.tr("Localizable", "selectTypeTracker.irregularTracker", fallback: "Нерегулярное событие")
    /// Привычка
    internal static let regularTracker = L10n.tr("Localizable", "selectTypeTracker.regularTracker", fallback: "Привычка")
    /// Создание трекера
    internal static let title = L10n.tr("Localizable", "selectTypeTracker.title", fallback: "Создание трекера")
  }
  internal enum Sheduler {
    /// Каждый день
    internal static let allDays = L10n.tr("Localizable", "sheduler.all_days", fallback: "Каждый день")
  }
  internal enum Statistic {
    /// Пока тут ничего нет
    internal static let lebel = L10n.tr("Localizable", "statistic.lebel", fallback: "Пока тут ничего нет")
    /// Статистика
    internal static let title = L10n.tr("Localizable", "statistic.title", fallback: "Статистика")
  }
  internal enum Tracker {
    /// Отметить выполнение привычки в будущем никак нельзя)
    internal static let createDateInTheFuture = L10n.tr("Localizable", "tracker.create_date_in_the_future", fallback: "Отметить выполнение привычки в будущем никак нельзя)")
    /// Не получилось создать трекер. Давай попробуем еще раз.
    internal static let errorCreateTracker = L10n.tr("Localizable", "tracker.error_create_tracker", fallback: "Не получилось создать трекер. Давай попробуем еще раз.")
    /// Не получилось удалить трекер. Давай попробуем еще раз.
    internal static let errorEditTracker = L10n.tr("Localizable", "tracker.errorEditTracker", fallback: "Не получилось удалить трекер. Давай попробуем еще раз.")
    /// Не получилось удалить трекер. Давай попробуем еще раз.
    internal static let errorUpdateTracker = L10n.tr("Localizable", "tracker.errorUpdateTracker", fallback: "Не получилось удалить трекер. Давай попробуем еще раз.")
    /// Фильтры
    internal static let filters = L10n.tr("Localizable", "tracker.filters", fallback: "Фильтры")
    /// Что будем отслеживать?
    internal static let logoText = L10n.tr("Localizable", "tracker.logoText", fallback: "Что будем отслеживать?")
    /// Ничего не найдено
    internal static let notFound = L10n.tr("Localizable", "tracker.notFound", fallback: "Ничего не найдено")
    /// Закрепленные
    internal static let pinnedCategory = L10n.tr("Localizable", "tracker.pinnedCategory", fallback: "Закрепленные")
    /// Localizable.strings
    ///   Tracker
    /// 
    ///   Created by Vitaly on 08.09.2023.
    internal static let title = L10n.tr("Localizable", "tracker.title", fallback: "Трекеры")
    internal enum ContextMenu {
      /// Удалить
      internal static let delete = L10n.tr("Localizable", "tracker.contextMenu.delete", fallback: "Удалить")
      /// Редактировать
      internal static let edit = L10n.tr("Localizable", "tracker.contextMenu.edit", fallback: "Редактировать")
      /// Закрепить
      internal static let pin = L10n.tr("Localizable", "tracker.contextMenu.pin", fallback: "Закрепить")
      /// Открепить
      internal static let unpin = L10n.tr("Localizable", "tracker.contextMenu.unpin", fallback: "Открепить")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
