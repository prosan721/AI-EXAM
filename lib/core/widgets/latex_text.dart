import 'package:flutter/material.dart';

class LatexText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const LatexText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext buildContext) {
    final baseStyle = style ?? Theme.of(buildContext).textTheme.bodyLarge ?? const TextStyle();

    // Replaces mathematical fraction notation \frac{num}{den} with clean inline representation (num/den)
    // for direct display inside standard RichText.
    String parsed = text;
    
    // Parse LaTeX style fraction: \frac{20}{100} -> 20/100
    final RegExp fracRegex = RegExp(r'\\frac\{([^{}]+)\}\{([^{}]+)\}');
    parsed = parsed.replaceAllMapped(fracRegex, (match) {
      return '${match.group(1)}/${match.group(2)}';
    });

    // Parse LaTeX style exponents: e.g. x^2
    final RegExp expRegex = RegExp(r'(\w+)\^(\w+)');
    parsed = parsed.replaceAllMapped(expRegex, (match) {
      return '${match.group(1)}²'; // or match.group(1) + superscript
    });

    // Parse simple bold markdown: **text** -> text with bold style
    final List<TextSpan> spans = [];
    final RegExp boldRegex = RegExp(r'\*\*([^*]+)\*\*');
    
    int index = 0;
    for (final match in boldRegex.allMatches(parsed)) {
      if (match.start > index) {
        spans.add(TextSpan(text: parsed.substring(index, match.start), style: baseStyle));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: baseStyle.copyWith(fontWeight: FontWeight.bold, color: Theme.of(buildContext).primaryColor),
      ));
      index = match.end;
    }
    
    if (index < parsed.length) {
      spans.add(TextSpan(text: parsed.substring(index), style: baseStyle));
    }

    if (spans.isEmpty) {
      return Text(parsed, style: baseStyle);
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
