class PaginationFilterModel {
  int page = 1;
  int pageSize = 25;
  String search = '';

  @override
  String toString() =>
      'PaginationFilterModel(page: $page, pageSize: $pageSize. search: $search)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginationFilterModel &&
        other.page == page &&
        other.search == search &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode => page.hashCode ^ pageSize.hashCode;
}
