//import 'package:core/models/comment.dart';
//import 'package:core/models/group.dart';
//import 'package:core/models/message.dart';
//import 'package:core/models/play.dart';
//import 'package:core/models/score.dart';

/// Interface for interacting with WS

const PULSE_POINTS_EARNED = 'pulse points earned';
const GROUP_UPDATED = 'updated group';
const NEW_BADGE_AWARED = 'awarded badge';
const MESSAGE_READ = 'read message';
const MATCH_SCORE_CONFIRMED = 'match score confirmed';
const NEW_MESSAGE = 'new message';
const NEW_COMMENT = 'new comment';

abstract class WsProvider {
  void setToken(String token);
  Future connect();
  Future disconnect();
  void markReadGroupMessage(int groupId, int position, int profileId);
  Stream<WsEvent> get events; // subscribe to this stream of events
}

// Base WsEvent class
abstract class WsEvent {}
//
//class NewMessageWsEvent extends WsEvent {
//  final int groupId;
//  final Message message;
//  NewMessageWsEvent({this.groupId, this.message});
//}
//
//class NewGroupTimingWsEvent extends WsEvent {
//  final int groupId;
//  final GroupTiming timing;
//  NewGroupTimingWsEvent({this.groupId, this.timing});
//}
//
//class MessageReadWsEvent extends WsEvent {
//  final int groupId;
//  final int profileId;
//  final int position;
//  MessageReadWsEvent({this.groupId, this.profileId, this.position});
//}
//
//class PulsePointsEarnedWsEvent extends WsEvent {
//  final int points;
//  PulsePointsEarnedWsEvent({this.points});
//}
//
//class NewCommentWsEvent extends WsEvent {
//  final Comment comment;
//  final Play game;
//  NewCommentWsEvent({
//    this.comment,
//    this.game,
//  });
//}
//
///// Unused
//class UpdatedMatchScoreWsEvent extends WsEvent {
//  final Score score;
//  final Play game;
//  UpdatedMatchScoreWsEvent({
//    this.score,
//    this.game,
//  });
//}
