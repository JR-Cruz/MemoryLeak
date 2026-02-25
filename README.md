# Memory Leaks com Xcode Instruments

Este repositório contém um projeto educacional em SwiftUI desenvolvido para demonstrar na prática como identificar, debugar e resolver problemas de vazamento de memória (**Memory Leaks**) e ciclos de retenção (**Retain Cycles**) no desenvolvimento iOS.

O projeto foi criado como material de apoio para uma apresentação técnica sobre o uso do **Xcode Instruments** (templates *Leaks* e *Allocations*).

## 📱 O Projeto

O app **"Campeonato Carioca"** é um simulador simples de torcida. O usuário pode navegar por uma lista de times, entrar na tela de detalhes de um time específico e clicar em um botão para registrar sua torcida. 

Apesar da interface simples, a arquitetura propositalmente esconde um problema clássico de gerenciamento de memória no Swift usando closures.

### Tecnologias e Conceitos Abordados
* **SwiftUI** & **Combine** (ObservableObject, @Published, @StateObject)
* **ARC** (Automatic Reference Counting)
* **Retain Cycles** em Closures
* Captura de escopo (`self` vs `weak self`)
* **Xcode Instruments** (Leaks, Allocations)

---

## 🛠️ O Problema: Retain Cycle

No arquivo `DetalheTimeViewModel.swift`, a ViewModel assina uma closure do `RastreadorDeTorcida` para atualizar a interface. O problema ocorre porque a ViewModel mantém uma referência forte para o rastreador, e a closure captura a ViewModel (`self`) também de forma forte:

```swift
// Código com Memory Leak

init(nomeTime: String) {
    self.nomeTime = nomeTime
    
    rastreador.aoAtualizarCliques = { novoValor in
        self.cliques = novoValor // 'self' é capturado fortemente aqui!
    }
}
```

```swift
// Código Corrigido

init(nomeTime: String) {
    self.nomeTime = nomeTime
    
    rastreador.aoAtualizarCliques = { [weak self] novoValor in
        self?.cliques = novoValor // Agora a referência é fraca!
    }
}
```
