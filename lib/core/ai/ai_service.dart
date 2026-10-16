/// AI 对话服务接口（一期预留；二期实现 RemoteAiService，如 Claude API）。
library;

/// 一轮对话消息。
class ChatTurn {
  const ChatTurn({required this.role, required this.content});

  final String role; // 'user' | 'assistant'
  final String content;
}

/// AI 回复。
class ChatReply {
  const ChatReply({required this.content});

  final String content;
}

/// AI 对话抽象接口：二期实现时替换 [UnavailableAiService]。
abstract interface class AiService {
  /// 发送一段对话上下文（含正在学习的单词情境），返回 AI 回复。
  Future<ChatReply> send(List<ChatTurn> history, {String? focusWord});
}

/// 一期占位实现：AI 功能未上线。
class UnavailableAiService implements AiService {
  @override
  Future<ChatReply> send(List<ChatTurn> history, {String? focusWord}) async {
    throw const AiUnavailableException();
  }
}

class AiUnavailableException implements Exception {
  const AiUnavailableException();

  @override
  String toString() => 'AI 对话功能即将上线';
}
