import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/locator.dart';
import '/data/model/daily_work.dart';
import '/state/daily_work_store.dart';

class DailyWorkPagedListView extends StatefulWidget {
  DailyWorkPagedListView({Key? key}) : super(key: key);

  @override
  _DailyWorkPagedListViewState createState() => _DailyWorkPagedListViewState();
}

class _DailyWorkPagedListViewState extends State<DailyWorkPagedListView> {
  late DailyWorkStore _dailyWorkStore;
  final _pagingController = PagingController<int, DailyWork>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _dailyWorkStore = getIt.get<DailyWorkStore>();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      await _dailyWorkStore.getData(pageKey);
      final newPage = _dailyWorkStore.dailywork;

      final previouslyFetchedItemsCount =
          _pagingController.itemList?.length ?? 0;

      //!this should be done in the daily work controller but i don't know how rn :')
      final isLastPage = previouslyFetchedItemsCount / 10 >= 10 ? true : false;
      final newItems = newPage;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems!);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems!, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView.separated(
        pagingController: _pagingController,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        builderDelegate: PagedChildBuilderDelegate<DailyWork>(
          itemBuilder: (context, work, index) => _card(work),
          firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
            error: _pagingController.error,
            onTryAgain: _pagingController.refresh,
          ),
          noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
        ),
      ),
    );
  }
}

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator(
      {Key? key, required this.error, required this.onTryAgain})
      : super(key: key);
  final String error;
  final Function onTryAgain;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Coudn\'t load the data :(\n $error'),
        ElevatedButton(
          onPressed: () => onTryAgain(),
          child: Text('retry'),
        )
      ],
    );
  }
}

class EmptyListIndicator extends StatelessWidget {
  const EmptyListIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('yay, There is no work today'));
  }
}

Widget _card(DailyWork work) {
  return Column(
    children: [
      Text("Agent Name: ${work.agentName}"),
      Text("Agent Number: ${work.phoneNumber}"),
      Text("Agent Address: ${work.address}"),
    ],
  );
}
