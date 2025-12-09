import 'package:flutter/material.dart';
import 'package:super_widget/src/super_expandable_text.dart';

/// SuperExpandableText 组件示例
class SuperExpandableTextExample extends StatefulWidget {
  const SuperExpandableTextExample({Key? key}) : super(key: key);

  @override
  State<SuperExpandableTextExample> createState() => _SuperExpandableTextExampleState();
}

class _SuperExpandableTextExampleState extends State<SuperExpandableTextExample> {
  int _clickCount = 0;
  String _selectedText = '';
  TextSelection? _textSelection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SuperExpandableText 示例'), elevation: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== 基础功能 ====================
            _buildCategory('基础功能'),

            _buildExample(
              title: '1. 基础用法',
              description: '超过2行自动显示展开按钮',
              child: const SuperExpandableText(
                text: '这是一段很长的文本，用来测试可展开文本组件的功能。当文本超过指定的行数时，会自动显示展开按钮。点击展开按钮可以查看完整内容，点击收起按钮可以折叠文本。这是一个非常实用的组件，适用于各种需要展示长文本的场景。',
                maxLines: 2,
              ),
            ),

            _buildExample(
              title: '2. 自定义按钮文本',
              description: '自定义展开/收起按钮的文字',
              child: const SuperExpandableText(
                text:
                    '你可以自定义展开和收起按钮的文字。这个示例使用了"查看更多"和"收起内容"作为按钮文本，而不是默认的"展开"和"收起"。通过设置 expandText 和 collapseText 参数，你可以根据实际场景使用更合适的文案，比如"阅读全文"、"查看详情"等。',
                maxLines: 2,
                expandText: '查看更多',
                collapseText: '收起内容',
              ),
            ),

            _buildExample(
              title: '3. 自定义样式',
              description: '自定义文本和按钮的样式',
              child: SuperExpandableText(
                text: '这是带有自定义样式的文本示例。文本使用了较大的字号（16px）和深灰色，提高了阅读体验。链接按钮使用了蓝色、粗体和下划线样式，让展开/收起按钮更加醒目。你可以根据应用的设计规范，自由定制各种文本样式，包括字体、颜色、行高、装饰等。',
                maxLines: 2,
                textStyle: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                collapseStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                expandText: '展开全文',
                collapseText: '收起',
              ),
            ),

            const SizedBox(height: 32),

            // ==================== 富文本功能 ====================
            _buildCategory('富文本功能'),

            _buildExample(
              title: '4. 基础富文本',
              description: '使用 richTextSpans 显示多种样式',
              child: SuperExpandableText(
                text: '',
                maxLines: 2,
                richTextSpans: const [
                  TextSpan(
                    text: '这是一段包含多种样式的富文本内容示例。你可以在一段文本中使用',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '粗体',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  TextSpan(
                    text: '、',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '斜体',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
                  ),
                  TextSpan(
                    text: '、',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '红色文字',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: '、',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '蓝色文字',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: '等多种不同的文本样式，让内容更加丰富多彩。',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),

            _buildExample(
              title: '5. 长富文本',
              description: '测试富文本的截断和展开',
              child: SuperExpandableText(
                text: '',
                maxLines: 2,
                richTextSpans: const [
                  TextSpan(
                    text: '这是一段非常长的富文本示例。',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '粗体文字',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  TextSpan(
                    text: '、',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '下划线文字',
                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.black87),
                  ),
                  TextSpan(
                    text: '、',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: '紫色文字',
                    style: TextStyle(color: Colors.purple),
                  ),
                  TextSpan(
                    text: '。这段富文本内容足够长，可以触发截断逻辑。点击展开可以看到完整内容。',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==================== 交互功能 ====================
            _buildCategory('交互功能'),

            _buildExample(
              title: '6. 状态回调',
              description: '监听展开/收起状态变化',
              child: SuperExpandableText(
                text:
                    '这个示例展示了状态回调功能。每次点击展开或收起按钮时，会显示一个 SnackBar 提示消息。你可以在 onExpanded 回调中执行各种操作，比如统计用户行为、记录日志、触发其他业务逻辑等。回调函数会接收一个布尔参数，表示即将要变成的状态（true表示将要展开，false表示将要收起）。',
                maxLines: 2,
                onExpanded: (willExpanded) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('文本${willExpanded ? '展开' : '收起'}'), duration: const Duration(seconds: 1)));
                  return true;
                },
              ),
            ),

            _buildExample(
              title: '7. 阻止展开',
              description: '通过返回 false 阻止状态变化',
              child: SuperExpandableText(
                text:
                    '这个示例会阻止展开操作，但允许收起操作。尝试点击展开按钮，你会发现无法展开，并显示一个提示消息。这个功能可以用于多种场景，比如需要会员权限才能查看完整内容、需要先完成某些操作才能展开、或者在某些特定条件下禁止展开等。通过在 onExpanded 回调中返回 false，就可以阻止状态变化。',
                maxLines: 2,
                onExpanded: (willExpanded) {
                  if (willExpanded) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('展开操作被阻止'), duration: Duration(seconds: 1)));
                    return false;
                  }
                  return true;
                },
              ),
            ),

            _buildExample(
              title: '8. 动态内容',
              description: '内容动态变化时的表现',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SuperExpandableText(
                    key: ValueKey(_clickCount),
                    text:
                        '点击次数: $_clickCount。这是一段动态变化的文本示例。每次点击展开或收起按钮时，计数器都会增加。这个示例展示了当组件的内容动态变化时，展开文本组件依然能够正确工作。使用 key 参数可以确保内容更新时组件能够正确重建。你可以点击下方的重置按钮将计数器归零。',
                    maxLines: 2,
                    onExpanded: (willExpanded) {
                      setState(() {
                        _clickCount++;
                      });
                      return true;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _clickCount = 0;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('重置计数'),
                  ),
                ],
              ),
            ),

            _buildExample(
              title: '9. 文本选中回调',
              description: '监听文本选中变化（使用 SelectableText）',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SuperExpandableText(
                    text:
                        '这是一段可选中的文本示例。你可以长按或拖动来选中文本内容。当选中文本时，会在下方显示选中的文本内容和选中范围。通过 onSelectionChanged 参数，组件会自动使用 SelectableText 替代 RichText，支持文本选中功能。这个功能适用于需要用户能够复制或分享文本内容的场景。',
                    maxLines: 3,
                    builder: (richTex, textSpan, endOffset) {
                      return SelectableText.rich(textSpan);
                    },
                  ),
                  if (_textSelection != null && _textSelection!.start != _textSelection!.end)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '选中范围: ${_textSelection!.start} - ${_textSelection!.end}',
                            style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                          ),
                          const SizedBox(height: 8),
                          Text('选中内容: $_selectedText', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==================== 特殊场景 ====================
            _buildCategory('特殊场景'),

            _buildExample(
              title: '10. 换行符文本',
              description: '包含换行符的文本',
              child: const SuperExpandableText(text: '第一行：这是第一行的内容\n第二行：这是第二行的内容\n第三行：这是第三行的内容\n第四行：这是第四行的内容\n第五行：这是第五行的内容', maxLines: 2),
            ),

            _buildExample(
              title: '11. 数字换行',
              description: '1\\n2\\n3\\n... 形式的文本',
              child: const SuperExpandableText(text: '1\n2\n3\n4\n5\n6\n7\n8\n9\n10', maxLines: 3),
            ),

            _buildExample(
              title: '12. 富文本换行',
              description: '富文本中包含换行符',
              child: SuperExpandableText(
                text: '',
                maxLines: 2,
                richTextSpans: const [
                  TextSpan(
                    text: '第一行：',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '普通内容\n'),
                  TextSpan(
                    text: '第二行：',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  TextSpan(
                    text: '蓝色内容\n',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: '第三行：',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  TextSpan(
                    text: '红色内容',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ==================== 边界情况 ====================
            _buildCategory('边界情况'),

            _buildExample(
              title: '13. 短文本',
              description: '不需要展开的短文本',
              child: const SuperExpandableText(text: '这是短文本。', maxLines: 3),
            ),

            _buildExample(
              title: '14. 空文本',
              description: '文本为空字符串',
              child: const SuperExpandableText(text: '', maxLines: 2),
            ),

            _buildExample(
              title: '15. 样式继承',
              description: '继承父级 DefaultTextStyle',
              child: const DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: Colors.purple, fontWeight: FontWeight.w500),
                child: SuperExpandableText(text: '这段文本继承了父级的样式设置。', maxLines: 2),
              ),
            ),

            _buildExample(
              title: '16. 不同 maxLines',
              description: 'maxLines = 1',
              child: const SuperExpandableText(text: '这是一段测试文本，maxLines 设置为 1，所以只会显示一行。', maxLines: 1),
            ),

            _buildExample(
              title: '17. 默认展开',
              description: '初始状态为展开状态',
              child: const SuperExpandableText(
                text: '这个示例默认就是展开状态。通过设置 expanded: true 参数，可以让文本在初始加载时就显示完整内容，而不是截断状态。用户可以点击收起按钮将文本折叠。这个功能适用于重要信息需要默认展示的场景。',
                maxLines: 2,
                expanded: true,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// 构建分类标题
  Widget _buildCategory(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.blue.shade100]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.category, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
          ),
        ],
      ),
    );
  }

  /// 构建示例块
  Widget _buildExample({required String title, required String description, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          // 内容区
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}
