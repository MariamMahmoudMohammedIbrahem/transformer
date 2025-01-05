import '../commons.dart';

class DataCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String isAlert;

  const DataCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.isAlert,
  });

  @override
  Widget build(BuildContext context) {
    final double valueNumeric = double.tryParse(value.split(' ')[0]) ?? 0.0;

    return Card(
      elevation: 2.0,
      shadowColor: isAlert!='inactive'&&isAlert.isNotEmpty ? Colors.red.shade900 : Colors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isAlert!='inactive'&&isAlert.isNotEmpty ? Colors.red.shade900 : Colors.yellow,
          width: isAlert!='inactive'&&isAlert.isNotEmpty ? 1.0 : 0.0,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade200,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            if (valueNumeric != 0.0)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAlert!='inactive'&&isAlert.isNotEmpty)
                    Icon(
                      isAlert == 'high'
                          ? Icons.arrow_upward_rounded
                          : isAlert == 'low'
                          ? Icons.arrow_downward_rounded
                          : null,
                      color: Colors.red.shade900,
                      size: 25,
                    ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
