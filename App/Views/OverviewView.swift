//
//  OverviewView.swift
//  GlucoseDirect
//

import SwiftUI

struct OverviewView: View {
    @EnvironmentObject var store: DirectStore

    var body: some View {
        List {
            GlucoseView()
                .listRowSeparator(.hidden)
            Section {
                HStack{
                    Button{
                        let date = (store.state.alarmSnoozeUntil ?? Date()).toRounded(on: 1, .minute)
                        let nextDate = Calendar.current.date(byAdding: .minute, value: -15, to: date)

                        DirectNotifications.shared.hapticFeedback()
                        store.dispatch(.setAlarmSnoozeUntil(untilDate: nextDate))
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                    }.buttonBorderShape(.capsule)
                    
                    Button{
                        if store.state.alarmSnoozeUntil != nil {
                                DirectNotifications.shared.hapticFeedback()
                                store.dispatch(.setAlarmSnoozeUntil(untilDate: nil))
                        } else {
                            let date = (store.state.alarmSnoozeUntil ?? Date()).toRounded(on: 1, .minute)
                            let nextDate = Calendar.current.date(byAdding: .minute, value: 30, to: date)

                            DirectNotifications.shared.hapticFeedback()
                            store.dispatch(.setAlarmSnoozeUntil(untilDate: nextDate))
                        }
       
                    } label: {
                        if let alarmSnoozeUntil = store.state.alarmSnoozeUntil {
                            Text("Snooze to \( alarmSnoozeUntil.toLocalTime())")
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)
                        } else {
                            Text(verbatim: "Snooze")
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)
                        }
                    }.buttonBorderShape(.capsule)
                    
                    Button{
                        let date = (store.state.alarmSnoozeUntil ?? Date()).toRounded(on: 1, .minute)
                        let nextDate = Calendar.current.date(byAdding: .minute, value: 15, to: date)

                        DirectNotifications.shared.hapticFeedback()
                        store.dispatch(.setAlarmSnoozeUntil(untilDate: nextDate))
                    } label: {
                        Image(systemName: "goforward.15")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                    }.buttonBorderShape(.capsule)
                    
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.bordered)
                .foregroundStyle(.primary)
                .padding(.horizontal, -20)
            }.listRowBackground(Color.clear)
            
           

            
            if !store.state.sensorGlucoseValues.isEmpty || !store.state.bloodGlucoseValues.isEmpty {
                if #available(iOS 16.0, *) {
                    ChartView()
                } else {
                    ChartViewCompatibility()
                }
            }

            ConnectionView()
            SensorView()
        }
    }
}
