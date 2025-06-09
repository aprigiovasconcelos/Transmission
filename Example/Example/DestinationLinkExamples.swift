//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Transmission

struct DestinationLinkExamples: View {

    enum Transition: Hashable {
        case `default`
        case slide
        case zoom
        case matchedGeometry
    }
    @State var transition: Transition = .default
    @State var isInteractive = true
    func makeDestinationLinkTransition() -> DestinationLinkTransition {
        switch transition {
        case .default:
            return .default(
                options: .init(isInteractive: isInteractive)
            )
        case .slide:
            return .slide(
                initialOpacity: 0,
                isInteractive: isInteractive
            )
        case .zoom:
            if #available(iOS 18.0, *) {
                return .zoom(
                    options: .init(isInteractive: isInteractive)
                )
            }
            return .default
        case .matchedGeometry:
            return .matchedGeometry(
                preferredFromCornerRadius: .rounded(cornerRadius: 10, style: .circular),
                prefersZoomEffect: true,
                initialOpacity: 0,
                isInteractive: isInteractive
            )
        }
    }

    @State var isPresented = false
    @State var isZoomPresented = false
    @State var isMatchedGeometryPresented = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Transition")
                    .frame(maxWidth: .infinity, alignment: .leading)

                Picker(selection: $transition) {
                    Text(".default").tag(Transition.default)
                    Text(".slide").tag(Transition.slide)
                    Text(".zoom").tag(Transition.zoom)
                    Text(".matchedGeometry").tag(Transition.matchedGeometry)
                } label: {
                    Text("Destination Link Transition")
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }
            .tint(.blue)
            .fontWeight(.bold)
            .foregroundStyle(.blue)

            Toggle(isOn: $isInteractive) {
                Text("Interactive Pop Enabled")
            }
            .tint(.blue)
            .fontWeight(.bold)
            .foregroundStyle(.blue)

            DestinationLink(
                transition: makeDestinationLinkTransition()
            ) {
                ContentView()
            } label: {
                VStack(alignment: .leading) {
                    Text("Push Destination")
                    Text("w/ `DestinationLink`")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            }

            Button {
                // You can use custom animation curves for non-standard
                // transitions (.sheet, .popover, .etc)
                withAnimation(.spring) {
                    isPresented = true
                }
            } label: {
                VStack(alignment: .leading) {
                    Text("Push Destination")
                    Text("w/ `DestinationLinkModifier`")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            }
            .destination(
                transition: makeDestinationLinkTransition(),
                isPresented: $isPresented
            ) {
                ContentView()
            }

            // `DestinationSourceViewLink` makes the `label` view available to transition
            // alongside as the "source view"
            if transition == .zoom || transition == .matchedGeometry {
                DestinationSourceViewLink(
                    transition: makeDestinationLinkTransition()
                ) {
                    ContentView()
                } label: {
                    VStack(alignment: .leading) {
                        Text("Push Destination")
                        Text("w/ `DestinationSourceViewLink`")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
            }
        }
        .padding(.bottom)

        VStack(alignment: .leading) {
            Text("Examples")
                .font(.subheadline.weight(.medium))

            DestinationLink {
                TransitionReader { proxy in
                    Color.blue
                        .opacity(proxy.progress)
                        .overlay {
                            Text(proxy.progress.description)
                                .foregroundStyle(.white)
                        }
                        .ignoresSafeArea()
                }
            } label: {
                VStack(alignment: .leading) {
                    Text("Push Destination")
                    Text("w/ `TransitionReader`")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            }

            Button {
                withAnimation {
                    isZoomPresented = true
                }
            } label: {
                HStack {
                    // `DestinationLinkAdapter` makes the `label` view available to transition
                    // alongside as the "source view"
                    DestinationLinkAdapter(
                        transition: .zoomIfAvailable,
                        isPresented: $isZoomPresented
                    ) {
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .fill(Color.blue)
                            .aspectRatio(1, contentMode: .fit)
                    } content: {
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .fill(Color.blue)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 44, height: 44)
                    }

                    VStack(alignment: .leading) {
                        Text("Push Destination")
                        Text("w/ `.zoom` Transition")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
            }

            Button {
                withAnimation {
                    isMatchedGeometryPresented = true
                }
            } label: {
                HStack {
                    // `DestinationLinkAdapter` makes the `label` view available to transition
                    // alongside as the "source view"
                    DestinationLinkAdapter(
                        transition: .matchedGeometry,
                        isPresented: $isMatchedGeometryPresented
                    ) {
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .fill(Color.blue)
                            .aspectRatio(1, contentMode: .fit)
                    } content: {
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .fill(Color.blue)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 44, height: 44)
                    }

                    VStack(alignment: .leading) {
                        Text("Push Destination")
                        Text("w/ `.matchedGeometry` Transition")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        VStack {
            DestinationLinkExamples()
        }
    }
    .navigationViewStyle(.stack)
}
