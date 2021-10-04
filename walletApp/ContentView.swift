//
//  ContentView.swift
//  walletApp
//
//  Created by George Kakarlis on 3/10/21.
//

import SwiftUI

struct ContentView: View {
    
    //sliding tab
    @State var currentTab = "Ins"
    @Namespace var animation
    
    @State var weeks: [Week] = []
    //current day of week
    @State var currentDay: Week = Week(day: "",date: "", AmountSpent: 0)
    
    var body : some View {
     VStack() {
            HStack(spacing: 15){
                //topview
                Spacer(minLength: 0)
                Button(action: {}, label:{
                    Image(systemName: "person.crop.square")//profile
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                    
                })
                Button(action: {}, label:{
                    Image(systemName: "person.text.square")//mail
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                    
                })
                Button(action: {}, label:{
                    Image(systemName: "person.grid.2x2")//dashboard
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                    
                })
                    .padding()
                
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.bottom, 20)
        
        
                
                //Money View
                HStack(spacing: 37) {
                    ZStack{
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 22)
                        //max limit for week
                        let progress = currentDay.AmountSpent / 500
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color ("purple"), style: StrokeStyle(lineWidth: 22, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: -90))
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("E")
                                    .font(.system(size: 45, weight: .bold))
                                    .foregroundColor(Color("bg"))
                            )
                    }.frame(maxWidth: 180)
                    VStack(alignment: .center, spacing: 10, content: {
                        Text("Spent")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        let amount = String(format: "%.2f", currentDay.AmountSpent)
                        
                        Text("30.-")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Maximum")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        Text("1000.-")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    })
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 30)
                
                HStack{
                    //sliding Tab
                    Text("Ins")
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 25)
                        .background(
                            ZStack {
                                if currentTab == "Ins"{
                                    Color.white
                                        .cornerRadius(10)
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                }
                            })
                        .foregroundColor(currentTab == "Ins" ? Color("bg") :
                                            Color("bg"))
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                                currentTab = "Ins"
                            }
                        }
                    Text("Outs")
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 25)
                        .background(
                            ZStack {
                                if currentTab == "Outs"{
                                    Color.white
                                        .cornerRadius(10)
                                        .matchedGeometryEffect(id: "TAB", in: animation)
                                }
                            })
                        .foregroundColor(currentTab == "Ins" ? Color("bg") :
                                            Color("bg"))
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                                currentTab = "Outs"
                            }
                        }
                }
                .padding(.vertical, 7)
                .padding(.horizontal, 10)
                .background(Color.white.opacity(0.35))
                .cornerRadius(10)
                .padding([.top, .bottom])
                
                ZStack{
                    if UIScreen.main.bounds.height < 750 {
                        ScrollView(.vertical, showsIndicators: false, content: {
                            BottomSheet (weeks : $weeks, currentDay: $currentDay)
                                .padding([.horizontal, .top])
                                .padding(.bottom)
                        })
                    } else  {
                        BottomSheet(weeks : $weeks, currentDay: $currentDay)
                            .padding([.horizontal, .top])
                            .padding(.bottom)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    Color.white
                        .clipShape(CustomeShape(corners: [.topLeft, .topRight], radius: 35))
                        .ignoresSafeArea(.all, edges: .bottom)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("bg").ignoresSafeArea())
            .onAppear(perform: {
                getWeekDays()
            })
        }
        
        func getWeekDays() {
        let calender = Calendar.current
        let week = calender.dateInterval(of: .weekOfMonth, for: Date())
            guard let startDate = week?.start else {
                return
            }
            for index in 0..<8 {
                guard let date = calender.date(byAdding: .day,value: index, to: startDate) else {
                    return
                }
                let formatter = DateFormatter()
                //this is used to get the days eg Mon, Tue
                formatter.dateFormat = "EEE"
                var day = formatter.string(from: date)
                day.removeLast()
                
                formatter.dateFormat = "dd"
                let dateString = formatter.string(from: date)
                
                //random amount
                weeks.append(Week(day: day , date: dateString, AmountSpent: index == 0 ?
                                  30 : CGFloat(index) * 60))
            }
            self.currentDay = weeks.first!
    }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
   
    }
    struct BottomSheet: View {
        @Binding var weeks: [Week]
        @Binding var currentDay: Week
        
        var body: some View{
            VStack{
                Capsule()
                    .fill(Color.gray)
                    .frame(width:100, height: 2)
                
                HStack(spacing: 15){
                    VStack(alignment:.leading, spacing: 10, content: {
                        
                        Text("Your Balance")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Text("October 4th 2021")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                    })
                    Spacer(minLength: 0)
                    
                    Button(action: {}, label: {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    })
                        .offset(x: -10)
                }
                .padding(.top)
                
                HStack{
                    Text("3.000.-")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    Spacer(minLength: 0)
                    
                    Image(systemName: "arrow.up")
                        .foregroundColor(.gray)
                    
                    Text("10%")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .padding(.top , 8)
                
                HStack(spacing: 0){
                    ForEach(weeks){week in
                        VStack(spacing: 12) {
                            Text(week.day)
                                .fontWeight(.bold)
                                .foregroundColor(currentDay.id == week.id ? Color.white.opacity(0.8) : .black)
                            Text(week.date)
                                .fontWeight(.bold)
                                .foregroundColor(currentDay.id == week.id ? Color.white.opacity(0.8) : .black)
                        }
                        .frame(maxWidth : .infinity)
                        .padding(.vertical)
                        .background(Color("purple").opacity(currentDay.id == week.id ? 1 : 0 ))
                        .clipShape(Capsule())
                        .onTapGesture(perform: {
                            withAnimation {
                                currentDay = week
                            }
                        }
                                      )}
                }
                                        .padding(.top , 20)
                                      
                                      Button(action : {}, label: {
                            Image(systemName: "arrow.forward")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .padding(.vertical , 12)
                                .padding(.horizontal, 50)
                                .background(Color("bg"))
                            clipShape(Capsule())
                                .foregroundColor(.white)
                        })
                            .padding(.top)
                                      
            }
        }
}

struct Week: Identifiable {
    
    var id = UUID().uuidString
    var day : String
    var date : String
    var AmountSpent : CGFloat
}

