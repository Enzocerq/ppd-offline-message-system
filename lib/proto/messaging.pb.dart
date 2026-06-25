// This is a generated file - do not edit.
//
// Generated from messaging.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class RegisterRequest extends $pb.GeneratedMessage {
  factory RegisterRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  RegisterRequest._();

  factory RegisterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'mensageria'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRequest copyWith(void Function(RegisterRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterRequest))
          as RegisterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterRequest create() => RegisterRequest._();
  @$core.override
  RegisterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(create);
  static RegisterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class RegisterReply extends $pb.GeneratedMessage {
  factory RegisterReply({
    $core.bool? ok,
    $core.String? detail,
  }) {
    final result = create();
    if (ok != null) result.ok = ok;
    if (detail != null) result.detail = detail;
    return result;
  }

  RegisterReply._();

  factory RegisterReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'mensageria'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'ok')
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterReply copyWith(void Function(RegisterReply) updates) =>
      super.copyWith((message) => updates(message as RegisterReply))
          as RegisterReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterReply create() => RegisterReply._();
  @$core.override
  RegisterReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterReply>(create);
  static RegisterReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get ok => $_getBF(0);
  @$pb.TagNumber(1)
  set ok($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOk() => $_has(0);
  @$pb.TagNumber(1)
  void clearOk() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);
}

class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.String? from,
    $core.String? to,
    $core.String? text,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (text != null) result.text = text;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  ChatMessage._();

  factory ChatMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'mensageria'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'from')
    ..aOS(2, _omitFieldNames ? '' : 'to')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aInt64(4, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage copyWith(void Function(ChatMessage) updates) =>
      super.copyWith((message) => updates(message as ChatMessage))
          as ChatMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  @$core.override
  ChatMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get from => $_getSZ(0);
  @$pb.TagNumber(1)
  set from($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get to => $_getSZ(1);
  @$pb.TagNumber(2)
  set to($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);
}

class SendReply extends $pb.GeneratedMessage {
  factory SendReply({
    $core.bool? ok,
    $core.bool? queued,
    $core.String? queuedId,
  }) {
    final result = create();
    if (ok != null) result.ok = ok;
    if (queued != null) result.queued = queued;
    if (queuedId != null) result.queuedId = queuedId;
    return result;
  }

  SendReply._();

  factory SendReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'mensageria'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'ok')
    ..aOB(2, _omitFieldNames ? '' : 'queued')
    ..aOS(3, _omitFieldNames ? '' : 'queuedId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReply copyWith(void Function(SendReply) updates) =>
      super.copyWith((message) => updates(message as SendReply)) as SendReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendReply create() => SendReply._();
  @$core.override
  SendReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendReply>(create);
  static SendReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get ok => $_getBF(0);
  @$pb.TagNumber(1)
  set ok($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOk() => $_has(0);
  @$pb.TagNumber(1)
  void clearOk() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get queued => $_getBF(1);
  @$pb.TagNumber(2)
  set queued($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQueued() => $_has(1);
  @$pb.TagNumber(2)
  void clearQueued() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get queuedId => $_getSZ(2);
  @$pb.TagNumber(3)
  set queuedId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQueuedId() => $_has(2);
  @$pb.TagNumber(3)
  void clearQueuedId() => $_clearField(3);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  SubscribeRequest._();

  factory SubscribeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscribeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'mensageria'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest))
          as SubscribeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeRequest create() => SubscribeRequest._();
  @$core.override
  SubscribeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(create);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

/// Confirmação de que uma mensagem enfileirada foi finalmente entregue ao
/// destinatário (quando ele ficou online).
class DeliveryReceipt extends $pb.GeneratedMessage {
  factory DeliveryReceipt({
    $core.String? queuedId,
    $core.String? to,
  }) {
    final result = create();
    if (queuedId != null) result.queuedId = queuedId;
    if (to != null) result.to = to;
    return result;
  }

  DeliveryReceipt._();

  factory DeliveryReceipt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeliveryReceipt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeliveryReceipt',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'mensageria'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'queuedId')
    ..aOS(2, _omitFieldNames ? '' : 'to')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliveryReceipt clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliveryReceipt copyWith(void Function(DeliveryReceipt) updates) =>
      super.copyWith((message) => updates(message as DeliveryReceipt))
          as DeliveryReceipt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeliveryReceipt create() => DeliveryReceipt._();
  @$core.override
  DeliveryReceipt createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeliveryReceipt getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeliveryReceipt>(create);
  static DeliveryReceipt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get queuedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set queuedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQueuedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQueuedId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get to => $_getSZ(1);
  @$pb.TagNumber(2)
  set to($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
}

enum Incoming_Event { message, receipt, notSet }

class Incoming extends $pb.GeneratedMessage {
  factory Incoming({
    ChatMessage? message,
    DeliveryReceipt? receipt,
    $core.bool? fromQueue,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (receipt != null) result.receipt = receipt;
    if (fromQueue != null) result.fromQueue = fromQueue;
    return result;
  }

  Incoming._();

  factory Incoming.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Incoming.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Incoming_Event> _Incoming_EventByTag = {
    1: Incoming_Event.message,
    2: Incoming_Event.receipt,
    0: Incoming_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Incoming',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'mensageria'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<ChatMessage>(1, _omitFieldNames ? '' : 'message',
        subBuilder: ChatMessage.create)
    ..aOM<DeliveryReceipt>(2, _omitFieldNames ? '' : 'receipt',
        subBuilder: DeliveryReceipt.create)
    ..aOB(3, _omitFieldNames ? '' : 'fromQueue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Incoming clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Incoming copyWith(void Function(Incoming) updates) =>
      super.copyWith((message) => updates(message as Incoming)) as Incoming;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Incoming create() => Incoming._();
  @$core.override
  Incoming createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Incoming getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Incoming>(create);
  static Incoming? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  Incoming_Event whichEvent() => _Incoming_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ChatMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ChatMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessage ensureMessage() => $_ensure(0);

  @$pb.TagNumber(2)
  DeliveryReceipt get receipt => $_getN(1);
  @$pb.TagNumber(2)
  set receipt(DeliveryReceipt value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReceipt() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceipt() => $_clearField(2);
  @$pb.TagNumber(2)
  DeliveryReceipt ensureReceipt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get fromQueue => $_getBF(2);
  @$pb.TagNumber(3)
  set fromQueue($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromQueue() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromQueue() => $_clearField(3);
}

class PresenceEvent extends $pb.GeneratedMessage {
  factory PresenceEvent({
    $core.String? name,
    $core.bool? online,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (online != null) result.online = online;
    return result;
  }

  PresenceEvent._();

  factory PresenceEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PresenceEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PresenceEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'mensageria'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'online')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PresenceEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PresenceEvent copyWith(void Function(PresenceEvent) updates) =>
      super.copyWith((message) => updates(message as PresenceEvent))
          as PresenceEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PresenceEvent create() => PresenceEvent._();
  @$core.override
  PresenceEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PresenceEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PresenceEvent>(create);
  static PresenceEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get online => $_getBF(1);
  @$pb.TagNumber(2)
  set online($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOnline() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnline() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
