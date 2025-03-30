import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rudo/bloc/auth/auth_bloc.dart';
import 'package:rudo/bloc/auth/auth_event.dart';
import 'package:rudo/bloc/theme/theme_bloc.dart';
import 'package:rudo/ui/screen/login_screen.dart';

class DynamicUIFactory {
  static Widget buildWidget(Map<String, dynamic> json, BuildContext context) {
    if (json.isEmpty) {
      return const SizedBox.shrink();
    }

    final String type = json['type'] ?? json['layout'] ?? '';

    switch (type) {
      case 'column':
        return _buildColumn(json, context);
      case 'row':
        return _buildRow(json, context);
      case 'container':
        return _buildContainer(json, context);
      case 'text':
        return _buildText(json, context);
      case 'card':
        return _buildCard(json, context);
      case 'button':
        return _buildButton(json, context);
      case 'image':
        return _buildImage(json, context);
      case 'list_tile':
        return _buildListTile(json, context);
      case 'divider':
        return _buildDivider(json);
      case 'switch_tile':
        return _buildSwitchTile(json, context);
      case 'circle_avatar':
        return _buildCircleAvatar(json);
      case 'dropdown':
        return _buildDropdown(json, context);
      case 'scaffold':
        return _buildScaffold(json, context);
      case 'safe_area':
        return _buildSafeArea(json, context);
      case 'single_child_scroll_view':
        return _buildSingleChildScrollView(json, context);
      case 'sized_box':
        return _buildSizedBox(json);
      case 'feature_card':
        return _buildFeatureCard(json, context);
      case 'activity_item':
        return _buildActivityItem(json, context);
      case 'text_field':
        return _buildTextField(json, context);
      case 'padding':
        return _buildPadding(json, context);
      default:
        return Text('Unknown widget type: $type');
    }
  }

  static Widget _buildScaffold(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    final appBar =
        json['appBar'] != null
            ? AppBar(
              title: Text(json['appBar']['title'] ?? ''),
              elevation: json['appBar']['elevation']?.toDouble() ?? 0,
              backgroundColor:
                  json['appBar']['backgroundColor'] != null
                      ? parseColor(json['appBar']['backgroundColor'])
                      : Colors.transparent,
              foregroundColor:
                  json['appBar']['foregroundColor'] != null
                      ? parseColor(json['appBar']['foregroundColor'])
                      : Theme.of(context).textTheme.bodyLarge?.color,
            )
            : null;

    final body =
        json['body'] != null
            ? buildWidget(json['body'], context)
            : const SizedBox.shrink();

    return Scaffold(
      backgroundColor: parseColor(json['backgroundColor']) ?? Colors.white,
      appBar: appBar,
      body: body,
    );
  }

  static Widget _buildSafeArea(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    return SafeArea(
      child:
          json['child'] != null
              ? buildWidget(json['child'], context)
              : const SizedBox.shrink(),
    );
  }

  static Widget _buildSingleChildScrollView(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: parseEdgeInsets(json['padding']),
      child:
          json['child'] != null
              ? buildWidget(json['child'], context)
              : const SizedBox.shrink(),
    );
  }

  static Widget _buildColumn(Map<String, dynamic> json, BuildContext context) {
    final List<dynamic> children = json['children'] ?? [];
    final CrossAxisAlignment crossAxisAlignment = _parseCrossAxisAlignment(
      json['crossAxisAlignment'],
    );
    final MainAxisAlignment mainAxisAlignment = _parseMainAxisAlignment(
      json['mainAxisAlignment'],
    );
    final MainAxisSize mainAxisSize =
        json['mainAxisSize'] == 'min' ? MainAxisSize.min : MainAxisSize.max;
    final EdgeInsets padding = parseEdgeInsets(json['padding']);

    Widget column = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children:
          children.map<Widget>((child) => buildWidget(child, context)).toList(),
    );

    if (padding != EdgeInsets.zero) {
      column = Padding(padding: padding, child: column);
    }

    return column;
  }

  static Widget _buildRow(Map<String, dynamic> json, BuildContext context) {
    final List<dynamic> children = json['children'] ?? [];
    final CrossAxisAlignment crossAxisAlignment = _parseCrossAxisAlignment(
      json['crossAxisAlignment'],
    );
    final MainAxisAlignment mainAxisAlignment = _parseMainAxisAlignment(
      json['mainAxisAlignment'],
    );
    final MainAxisSize mainAxisSize =
        json['mainAxisSize'] == 'min' ? MainAxisSize.min : MainAxisSize.max;
    final EdgeInsets padding = parseEdgeInsets(json['padding']);

    Widget row = Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children:
          children.map<Widget>((child) => buildWidget(child, context)).toList(),
    );

    if (padding != EdgeInsets.zero) {
      row = Padding(padding: padding, child: row);
    }

    return row;
  }

  static Widget _buildContainer(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    final Color? color = parseColor(json['color']);
    final EdgeInsets margin = parseEdgeInsets(json['margin']);
    final EdgeInsets padding = parseEdgeInsets(json['padding']);
    final double? width = json['width']?.toDouble();
    final double? height = json['height']?.toDouble();
    final BorderRadius borderRadius =
        json['borderRadius'] != null
            ? BorderRadius.circular(json['borderRadius'].toDouble())
            : BorderRadius.zero;
    final Alignment alignment = _parseAlignment(json['alignment']);

    final Border? border =
        json['border'] != null
            ? Border.all(
              color: parseColor(json['border']['color']) ?? Colors.transparent,
              width: json['border']['width']?.toDouble() ?? 1.0,
            )
            : null;

    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: border,
      ),
      child: json['child'] != null ? buildWidget(json['child'], context) : null,
    );
  }

  static Widget _buildText(Map<String, dynamic> json, BuildContext context) {
    final String text = json['text'] ?? '';
    final TextStyle style = _parseTextStyle(json['style'], context);
    final EdgeInsets margin = parseEdgeInsets(json['margin']);
    final TextAlign textAlign = _parseTextAlign(json['textAlign']);

    Widget textWidget = Text(text, style: style, textAlign: textAlign);

    if (margin != EdgeInsets.zero) {
      textWidget = Container(margin: margin, child: textWidget);
    }

    return textWidget;
  }

  static Widget _buildCard(Map<String, dynamic> json, BuildContext context) {
    final double elevation = json['elevation']?.toDouble() ?? 1.0;
    final EdgeInsets margin = parseEdgeInsets(json['margin']);
    final EdgeInsets padding = parseEdgeInsets(json['padding']);
    final BorderRadius borderRadius = _parseBorderRadius(json['borderRadius']);

    Widget child =
        json['child'] != null
            ? buildWidget(json['child'], context)
            : const SizedBox.shrink();

    if (padding != EdgeInsets.zero) {
      child = Padding(padding: padding, child: child);
    }

    return Card(
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: child,
    );
  }

  static Widget _buildButton(Map<String, dynamic> json, BuildContext context) {
    final String text = json['text'] ?? '';
    final String style = json['style'] ?? 'elevated';
    final EdgeInsets margin = parseEdgeInsets(json['margin']);
    final String action = json['action'] ?? '';
    final Color? textColor =
        json['textColor'] != null ? parseColor(json['textColor']) : null;

    Widget button;

    switch (style) {
      case 'outlined':
        button = OutlinedButton(
          onPressed: () => _handleAction(action, context),
          child: Text(text),
        );
        break;
      case 'text':
        button = TextButton(
          onPressed: () => _handleAction(action, context),
          child: Text(text, style: TextStyle(color: textColor)),
        );
        break;
      case 'elevated':
      default:
        button = ElevatedButton(
          onPressed: () => _handleAction(action, context),
          child: Text(text),
        );
    }

    if (margin != EdgeInsets.zero) {
      button = Container(margin: margin, child: button);
    }

    return button;
  }

  static Widget _buildImage(Map<String, dynamic> json, BuildContext context) {
    final String src = json['src'] ?? '';
    final double? width = json['width']?.toDouble();
    final double? height = json['height']?.toDouble();
    final BoxFit fit = _parseBoxFit(json['fit']);
    final EdgeInsets margin = parseEdgeInsets(json['margin']);

    Widget image = Image.asset(src, width: width, height: height, fit: fit);

    if (margin != EdgeInsets.zero) {
      image = Container(margin: margin, child: image);
    }

    return image;
  }

  static Widget _buildListTile(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    return ListTile(
      leading:
          json['leading'] != null ? Icon(parseIconData(json['leading'])) : null,
      title: Text(json['title'] ?? ''),
      subtitle: json['subtitle'] != null ? Text(json['subtitle']) : null,
      trailing:
          json['trailing'] != null
              ? Icon(parseIconData(json['trailing']))
              : null,
      onTap: () => _handleAction(json['action'], context),
    );
  }

  static Widget _buildDivider(Map<String, dynamic> json) {
    final height = json['height']?.toDouble() ?? 1.0;
    final color = parseColor(json['color']);

    return Divider(height: height, color: color);
  }

  static Widget _buildSwitchTile(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    bool value = json['value'] ?? false;

    return StatefulBuilder(
      builder: (context, setState) {
        return SwitchListTile(
          title: Text(json['title'] ?? ''),
          subtitle: json['subtitle'] != null ? Text(json['subtitle']) : null,
          value: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
            _handleAction(json['action'], context, data: {'value': newValue});
          },
        );
      },
    );
  }

  static Widget _buildCircleAvatar(Map<String, dynamic> json) {
    final radius = json['radius']?.toDouble() ?? 40.0;
    final margin = parseEdgeInsets(json['margin']);
    final backgroundImage = json['backgroundImage'];
    final backgroundColor = parseColor(json['backgroundColor']) ?? Colors.blue;
    final text = json['text'] ?? '';

    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundImage:
          backgroundImage != null ? AssetImage(backgroundImage) : null,
      backgroundColor: backgroundColor,
      child: backgroundImage == null ? Text(text) : null,
    );

    if (margin != EdgeInsets.zero) {
      avatar = Container(margin: margin, child: avatar);
    }

    return avatar;
  }

  static Widget _buildDropdown(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    String value = json['value'] ?? '';
    final List<dynamic> items = json['items'] ?? [];

    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButton<String>(
          value: value,
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                value = newValue;
              });
              _handleAction(json['action'], context, data: {'value': newValue});
            }
          },
          items:
              items.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: Text(item['label']),
                );
              }).toList(),
        );
      },
    );
  }

  static Widget _buildSizedBox(Map<String, dynamic> json) {
    final width = json['width']?.toDouble();
    final height = json['height']?.toDouble();

    return SizedBox(width: width, height: height);
  }

  static Widget _buildFeatureCard(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    final title = json['title'] ?? '';
    final subtitle = json['subtitle'] ?? '';
    final action = json['action'] ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _handleAction(action, context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildActivityItem(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    final title = json['title'] ?? '';
    final date = json['date'] ?? '';
    final action = json['action'] ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _handleAction(action, context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTextField(
    Map<String, dynamic> json,
    BuildContext context,
  ) {
    final String hint = json['hint'] ?? '';
    final IconData? prefixIcon =
        json['prefixIcon'] != null ? parseIconData(json['prefixIcon']) : null;
    final double borderRadius = json['borderRadius']?.toDouble() ?? 4.0;
    final EdgeInsets contentPadding = parseEdgeInsets(json['contentPadding']);
    final searchProvider =
        context.dependOnInheritedWidgetOfExactType<SearchControllerProvider>();
    final controller = searchProvider?.controller;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        contentPadding: contentPadding,
      ),
    );
  }

  static Widget _buildPadding(Map<String, dynamic> json, BuildContext context) {
    final EdgeInsets padding = parseEdgeInsets(json['padding']);
    return Padding(
      padding: padding,
      child:
          json['child'] != null
              ? buildWidget(json['child'], context)
              : const SizedBox.shrink(),
    );
  }


  static TextStyle _parseTextStyle(
    Map<String, dynamic>? json,
    BuildContext context,
  ) {
    if (json == null) return Theme.of(context).textTheme.bodyMedium!;

    return TextStyle(
      fontSize: json['fontSize']?.toDouble(),
      fontWeight: _parseFontWeight(json['fontWeight']),
      color: parseColor(json['color']),
      letterSpacing: json['letterSpacing']?.toDouble(),
    );
  }

  static FontWeight _parseFontWeight(String? value) {
    switch (value) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  static Color? parseColor(String? colorString) {
    if (colorString == null) return null;
    if (colorString.startsWith('#')) {
      String hexColor = colorString.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse('0x$hexColor'));
    }
    return null;
  }

  static EdgeInsets parseEdgeInsets(dynamic value) {
    if (value == null) return EdgeInsets.zero;

    if (value is List) {
      if (value.length == 1) {
        final double all = value[0]?.toDouble() ?? 0.0;
        return EdgeInsets.all(all);
      } else if (value.length == 2) {
        final double vertical = value[0]?.toDouble() ?? 0.0;
        final double horizontal = value[1]?.toDouble() ?? 0.0;
        return EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
      } else if (value.length == 4) {
        final double left = value[0]?.toDouble() ?? 0.0;
        final double top = value[1]?.toDouble() ?? 0.0;
        final double right = value[2]?.toDouble() ?? 0.0;
        final double bottom = value[3]?.toDouble() ?? 0.0;
        return EdgeInsets.fromLTRB(left, top, right, bottom);
      }
    } else if (value is num) {
      return EdgeInsets.all(value.toDouble());
    }

    return EdgeInsets.zero;
  }

  static BorderRadius _parseBorderRadius(dynamic value) {
    if (value == null) return BorderRadius.zero;

    if (value is num) {
      return BorderRadius.circular(value.toDouble());
    } else if (value is List && value.length == 4) {
      return BorderRadius.only(
        topLeft: Radius.circular(value[0]?.toDouble() ?? 0.0),
        topRight: Radius.circular(value[1]?.toDouble() ?? 0.0),
        bottomRight: Radius.circular(value[2]?.toDouble() ?? 0.0),
        bottomLeft: Radius.circular(value[3]?.toDouble() ?? 0.0),
      );
    }

    return BorderRadius.zero;
  }

  static CrossAxisAlignment _parseCrossAxisAlignment(String? value) {
    switch (value) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.start;
    }
  }

  static MainAxisAlignment _parseMainAxisAlignment(String? value) {
    switch (value) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static TextAlign _parseTextAlign(String? value) {
    switch (value) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return TextAlign.start;
    }
  }

  static BoxFit _parseBoxFit(String? value) {
    switch (value) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.contain;
    }
  }

  static IconData parseIconData(String? iconName) {
    if (iconName == null) return Icons.circle;

    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'person':
        return Icons.person;
      case 'settings':
        return Icons.settings;
      case 'search':
        return Icons.search;
      case 'arrow_forward':
        return Icons.arrow_forward;
      case 'arrow_back':
        return Icons.arrow_back;
      case 'arrow_forward_ios':
        return Icons.arrow_forward_ios;
      case 'arrow_back_ios':
        return Icons.arrow_back_ios;
      case 'check':
        return Icons.check;
      case 'close':
        return Icons.close;
      case 'add':
        return Icons.add;
      case 'remove':
        return Icons.remove;
      case 'edit':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'favorite':
        return Icons.favorite;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'star':
        return Icons.star;
      case 'star_border':
        return Icons.star_border;
      case 'visibility':
        return Icons.visibility;
      case 'visibility_off':
        return Icons.visibility_off;
      case 'info':
        return Icons.info;
      case 'info_outline':
        return Icons.info_outline;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'help':
        return Icons.help;
      case 'help_outline':
        return Icons.help_outline;
      case 'contact_support':
        return Icons.contact_support;
      case 'contact_support_outlined':
        return Icons.contact_support_outlined;
      case 'history':
        return Icons.history;
      case 'trending_up':
        return Icons.trending_up;
      case 'north_west':
        return Icons.north_west;
      case 'security':
        return Icons.security;
      case 'security_outlined':
        return Icons.security_outlined;
      case 'notifications':
        return Icons.notifications;
      case 'notifications_outlined':
        return Icons.notifications_outlined;
      case 'payment':
        return Icons.payment;
      case 'payment_outlined':
        return Icons.payment_outlined;
      case 'history_outlined':
        return Icons.history_outlined;
      case 'person_outline':
        return Icons.person_outline;
      case 'chevron_right':
        return Icons.chevron_right;
      default:
        return Icons.circle;
    }
  }

  static void _handleAction(
    String? action,
    BuildContext context, {
    Map<String, dynamic>? data,
  }) {
    if (action == null) return;

    switch (action) {
      case 'logout':
        context.read<AuthBloc>().add(LoggedOut());
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
        break;
      case 'toggle_theme':
        context.read<ThemeBloc>().add(ThemeToggled());
        break;
      case 'set_search_text':
        final searchProvider =
            context
                .dependOnInheritedWidgetOfExactType<SearchControllerProvider>();
        if (searchProvider != null && data != null && data['text'] != null) {
          searchProvider.controller.text = data['text'];
        }
        break;
      default:
        debugPrint('Action not implemented: $action');
    }
  }

  static Alignment _parseAlignment(String? alignment) {
    if (alignment == null) return Alignment.topLeft;

    switch (alignment) {
      case 'center':
        return Alignment.center;
      case 'topRight':
        return Alignment.topRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomRight':
        return Alignment.bottomRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      case 'topCenter':
        return Alignment.topCenter;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'topLeft':
      default:
        return Alignment.topLeft;
    }
  }
}

class SearchControllerProvider extends InheritedWidget {
  final TextEditingController controller;

  const SearchControllerProvider({
    required this.controller,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static SearchControllerProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SearchControllerProvider>();
  }

  @override
  bool updateShouldNotify(SearchControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
