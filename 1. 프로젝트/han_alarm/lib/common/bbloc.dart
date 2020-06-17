import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class BBloc extends Bloc<BEvent, BState> {
  final BuildContext _context;

  BBloc(BuildContext context)
    : _context = context;

  @override
  BState get initialState => BState.shallow(code: "initial");

  @override
  Stream<BState> mapEventToState(BEvent event) async* {
    switch (event.code) {
      case "deep":
        yield BState.deep();
    }
  }

  void deep() {
    add(BEvent("deep"));
  }

  BuildContext get context => _context;
}

class BEvent extends Equatable  {
  final String code;
  final Map<String, dynamic> arguments;

  BEvent(
      String code, { Map<String, dynamic> arguments = const {}})
      : this.code = code,
        this.arguments = arguments;

  @override
  List<Object> get props => [ code, arguments ];
}

class BState extends Equatable {
  final bool deep;
  final DateTime _timeStamp;

  final String code;
  final Map<String, dynamic> arguments;

  BState._internal(
      bool deep, String code, Map<String, dynamic> arguments)
      : this.deep = deep,
        this._timeStamp = DateTime.now(),
        this.code = code,
        this.arguments = arguments;

  BState.deep({String code = "deep", Map<String, dynamic> arguments = const {}})
      : this._internal(true, code, arguments);

  BState.shallow({String code = "shallow", Map<String, dynamic> arguments = const {}})
      : this._internal(false, code, arguments);

  @override
  List<Object> get props => [ deep, code, _timeStamp, arguments ];
}