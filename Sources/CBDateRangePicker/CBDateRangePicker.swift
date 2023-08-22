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
                switch selectedDateRange.count {
                case 1:
                    startDateComponents = selectedDateRange.first!
                    endDateComponents = startDateComponents
                case 2:
                    var tempDates = selectedDateRange
                    tempDates.remove(startDateComponents)
                    endDateComponents = tempDates.first!
                    if startDateComponents > endDateComponents {
                        startDateComponents = endDateComponents
                    }
                default:
                    let newData = selectedDateRangeTemp.symmetricDifference(selectedDateRange)
                    
                    if !newData.isEmpty {
                        selectedDateRange = newData
                    }
                }
            }
            .onChange(of: startDate) { _ in
                startDateComponents = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: startDate)
                selectedDateRange = datesRange(from: startDate, to: endDate)
                selectedDateRangeTemp = selectedDateRange
            }
            .onChange(of: endDate) { _ in
                endDateComponents = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: endDate)
                selectedDateRange = datesRange(from: startDate, to: endDate)
                selectedDateRangeTemp = selectedDateRange
            }
            .onChange(of: startDateComponents) { _ in
                startDate = calendar.date(from: startDateComponents)!
            }
            .onChange(of: endDateComponents) { _ in
                endDate = calendar.date(from: endDateComponents)!
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
