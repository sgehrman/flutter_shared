import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:hive/hive.dart';

class BrowserSortMenuButton extends StatelessWidget {
  const BrowserSortMenuButton();

  Widget _popupMenu(BuildContext context) {
    final List<BrowserSortMenuItem> items = <BrowserSortMenuItem>[];

    for (final sortType in SortTypes.sortTypes) {
      items.add(
        BrowserSortMenuItem(
          itemType: SortMenuItemType.sortItem,
          name: sortType.name,
          sortType: sortType,
        ),
      );
    }

    final menuItems = <PopupMenuEntry<BrowserSortMenuItem>>[];

    final foldersFirst = BrowserSortMenuItem(
      name: 'Folders First',
      itemType: SortMenuItemType.foldersFirstItem,
      sortType: null,
    );

    menuItems.add(CheckedPopupMenuItem<BrowserSortMenuItem>(
      value: foldersFirst,
      checked: BrowserPrefs.sortFoldersFirst,
      child: MenuItem(
        name: foldersFirst.name,
      ),
    ));

    final ascendingItem = BrowserSortMenuItem(
      name: 'Ascending',
      itemType: SortMenuItemType.ascendingItem,
      sortType: null,
    );
    menuItems.add(CheckedPopupMenuItem<BrowserSortMenuItem>(
      value: ascendingItem,
      checked: BrowserPrefs.sortAscending,
      child: MenuItem(
        name: ascendingItem.name,
      ),
    ));

    menuItems.add(const PopupMenuDivider(
      height: 4,
    ));

    for (final item in items) {
      menuItems.add(CheckedPopupMenuItem<BrowserSortMenuItem>(
        value: item,
        checked: item.sortType.id == BrowserPrefs.sortType,
        child: MenuItem(
          name: item.name,
        ),
      ));
    }

    return PopupMenuButton<BrowserSortMenuItem>(
      tooltip: 'Sort',
      itemBuilder: (context) {
        return menuItems;
      },
      onSelected: (selected) {
        if (selected.itemType == SortMenuItemType.foldersFirstItem) {
          BrowserPrefs.sortFoldersFirst = !BrowserPrefs.sortFoldersFirst;
        } else if (selected.itemType == SortMenuItemType.ascendingItem) {
          BrowserPrefs.sortAscending = !BrowserPrefs.sortAscending;
        } else {
          BrowserPrefs.sortType = selected.sortType.id;
        }
      },
      child: const Icon(Icons.sort),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: HiveBox.prefsBox.listenable(),
      builder: (BuildContext context, Box<dynamic> prefsBox, Widget _) {
        return _popupMenu(context);
      },
    );
  }
}

enum SortMenuItemType {
  sortItem,
  foldersFirstItem,
  ascendingItem,
}

class BrowserSortMenuItem {
  BrowserSortMenuItem({
    @required this.itemType,
    @required this.name,
    @required this.sortType,
  });
  String name;
  SortTypes sortType;
  SortMenuItemType itemType;
}
