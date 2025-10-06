import 'dart:developer';

import 'package:flutter/material.dart';

///Pagination class
class PaginationHandler {
  int limit = 6;
  ScrollController scrollController = ScrollController();
  int currentPage = 0;
  int totalPages = 1;
  bool isLoading = false;
  bool isDisable = false;
  Future<void> Function()? fetchData;
  PaginationHandler({this.limit = 8});
  int get nextPage {
    return currentPage + 1;
  }

  bool get hasMorePages {
    return currentPage < totalPages;
  }

  String get parameters {
    return "?page=$nextPage&limit=$limit";
  }

  void handlingPaginationFromJson(Map<String, dynamic> json) {
    totalPages = json["data"]["totalPages"];
    currentPage++;
    log("totalPages ${totalPages.toString()}");
    log("currentPage ${currentPage.toString()}");
    isLoading = false;
  }

  void handlingGoldBarsPaginationFromJson(Map<String, dynamic> json) {
    totalPages = json["data"]['goldBars']["totalPages"];
    currentPage++;
    log("totalPages ${totalPages.toString()}");
    log("currentPage ${currentPage.toString()}");
    isLoading = false;
  }

  void resetHandler() {
    currentPage = 0;
    totalPages = 1;
    isLoading = false;
  }

  void addListenerToController() {
    // scrollController=controller;
    scrollController.addListener(
      () async {
        log("addListenerToController");
        if (!isDisable &&
            hasMorePages &&
            scrollController.position.pixels >=
                scrollController.position.maxScrollExtent &&
            !isLoading) {
          isLoading = true;
          await fetchData!();
        }
      },
    );
  }

  disable() {
    isDisable = true;
  }

  enable() {
    isDisable = false;
  }

  dispose() {
    scrollController.dispose();
  }
}
