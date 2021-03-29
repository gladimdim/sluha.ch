typedef bool ListIntersectionFilter<T, B>(T a, B b);

extension Intersection on List {
  List<T> intersection<T, B>(
      List<B> anotherList, ListIntersectionFilter<T, B> filter) {
    List<T> result = [];
    for (var element in this) {
      for (var anotherElement in anotherList) {
        if (filter(element, anotherElement)) {
          result.add(element);
        }
      }
    }

    return result;
  }

  List<T> rest<T, B>(List<B> anotherList, ListIntersectionFilter<T, B> filter) {
    List<T> result = [];
    for (var element in this) {
      if (anotherList
          .where((anotherElement) => filter(element, anotherElement))
          .isEmpty) {
        result.add(element);
      }
    }

    return result;
  }
}