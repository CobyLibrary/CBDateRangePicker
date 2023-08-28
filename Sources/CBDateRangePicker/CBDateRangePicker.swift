import SwiftUI

public struct CBDateRangePickerView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @State private var startDateComponents: DateComponents
    @State private var endDateComponents: DateComponents
    @State private var selectedDateRange = Set<DateComponents>()
    @State private var selectedDateRangeTemp = Set<DateComponents>()
    
    private var toToday: Bool
    private let calendar = Calendar.current
    private var bounds: PartialRangeUpTo<Date> {
        let end = Date()
        return ..<end
    }
    
    public init(
        startDate: Binding<Date>,
        endDate: Binding<Date>,
        toToday: Bool = false
    ) {
        self._startDate = startDate
        self._endDate = endDate
        self.toToday = toToday
        self._startDateComponents = State(wrappedValue: calendar.dateComponents([.calendar, .era, .year, .month, .day], from: startDate.wrappedValue))
        self._endDateComponents = State(wrappedValue: calendar.dateComponents([.calendar, .era, .year, .month, .day], from: endDate.wrappedValue))
        self._selectedDateRange = State(wrappedValue: datesRange(from: startDate.wrappedValue, to: endDate.wrappedValue))
        self._selectedDateRangeTemp = State(wrappedValue: datesRange(from: startDate.wrappedValue, to: endDate.wrappedValue))
    }
    
    public var body: some View {
        MultiDatePickerView()
            .labelsHidden()
            .onChange(of: selectedDateRange) { _ in
                let newDate = selectedDateRange.symmetricDifference(selectedDateRangeTemp)
                
                switch selectedDateRange.count {
                case 0:
                    selectedDateRange = selectedDateRangeTemp
                case 1:
                    if selectedDateRangeTemp.count == 2  && selectedDateRangeTemp.contains(newDate) {
                        startDate = calendar.date(from: newDate.first!)!
                        endDate = calendar.date(from: newDate.first!)!
                    } else {
                        startDate = calendar.date(from: selectedDateRange.first!)!
                        endDate = calendar.date(from: selectedDateRange.first!)!
                    }
                case 2:
                    if selectedDateRangeTemp.count == 3 && selectedDateRangeTemp.contains(newDate) {
                        startDate = calendar.date(from: newDate.first!)!
                        endDate = calendar.date(from: newDate.first!)!
                    } else {
                        if startDateComponents > newDate.first! {
                            startDate = calendar.date(from: newDate.first!)!
                        }
                        endDate = calendar.date(from: newDate.first!)!
                    }
                default:
                    if !newDate.isEmpty {
                        startDate = calendar.date(from: newDate.first!)!
                        endDate = calendar.date(from: newDate.first!)!
                    }
                }
                
                selectedDateRange = datesRange(from: startDate, to: endDate)
                selectedDateRangeTemp = selectedDateRange
            }
            .onChange(of: startDate) { _ in
                startDateComponents = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: startDate)
            }
            .onChange(of: endDate) { _ in
                endDateComponents = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: endDate)
                selectedDateRange = datesRange(from: startDate, to: endDate)
                selectedDateRangeTemp = selectedDateRange
            }
    }
    
    @ViewBuilder
    private func MultiDatePickerView() -> some View {
        if toToday {
            MultiDatePicker(
                "",
                selection: $selectedDateRange,
                in: bounds
            )
        } else {
            MultiDatePicker(
                "",
                selection: $selectedDateRange
            )
        }
    }
    
    private func datesRange(from: Date, to: Date) -> Set<DateComponents> {
        if from > to { return Set<DateComponents>() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return Set(array.map{calendar.dateComponents([.calendar, .era, .year, .month, .day], from: $0)})
    }
}

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! < calendar.date(byAdding: rhs, to: now)!
    }
    
    public static func == (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.date(byAdding: lhs, to: now)! == calendar.date(byAdding: rhs, to: now)!
    }
}
