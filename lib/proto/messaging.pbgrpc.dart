// This is a generated file - do not edit.
//
// Generated from messaging.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'messaging.pb.dart' as $0;

export 'messaging.pb.dart';

/// Serviço remoto de mensagens (RPC). Os clientes acessam o servidor de
/// mensagens offline EXCLUSIVAMENTE por estas chamadas — nunca falam com o MOM
/// diretamente.
@$pb.GrpcServiceName('mensageria.MessageService')
class MessageServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MessageServiceClient(super.channel, {super.options, super.interceptors});

  /// Req 7: ao entrar no sistema, o cliente solicita a criação da sua fila.
  $grpc.ResponseFuture<$0.RegisterReply> register(
    $0.RegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$register, request, options: options);
  }

  /// Req 3 e 6: envia uma mensagem. Se o destinatário estiver online é entregue
  /// instantaneamente; se estiver offline vai para a fila MOM dele.
  $grpc.ResponseFuture<$0.SendReply> sendMessage(
    $0.ChatMessage request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  /// Req 3: stream de entrada do cliente. Ao abrir (= ficar online), o servidor
  /// primeiro esvazia a fila offline e depois entrega as mensagens ao vivo.
  /// O mesmo stream também leva os recibos de entrega das mensagens que ESTE
  /// cliente mandou para contatos que estavam offline.
  $grpc.ResponseStream<$0.Incoming> subscribe(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribe, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// GUI: acompanha o status on/off dos demais clientes.
  $grpc.ResponseStream<$0.PresenceEvent> watchPresence(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchPresence, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$register =
      $grpc.ClientMethod<$0.RegisterRequest, $0.RegisterReply>(
          '/mensageria.MessageService/Register',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          $0.RegisterReply.fromBuffer);
  static final _$sendMessage = $grpc.ClientMethod<$0.ChatMessage, $0.SendReply>(
      '/mensageria.MessageService/SendMessage',
      ($0.ChatMessage value) => value.writeToBuffer(),
      $0.SendReply.fromBuffer);
  static final _$subscribe =
      $grpc.ClientMethod<$0.SubscribeRequest, $0.Incoming>(
          '/mensageria.MessageService/Subscribe',
          ($0.SubscribeRequest value) => value.writeToBuffer(),
          $0.Incoming.fromBuffer);
  static final _$watchPresence =
      $grpc.ClientMethod<$0.SubscribeRequest, $0.PresenceEvent>(
          '/mensageria.MessageService/WatchPresence',
          ($0.SubscribeRequest value) => value.writeToBuffer(),
          $0.PresenceEvent.fromBuffer);
}

@$pb.GrpcServiceName('mensageria.MessageService')
abstract class MessageServiceBase extends $grpc.Service {
  $core.String get $name => 'mensageria.MessageService';

  MessageServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.RegisterReply>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.RegisterReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChatMessage, $0.SendReply>(
        'SendMessage',
        sendMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChatMessage.fromBuffer(value),
        ($0.SendReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.Incoming>(
        'Subscribe',
        subscribe_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.Incoming value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.PresenceEvent>(
        'WatchPresence',
        watchPresence_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.PresenceEvent value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterReply> register_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterRequest> $request) async {
    return register($call, await $request);
  }

  $async.Future<$0.RegisterReply> register(
      $grpc.ServiceCall call, $0.RegisterRequest request);

  $async.Future<$0.SendReply> sendMessage_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ChatMessage> $request) async {
    return sendMessage($call, await $request);
  }

  $async.Future<$0.SendReply> sendMessage(
      $grpc.ServiceCall call, $0.ChatMessage request);

  $async.Stream<$0.Incoming> subscribe_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async* {
    yield* subscribe($call, await $request);
  }

  $async.Stream<$0.Incoming> subscribe(
      $grpc.ServiceCall call, $0.SubscribeRequest request);

  $async.Stream<$0.PresenceEvent> watchPresence_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async* {
    yield* watchPresence($call, await $request);
  }

  $async.Stream<$0.PresenceEvent> watchPresence(
      $grpc.ServiceCall call, $0.SubscribeRequest request);
}
