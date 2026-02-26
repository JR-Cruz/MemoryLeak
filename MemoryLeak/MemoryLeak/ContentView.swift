//
//  ContentView.swift
//  MemoryLeak
//
//  Created by Jose Garrido on 25/02/26.
//

import SwiftUI
import Combine


// MARK: - Serviço

class RastreadorDeTorcida {
    var totalCliques = 0
    
    var aoAtualizarCliques: ((Int) -> Void)?
    
    func registrarClique() {
        self.totalCliques += 1
        self.aoAtualizarCliques?(totalCliques)
    }
    
    deinit {
        print("RastreadorDeTorcida destruído")
    }
}


// MARK: - ViewModel

class DetalheTimeViewModel: ObservableObject {
    
    @Published var cliques: Int = 0
    let nomeTime: String
    let rastreador = RastreadorDeTorcida()
    
    init(nomeTime: String) {
        self.nomeTime = nomeTime
        print("ViewModel do \(nomeTime) alocado na memória (Init)")
        
        self.rastreador.aoAtualizarCliques = { novoValor in
            self.cliques = novoValor
        }
    }
    
    func torcer() {
        self.rastreador.registrarClique()
    }
    
    deinit {
        print("ViewModel do \(nomeTime) desalocado da memória (Deinit)")
    }
}


// MARK: - Views

struct DetalheTimeView: View {
    @StateObject var viewModel: DetalheTimeViewModel
    
    init(nomeTime: String) {
        _viewModel = StateObject(wrappedValue: DetalheTimeViewModel(nomeTime: nomeTime))
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text(viewModel.nomeTime)
                .font(.largeTitle)
                .bold()
            
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 150, height: 150)
                .overlay(Text("Tocar!").font(.title))
                .onTapGesture {
                    viewModel.torcer()
                }
            
            Text("Torcida: \(viewModel.cliques)")
                .font(.title2)
        }
        .navigationTitle("Detalhes")
    }
}

struct ListaTimesView: View {
    let times = ["Flamengo", "Vasco", "Fluminense", "Botafogo"]
    
    var body: some View {
        NavigationStack {
            List(times, id: \.self) { time in
                NavigationLink(time, value: time)
            }
            .navigationTitle("Campeonato Carioca")
            .navigationDestination(for: String.self) { timeSelecionado in
                DetalheTimeView(nomeTime: timeSelecionado)
            }
        }
    }
}
