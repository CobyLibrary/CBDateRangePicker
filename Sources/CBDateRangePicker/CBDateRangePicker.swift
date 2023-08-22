import SwiftUI

public struct CBDateRangePickerView: View {
    @Binding var selectedStartDate: Date
    @Binding var selectedEndDate: Date
    @Binding var toToday: Bool
    
    @State private var selectedStartDateComponents: DateComponents
    @State private var selectedEndDateComponents: DateComponents
    @State private var selectedDateRange = Set<DateComponents>()
    @State private var selectedDateRangeTemp = Set<DateComponents>()
    
    private let calendar = Calendar.current
    private var bounds: PartialRangeUpTo<Date> {
        let end = Date()
        return ..<end
    }
    
    init(
        selectedStartDate: Binding<Date>,
        selectedEndDate: Binding<Date>,
        toToday: Binding<Bool>
    ) {
        self._selectedStartDate = selectedStartDate
        self._selectedEndDate = selectedEndDate
        self._toToday = toToday
        self._selectedStartDateComponents = State(wrappedValue: calendar.dateComponents([.calendar, .era, .year, .month, .day], from: selectedStartDate.wrappedValue))
        self._selectedEndDateComponents = State(wrappedValue: calendar.dateComponents([.calendar, .era, .year, .month, .day], from: selectedEndDate.wrappedValue))
        self._selectedDateRange = State(wrappedValue: datesRange(from: selectedStartDate.wrappedValue, to: selectedEndDate.wrappedValue))
        self._selectedDateRangeTemp = State(wrappedValue: datesRange(from: selectedStartDate.wrappedValue, to: selectedEndDate.wrappedValue))
    }
    
    public var body: some View {
        MultiDatePickerView()
            .labelsHidden()
            .onChange(of: selectedDateRange) { _ in
                switch selectedDateRange.count {
                case 1:
                    selectedStartDateComponents = selectedDateRange.first!
                    selectedEndDateComponents = selectedStartDateComponents
                case 2:
                    var tempDates = selectedDateRange
                    tempDates.remove(selectedStartDateComponents)
                    selectedEndDateComponents = tempDates.first!
                    if selectedStartDateComponents > selectedEndDateComponents {
                        selectedStartDateComponents = selectedEndDateComponents
                    }
                default:
                    let newData = selectedDateRangeTemp.symmetricDifference(selectedDateRange)
                    
                    if !newData.isEmpty {
                        selectedDateRange = newData
                    }
                }
            }
            .onChange(of: selectedStartDate) { _ in
                selectedStartDateComponents = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: selectedStartDate)
                selectedDateRange = datesRange(from: selectedStartDate, to: selectedEndDate)
                selectedDateRangeTemp = selectedDateRange
            }
            .onChange(of: selectedEndDate) { _ in
                selectedEndDateComponents = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: selectedEndDate)
                selectedDateRange = datesRange(from: selectedStartDate, to: selectedEndDate)
                selectedDateRangeTemp = selectedDateRange
            }
            .onChange(of: selectedStartDateComponents) { _ in
                selectedStartDate = calendar.date(from: selectedStartDateComponents)!
            }
            .onChange(of: selectedEndDateComponents) { _ in
                selectedEndDate = calendar.date(from: selectedEndDateComponents)!
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
