import 'dart:async';
import 'package:flutter/material.dart';

import 'super_load_page.dart';
import 'super_load_status.dart';

/// 缺省页
class SuperLoad extends StatefulWidget {
  /// 控制器
  final SuperLoadController controller;

  /// 点击事件
  final FutureOr Function(Map<String, dynamic>? params)? onTap;

  /// content页面，用于展示给客户
  final Widget child;

  /// state缺省页构造器，默认情况下会返回定义的缺省布局，在滑片中根据实际情况进行包装
  final Widget Function(Widget widget)? stateBuilder;

  /// 自定义参数，会传递到 [SuperLoadPage] 中
  final Map<String, dynamic>? params;

  /// 自定义页面。自定义页面中的key会覆盖全局配置的key
  /// key可使用[SuperLoadStatus]枚举的[name]属性
  final Map<String, SuperLoadPage>? otherPages;

  /// 默认展示的tag
  final String? defaultStateTag;

  final bool Function()? isStateShow;

  /// 全局配置的默认页面
  static Map<String, SuperLoadPage>? Function() defaultPages = () => null;



  /// 全局默认状态
  static SuperLoadStatus defaultLoadStatus = SuperLoadStatus.content;

  const SuperLoad({
    super.key,
    required this.controller,
    required this.child,
    this.onTap,
    this.stateBuilder,
    this.params,
    this.otherPages,
    this.defaultStateTag,
    this.isStateShow,
  });

  @override
  State<SuperLoad> createState() => _LoadPageState();
}

class _LoadPageState extends State<SuperLoad> {
  /// 缓存解析后的页面
  late Map<String, SuperLoadPage> _cachedPages;

  @override
  void initState() {
    super.initState();
    _cachedPages = _parsePages();
    widget.controller._bind(
      this,
      widget.defaultStateTag ?? SuperLoad.defaultLoadStatus.name,
    );
  }

  @override
  void didUpdateWidget(covariant SuperLoad oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.otherPages != oldWidget.otherPages ||
        widget.onTap != oldWidget.onTap ||
        widget.params != oldWidget.params) {
      _cachedPages = _parsePages();
    }

    if (widget.controller != oldWidget.controller ||
        widget.defaultStateTag != oldWidget.defaultStateTag) {
      widget.controller._bind(
        this,
        widget.defaultStateTag ?? SuperLoad.defaultLoadStatus.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tag = widget.controller.tag;

    final checker = widget.isStateShow;
    if (checker != null && checker()) {
      final page = _cachedPages[tag];
      // ❗兜底保护
      if (page == null) {
        return widget.child;
      }
      return widget.stateBuilder!(page);
    }else{
      if (tag == SuperLoadStatus.content.name) {
        return widget.child;
      }

      final page = _cachedPages[tag];

      // ❗兜底保护
      if (page == null) {
        return widget.child;
      }
      return widget.stateBuilder == null
          ? page
          : widget.stateBuilder!(page);
    }
  }

  /// 解析 pages（不污染全局配置）
  Map<String, SuperLoadPage> _parsePages() {
    final Map<String, SuperLoadPage> pageMap = {
      ...?SuperLoad.defaultPages(),
      ...?widget.otherPages,
    };

    for (final page in pageMap.values) {
      page.onTap = widget.onTap;
      page.params = widget.params;
    }

    return pageMap;
  }

  /// 切换页面的方法
  void refreshPage() {
    if (mounted) {
      setState(() {});
    }
  }
}

class SuperLoadController {
  _LoadPageState? _state;
  String? tag;

  void _bind(_LoadPageState state, String defaultTag) {
    _state = state;
    tag ??= defaultTag;
  }

  void showError() => _showPage(SuperLoadStatus.error.name);
  void showEmpty() => _showPage(SuperLoadStatus.empty.name);
  void showNetError() => _showPage(SuperLoadStatus.netError.name);
  void showLoading() => _showPage(SuperLoadStatus.loading.name);
  void showContent() => _showPage(SuperLoadStatus.content.name);
  void showOther() => _showPage(SuperLoadStatus.other.name);
  void showCustom(String customTag) => _showPage(customTag);

  void _showPage(String newTag) {
    if (tag == newTag) return;

    bool allow = true;

    final checker = _state?.widget.isStateShow;
    if (checker != null && checker()) {
      if ([
        SuperLoadStatus.error.name,
        SuperLoadStatus.empty.name,
        SuperLoadStatus.netError.name,
        SuperLoadStatus.loading.name,
      ].contains(newTag)) {
        allow = false;
      }
    }

    if (allow) {
      tag = newTag;
      _state?.refreshPage();
    }
  }

  void dispose() {
    _state = null;
  }
}