//
//  WorkDetail.swift
//  To Do App TCA
//
//  Created by Albertus Timothy on 18/03/24.
//

import SwiftUI

struct WorkDetail: View {
    var workToDo: WorkToDo
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Work's Details")
                    .font(.title2)
                    .fontWeight(.semibold)
                HStack {
                    Image(systemName: "briefcase.circle.fill")
                        .resizable()
                        .foregroundStyle(.blue)
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                    VStack(alignment:.leading) {
                        Text("Project's name")
                            .foregroundStyle(.gray)
                        
                        Text(workToDo.project)
                    }
                }
                
                HStack {
                    Image(systemName: "hourglass.circle.fill")
                        .resizable()
                        .foregroundStyle(.blue)
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                    VStack(alignment:.leading) {
                        Text("Estimation Hours")
                            .foregroundStyle(.gray)
                        
                        Text("\(workToDo.hoursEstimate) Hours")
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    WorkDetail(workToDo: WorkToDo(name: "Task", description: "Susah banget", done: false, project: "To Do List App", hoursEstimate: 12, deadline: Date()))
}
