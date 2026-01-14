import 'dart:async';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

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

  /// 获取默认的公共页面
  static Map<String, SuperLoadPage>? get _defaultPages => defaultPages.call();

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
  /// 缓存的 pages,避免每次 build 都重新解析
  late Map<String, Widget> _cachedPages;

  @override
  void initState() {
    _cachedPages = _parsePages(); // 初始化时解析一次
    widget.controller._bind(this, widget.defaultStateTag ?? SuperLoad.defaultLoadStatus.name);
    super.initState();
  }

  @override
  void didUpdateWidget(SuperLoad oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 检查影响 pages 的参数是否变化
    if (widget.otherPages != oldWidget.otherPages || widget.onTap != oldWidget.onTap || widget.params != oldWidget.params) {
      _cachedPages = _parsePages(); // 参数变化时重新解析
    }
    // 如果 controller 变化,重新绑定
    if (widget.controller != oldWidget.controller || widget.defaultStateTag != oldWidget.defaultStateTag) {
      widget.controller._bind(this, widget.defaultStateTag ?? SuperLoad.defaultLoadStatus.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 直接使用缓存的 pages,不再重复计算
    if (widget.controller.tag == SuperLoadStatus.content.name) return widget.child;
    return widget.stateBuilder == null
        ? _cachedPages[widget.controller.tag]!
        : widget.stateBuilder!.call(_cachedPages[widget.controller.tag]!);
  }

  /// 解析获取pages
  Map<String, Widget> _parsePages() {
    var pageMap = SuperLoad._defaultPages ?? <String, SuperLoadPage>{};
    pageMap.addAll(widget.otherPages ?? {});
    pageMap.forEach((tag, loadWidget) {
      loadWidget.onTap = widget.onTap;
      loadWidget.params = widget.params;
    });
    return pageMap;
  }

  /// 切换页面的方法
  void refreshPage() {
    if (!mounted) return;
    setState(() {});
  }
}

class SuperLoadController {
  /// [LoadPage] sate.
  _LoadPageState? _state;

  String? tag;

  /// 绑定LoadPage
  void _bind(_LoadPageState state, String defaultTag) {
    tag ??= defaultTag;
    _state = state;
  }

  void showError() => _showPage(SuperLoadStatus.error.name);

  void showEmpty() => _showPage(SuperLoadStatus.empty.name);

  void showNetError() => _showPage(SuperLoadStatus.netError.name);

  void showLoading() => _showPage(SuperLoadStatus.loading.name);

  void showContent() => _showPage(SuperLoadStatus.content.name);

  void showOther() => _showPage(SuperLoadStatus.other.name);

  void showCustom(String customTag) => _showPage(customTag);

  void _showPage(String tag) {
    if(this.tag != tag){
      bool isOK = true;
      if(_state?.widget.isStateShow != null  ){
        if(_state!.widget.isStateShow.call() ?? false ){
          if([SuperLoadStatus.error.name,SuperLoadStatus.empty.name,SuperLoadStatus.netError.name,SuperLoadStatus.loading.name,].contains(tag)  ){
            isOK = false;
          }
        }
      }
      if(isOK){
        this.tag = tag;
        _state?.refreshPage();
      }
    }
  }

  void dispose() {
    _state = null;
  }
}
