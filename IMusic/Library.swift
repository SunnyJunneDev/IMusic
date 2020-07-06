//
//  Library.swift
//  IMusic
//
//  Created by Светлана Шардакова on 30.06.2020.
//  Copyright © 2020 Светлана Шардакова. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                
                List{
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(TapGesture().onEnded{ _ in
                            let keyWindow = UIApplication.shared.connectedScenes.filter ({
                                $0.activationState == .foregroundActive
                            }).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
                            
                            let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                            tabBarVC?.trackDetailView.delegate = self
                            
                            self.track = track
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        })
                    }.onDelete(perform: delete)
                }
                
            }
            .navigationBarTitle("Library")
        }
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            URLImage(URL(string: cell.iconUrlString ?? "")!).frame(width: 60, height: 60).cornerRadius(2)
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}


struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let trackIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if trackIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[trackIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwardForNextTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let trackIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if trackIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[trackIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
}
