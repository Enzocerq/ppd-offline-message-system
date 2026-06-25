# Projeto Final PPD — Sistema de Mensagens com Controle de Mensagens Offline

Trabalho final de **Programação Paralela e Distribuída** (IFCE — Engenharia de Computação,
Prof. Cidcley T. de Souza). Um sistema de troca de mensagens estilo *messenger* com **controle de
mensagens offline**, implementado em **Flutter (Windows desktop)** combinando as duas tecnologias já
usadas nos projetos anteriores da disciplina:

- **RPC (gRPC)** — transporte entre cada cliente e o **servidor de mensagens** (igual ao `dara-game`).
- **MOM (MQTT/Mosquitto)** — a **fila de mensagens offline por cliente** dentro do servidor (igual ao
  `mom-project-ppd`).

## Requisitos do enunciado e onde são atendidos

| # | Requisito | Onde |
|---|-----------|------|
| 1 | Cliente tem "nome de contato"; lista de amigos sempre visível na UI | [`widgets/contact_list.dart`](lib/widgets/contact_list.dart), [`home_screen.dart`](lib/screens/home_screen.dart) |
| 2 | Comunicação online/offline; cliente alterna o estado on/off | [`widgets/status_toggle.dart`](lib/widgets/status_toggle.dart) → `ChatController.setOnline` |
| 3 | Online: mensagens entregues instantaneamente | `MessageServer.sendMessage` (entrega direta no stream gRPC) |
| 4 | Offline: mensagens vão para um servidor de mensagens offline acessado via **RPC** | servidor gRPC ([`server/message_server.dart`](lib/server/message_server.dart)) |
| 5 | Fila por cliente gerenciada por um **MOM** | tópicos retidos `mom/inbox/<nome>/#` no broker MQTT ([`core/topics.dart`](lib/core/topics.dart)) |
| 6 | Enviar para contato offline → vai para a fila do destinatário | `MessageServer.sendMessage` (publica mensagem retida) |
| 7 | Ao entrar, o cliente solicita a criação da sua fila | RPC `Register` ([`message_server.dart`](lib/server/message_server.dart)) |
| 8 | Incluir/excluir contatos | `ChatController.addContact/removeContact` |

## Arquitetura

Os clientes falam **somente gRPC** com o servidor; só o **servidor** fala com o MOM (broker MQTT).

```
[App, papel Cliente: ana ]──gRPC──┐
                                  ├──▶ [App, papel Servidor]──MQTT──▶ [Broker Mosquitto]
[App, papel Cliente: bruno]──gRPC──┘    servidor gRPC + presença       filas offline por cliente
                                                                       (mensagens retidas)
```

**Fluxo de uma mensagem (ana → bruno):**
- **bruno online** (com o stream `ReceiveMessages` aberto) → o servidor entrega na hora pelo stream gRPC do
  bruno (req 3). `SendReply.queued = false`.
- **bruno offline** → o servidor publica a mensagem como **mensagem retida** em
  `mom/inbox/bruno/<id>` (req 6). `SendReply.queued = true`.
- **bruno fica online** → o servidor assina `mom/inbox/bruno/+`, o broker reentrega tudo que estava
  acumulado (a fila), o servidor repassa ao bruno (marcado como *recebida da fila*) e **apaga** cada
  mensagem retida (req 4/7).

O **botão on/off** (req 2) simplesmente abre/fecha o stream `ReceiveMessages`: offline ⇒ sem stream ⇒ o
servidor enfileira no MOM; online ⇒ stream aberto ⇒ esvazia a fila + entrega ao vivo.

> **Desenho do contrato:** cada operação é um **método RPC distinto** (`Register`, `SendMessage`,
> `ReceiveMessages`, `WatchReceipts`, `WatchPresence`) e **cada stream carrega um único tipo concreto**.
> Não há uma mensagem "coringa" com `oneof` nem `switch` de roteamento — quem despacha cada operação é o
> próprio gRPC pelo nome do método.

> Por que filas como *mensagens retidas*: é simples, confiável, visível (dá para inspecionar com
> `mosquitto_sub -t "mom/inbox/#" -v`), guarda várias mensagens e, com `persistence true`, sobrevive a
> um reinício do broker. O MOM é usado **exclusivamente** para a fila offline — exatamente o requisito 5.

## Pré-requisitos

- **Flutter** com suporte a Windows desktop.
- **Mosquitto** (broker MQTT):
  ```powershell
  winget install EclipseFoundation.Mosquitto
  ```
- **Apenas para regenerar o protobuf** (o código gerado já está versionado em `lib/proto/`):
  ```powershell
  winget install Google.Protobuf          # protoc
  dart pub global activate protoc_plugin   # protoc-gen-dart
  protoc --dart_out=grpc:lib/proto -Iproto proto/messaging.proto
  ```

## Passo a passo da demonstração

1. **Subir o broker** (deixe este terminal aberto durante a demo):
   ```bash
   "/c/Program Files/mosquitto/mosquitto.exe" -c broker/mosquitto.conf -v
   ```

2. **Compilar o app** (gera o executável da entrega):
   ```powershell
   flutter pub get
   flutter build windows
   ```
   O `.exe` fica em `build\windows\x64\runner\Release\ppd_offline_message_system.exe`.

3. **Servidor**: rode o `.exe`, escolha **"Servidor de Mensagens"**, confirme broker `localhost:1883` e
   porta gRPC `50051`, e clique em *Iniciar servidor*. O log mostra "Broker conectado" e
   "gRPC ouvindo em :50051".

4. **Clientes**: rode o `.exe` mais 2 vezes, escolha **"Cliente"** em cada, confirme `localhost:50051` e
   entre com nomes diferentes (ex.: `ana` e `bruno`). Cada cliente adiciona o outro como contato (`+`).

5. **Demonstrar**:
   - Ambos online: `ana` envia para `bruno` → chega na hora (req 3); a bolha do `ana` mostra "entregue".
   - Desligue o botão **on/off** do `bruno` (req 2). `ana` envia → a bolha fica "na fila (offline)"
     (req 6). Confira a fila no broker: `mosquitto_sub -t "mom/inbox/#" -v`.
   - Ligue o `bruno` de volta → as mensagens enfileiradas chegam marcadas como "recebida da fila"
     (req 4/7) e, **no mesmo instante, as bolhas do `ana` mudam de "na fila (offline)" para
     "entregue"** (recibo de entrega — veja abaixo).

> Durante o desenvolvimento, `flutter run -d windows` roda uma instância rápida. Para a demo com várias
> janelas, prefira o `.exe` compilado e abra-o quantas vezes precisar.

## Estrutura do código

```
proto/messaging.proto          Contrato gRPC (Register, SendMessage, ReceiveMessages, WatchReceipts, WatchPresence)
broker/mosquitto.conf          Configuração do broker MQTT (MOM) para a demo
lib/
  main.dart                    Entrada do app (seletor de papel)
  proto/                       Código gerado do protobuf/gRPC
  core/
    mqtt_service.dart          Cliente MQTT do servidor (publicar/assinar, mensagens retidas)
    topics.dart                Esquema de tópicos das filas (mom/inbox/<nome>/<id>)
  models/
    chat_message.dart          (De)serialização ChatMessage <-> JSON do payload MQTT
    contact.dart               Contato (nome + presença)
  server/
    message_server.dart        Servidor gRPC: presença, entrega instantânea e fila MOM (drain)
  rpc/
    chat_client.dart           Stub gRPC do cliente
  state/
    server_controller.dart     Estado do papel Servidor (sobe gRPC + MOM, log)
    chat_controller.dart       Estado do papel Cliente (contatos, conversas, on/off)
  screens/
    role_selector_screen.dart  Servidor x Cliente
    server_screen.dart         Painel do servidor com log ao vivo
    login_screen.dart          Login do cliente (nome de contato)
    home_screen.dart           Lista de contatos + conversa + chave on/off
  widgets/                     connection_bar, contact_list, chat_view, status_toggle
test/
  messaging_test.dart          Testes de unidade (serialização e tópicos)
  end_to_end_test.dart         Teste em processo: offline -> fila -> drain -> ao vivo (requer broker)
tool/
  smoke_test.dart              Teste de fumaça via gRPC contra um servidor rodando
```

## Testes

```powershell
flutter analyze                       # análise estática (limpa)
flutter test test/messaging_test.dart # unidade (não precisa de broker)

# ponta-a-ponta (com o broker rodando em :1883):
flutter test test/end_to_end_test.dart
```

## Recibo de entrega (status da mensagem)

Quando uma mensagem é enfileirada para um contato offline, o remetente vê "na fila (offline)".
Assim que o destinatário fica online e o servidor esvazia a fila dele, o servidor envia um
**recibo de entrega** (`DeliveryReceipt`) ao remetente pelo stream dedicado `WatchReceipts`,
casando pelo `queued_id` retornado no `SendReply`. A bolha do remetente então muda para "entregue".
Se o remetente não tiver o stream aberto nesse momento, o recibo fica guardado e é entregue quando ele
reabre.

## Observações

- Contatos e histórico são mantidos **em memória** (reiniciam ao fechar o cliente); as mensagens
  offline persistem no broker/servidor.
- Portas padrão: gRPC `50051`, MQTT `1883`. Canal gRPC inseguro (desenvolvimento local), como no
  `dara-game`.
- Trabalho individual.
