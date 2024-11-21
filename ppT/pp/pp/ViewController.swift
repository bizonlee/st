//
//  ViewController.swift
//  pp
//
//  Created by Zhdanov Konstantin on 20.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var currentDate: Date = Date()
    private var calendarView: UICalendarView? // Храним ссылку на календарь
    private var calendarSelection: UICalendarSelectionSingleDate? // Храним ссылку на поведение выбора даты

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    private lazy var startDreamButton: UIButton = {
        let button = UIButton()
        button.setTitle("Начать сон", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle(formatDate(currentDate), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var previousDayButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.addTarget(self, action: #selector(previousDayTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var nextDayButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.addTarget(self, action: #selector(nextDayTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: date)
    }

    func setupViews() {
        view.addSubview(previousDayButton)
        view.addSubview(dateButton)
        view.addSubview(nextDayButton)
        view.addSubview(startDreamButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            previousDayButton.trailingAnchor.constraint(equalTo: dateButton.leadingAnchor, constant: -8),
            previousDayButton.centerYAnchor.constraint(equalTo: dateButton.centerYAnchor),

            nextDayButton.leadingAnchor.constraint(equalTo: dateButton.trailingAnchor, constant: 8),
            nextDayButton.centerYAnchor.constraint(equalTo: dateButton.centerYAnchor),

            startDreamButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -97),
            startDreamButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startDreamButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            startDreamButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            startDreamButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc
    private func previousDayTapped() {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        updateDatePickerAndFetchRecords()
    }

    @objc
    private func nextDayTapped() {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        updateDatePickerAndFetchRecords()
    }
    
    @objc
    private func updateDatePickerAndFetchRecords() {
        dateButton.setTitle(formatDate(currentDate), for: .normal)
        updateCalendarSelection()
    }
    
    private func updateCalendarSelection() {
        guard let calendarSelection = calendarSelection else { return }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        calendarSelection.selectedDate = dateComponents
    }
    
    @objc
    private func dateButtonTapped() {
        // Убираем уже отображаемый календарь, если он есть
        if let calendar = calendarView {
            calendar.removeFromSuperview()
            self.calendarView = nil
            self.calendarSelection = nil
            return
        }
        
        // Создаем UICalendarView
        let calendar = UICalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.layer.cornerRadius = 10
        calendar.backgroundColor = .white

        // Настраиваем делегат
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: self)

        // Устанавливаем текущую дату как выделенную
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        selectionBehavior.selectedDate = dateComponents

        calendar.selectionBehavior = selectionBehavior

        // Добавляем календарь в представление
        view.addSubview(calendar)

        // Устанавливаем констрейнты для календаря
        NSLayoutConstraint.activate([
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendar.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 10),
            calendar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        calendarView = calendar // Сохраняем ссылку на календарь
        calendarSelection = selectionBehavior // Сохраняем ссылку на поведение выбора
    }
}

// Реализация делегата для UICalendarSelectionSingleDate
extension ViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else { return }

        // Обновляем текущую дату
        currentDate = date
        updateDatePickerAndFetchRecords()

        // Убираем календарь после выбора даты
        calendarView?.removeFromSuperview()
        calendarView = nil
        calendarSelection = nil
    }
}
