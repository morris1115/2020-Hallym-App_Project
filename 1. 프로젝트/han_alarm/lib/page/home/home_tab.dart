
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hanalarm/common/bbloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanalarm/page/home/home.dart';

class HomeTab {

  static const int LIMIT = 16;

  final HomeBloc _homeBloc;

  final String _name;
  final String _collection;
  final ScrollController _scrollController;

  bool _hasMore = true;
  bool _isLoading = false;

  List<DocumentSnapshot> _documents;

  HomeTab(this._homeBloc, this._name, this._collection)
    : _scrollController = ScrollController() {

    _loadMore();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(_homeBloc.context).size.height * 0.25;

      if((maxScroll - currentScroll) < delta) {
        _loadMore();
      }
    });
  }

  Future<void> onRefresh() async {
    _documents = null;
    _homeBloc.deep();

    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (_hasMore && !_isLoading && !_collection.isEmpty) {
      _isLoading = true;

      Query query;
      if ((_documents != null) && (_documents.length > 0)) {
        query = Firestore
            .instance
            .collection(_collection)
            .orderBy("date", descending: true)
            .startAfterDocument(_documents.elementAt(_documents.length - 1))
            .limit(LIMIT);
      } else {
        query = Firestore
            .instance
            .collection(_collection)
            .orderBy("date", descending: true)
            .limit(LIMIT);
      }

      await query.getDocuments().then((querySnapshot) {
        if (querySnapshot.documents.length > 0) {
          if (querySnapshot.documents.length < LIMIT) {
            _hasMore = false;
          }

          if (_documents != null) {
            _documents.addAll(querySnapshot.documents);
          } else {
            _documents = List.of(querySnapshot.documents, growable: true);
          }
        } else {
          _hasMore = false;
        }
      }).catchError((error) {
        ;
      });

      _isLoading = false;

      _homeBloc.deep();
    }
  }

  String get name => _name;
  ScrollController get scrollController => _scrollController;

  List<DocumentSnapshot> get documents => _documents;
}