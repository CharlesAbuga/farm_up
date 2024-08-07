import 'package:equatable/equatable.dart';
import 'package:farm_up/screens/chat_app.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'gemini_chat_event.dart';
part 'gemini_chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final TextEditingController promptController = TextEditingController();
  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-1.5-flash',
    systemInstruction: Content.system(
        "You are a farm helper bot.Your goal is to help farmers with their queries limiting them to only livestock related queries."),
  );
  List<Message> messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final userMessage = event.message;
    messages.add(Message(text: userMessage, isUser: true));
    emit(ChatLoaded(messages: List.from(messages), isLoading: true));

    try {
      final prompt = [Content.text(userMessage)];
      final response = await model.generateContent(prompt);
      messages.add(Message(text: response.text!, isUser: false));
      emit(ChatLoaded(messages: List.from(messages), isLoading: false));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
