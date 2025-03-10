import 'package:wavefunctioncollapse/roads.dart';

bool findCollapsed() {
  bool res = false;
  roads!.forEach((row) {
    row.forEach(
      (cell) {
        if (!cell.isCollapsed) {
          res = true;
        }
        ;
      },
    );
  });
  return res;
}
