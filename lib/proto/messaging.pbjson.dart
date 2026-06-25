// This is a generated file - do not edit.
//
// Generated from messaging.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert
    .base64Decode('Cg9SZWdpc3RlclJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use registerReplyDescriptor instead')
const RegisterReply$json = {
  '1': 'RegisterReply',
  '2': [
    {'1': 'ok', '3': 1, '4': 1, '5': 8, '10': 'ok'},
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `RegisterReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerReplyDescriptor = $convert.base64Decode(
    'Cg1SZWdpc3RlclJlcGx5Eg4KAm9rGAEgASgIUgJvaxIWCgZkZXRhaWwYAiABKAlSBmRldGFpbA'
    '==');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'from', '3': 1, '4': 1, '5': 9, '10': 'from'},
    {'1': 'to', '3': 2, '4': 1, '5': 9, '10': 'to'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRISCgRmcm9tGAEgASgJUgRmcm9tEg4KAnRvGAIgASgJUgJ0bxISCgR0ZX'
    'h0GAMgASgJUgR0ZXh0EhwKCXRpbWVzdGFtcBgEIAEoA1IJdGltZXN0YW1w');

@$core.Deprecated('Use sendReplyDescriptor instead')
const SendReply$json = {
  '1': 'SendReply',
  '2': [
    {'1': 'ok', '3': 1, '4': 1, '5': 8, '10': 'ok'},
    {'1': 'queued', '3': 2, '4': 1, '5': 8, '10': 'queued'},
    {'1': 'queued_id', '3': 3, '4': 1, '5': 9, '10': 'queuedId'},
  ],
};

/// Descriptor for `SendReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendReplyDescriptor = $convert.base64Decode(
    'CglTZW5kUmVwbHkSDgoCb2sYASABKAhSAm9rEhYKBnF1ZXVlZBgCIAEoCFIGcXVldWVkEhsKCX'
    'F1ZXVlZF9pZBgDIAEoCVIIcXVldWVkSWQ=');

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert
    .base64Decode('ChBTdWJzY3JpYmVSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWU=');

@$core.Deprecated('Use deliveryReceiptDescriptor instead')
const DeliveryReceipt$json = {
  '1': 'DeliveryReceipt',
  '2': [
    {'1': 'queued_id', '3': 1, '4': 1, '5': 9, '10': 'queuedId'},
    {'1': 'to', '3': 2, '4': 1, '5': 9, '10': 'to'},
  ],
};

/// Descriptor for `DeliveryReceipt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deliveryReceiptDescriptor = $convert.base64Decode(
    'Cg9EZWxpdmVyeVJlY2VpcHQSGwoJcXVldWVkX2lkGAEgASgJUghxdWV1ZWRJZBIOCgJ0bxgCIA'
    'EoCVICdG8=');

@$core.Deprecated('Use incomingMessageDescriptor instead')
const IncomingMessage$json = {
  '1': 'IncomingMessage',
  '2': [
    {
      '1': 'message',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mensageria.ChatMessage',
      '10': 'message'
    },
    {'1': 'from_queue', '3': 2, '4': 1, '5': 8, '10': 'fromQueue'},
  ],
};

/// Descriptor for `IncomingMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List incomingMessageDescriptor = $convert.base64Decode(
    'Cg9JbmNvbWluZ01lc3NhZ2USMQoHbWVzc2FnZRgBIAEoCzIXLm1lbnNhZ2VyaWEuQ2hhdE1lc3'
    'NhZ2VSB21lc3NhZ2USHQoKZnJvbV9xdWV1ZRgCIAEoCFIJZnJvbVF1ZXVl');

@$core.Deprecated('Use presenceEventDescriptor instead')
const PresenceEvent$json = {
  '1': 'PresenceEvent',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'online', '3': 2, '4': 1, '5': 8, '10': 'online'},
  ],
};

/// Descriptor for `PresenceEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceEventDescriptor = $convert.base64Decode(
    'Cg1QcmVzZW5jZUV2ZW50EhIKBG5hbWUYASABKAlSBG5hbWUSFgoGb25saW5lGAIgASgIUgZvbm'
    'xpbmU=');
