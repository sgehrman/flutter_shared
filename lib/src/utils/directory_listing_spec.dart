import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_shared/flutter_shared.dart';

class DirectoryListingSpec {
  DirectoryListingSpec({
    @required this.serverFile,
    @required this.recursive,
    @required this.sortStyle,
    @required this.showHidden,
    @required this.searchHiddenDirs,
    @required this.directoryCounts,
  });

  factory DirectoryListingSpec.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return DirectoryListingSpec(
      serverFile: ServerFile.fromMap(map['serverFile'] as Map<String, dynamic>),
      recursive: map['recursive'] as bool,
      sortStyle: map['sortStyle'] as String,
      showHidden: map['showHidden'] as bool,
      searchHiddenDirs: map['searchHiddenDirs'] as bool,
      directoryCounts: map['directoryCounts'] as bool,
    );
  }

  factory DirectoryListingSpec.fromJson(String source) =>
      DirectoryListingSpec.fromMap(json.decode(source) as Map<String, dynamic>);

  final ServerFile serverFile;
  final bool recursive;
  final String sortStyle;
  final bool showHidden;
  final bool searchHiddenDirs;
  final bool directoryCounts;

  bool shouldRebuildForNewSpec(DirectoryListingSpec otherSpec) {
    return sortStyle != otherSpec.sortStyle ||
        showHidden != otherSpec.showHidden ||
        searchHiddenDirs != otherSpec.searchHiddenDirs;
  }

  DirectoryListingSpec copyWith({
    ServerFile serverFile,
    bool recursive,
    String sortStyle,
    bool showHidden,
    bool searchHiddenDirs,
    bool directoryCounts,
  }) {
    return DirectoryListingSpec(
      serverFile: serverFile ?? this.serverFile,
      recursive: recursive ?? this.recursive,
      sortStyle: sortStyle ?? this.sortStyle,
      showHidden: showHidden ?? this.showHidden,
      searchHiddenDirs: searchHiddenDirs ?? this.searchHiddenDirs,
      directoryCounts: directoryCounts ?? this.directoryCounts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serverFile': serverFile?.toMap(),
      'recursive': recursive,
      'sortStyle': sortStyle,
      'showHidden': showHidden,
      'searchHiddenDirs': searchHiddenDirs,
      'directoryCounts': directoryCounts,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'DirectoryListingSpec(serverFile: $serverFile, recursive: $recursive, sortStyle: $sortStyle, showHidden: $showHidden, searchHiddenDirs: $searchHiddenDirs, directoryCounts: $directoryCounts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DirectoryListingSpec &&
        other.serverFile == serverFile &&
        other.recursive == recursive &&
        other.sortStyle == sortStyle &&
        other.showHidden == showHidden &&
        other.searchHiddenDirs == searchHiddenDirs &&
        other.directoryCounts == directoryCounts;
  }

  @override
  int get hashCode {
    return serverFile.hashCode ^
        recursive.hashCode ^
        sortStyle.hashCode ^
        showHidden.hashCode ^
        searchHiddenDirs.hashCode ^
        directoryCounts.hashCode;
  }
}