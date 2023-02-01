import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLClient extends ChangeNotifier {
  final HttpLink _link;
  final ValueNotifier<GraphQLClient> _notifier;
  GraphQLClient({link}) : _link = link, _notifier = ValueNotifier(this) {
    final authLink = AuthLink(getToken: () async => _token);
    final link = _link.concat(authLink);
    _client =  GraphQLClient(link: link);
  }
  GraphQLClient client() => _client;
  Future<T> query<T>({
    required String query,
    required Map<String, dynamic> variables,
    FetchPolicy fetchPolicy = FetchPolicy.cacheAndNetwork,
  }) async {
    final result = await _client.query(QueryOptions(
      document: query,
      variables: variables,
      fetchPolicy: fetchPolicy,
    ));
    return result.data as T;
  }
}

