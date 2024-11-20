Row(
children: [
Expanded(
flex: 2,
child: Container(
height: 100,
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage('assets/your_image.png'), // Replace with your image
fit: BoxFit.cover,
),
borderRadius: BorderRadius.circular(12),
),
),
),
const SizedBox(width: 20.0),

// Second Section: Upper Right (TextButton)
Expanded(
flex: 3,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
TextButton(
onPressed: () {},
child: const Text('Button 1'),
),
TextButton(
onPressed: () {},
child: const Text('Button 2'),
),
],
),
),
],
),

const SizedBox(height: 30.0),

// Third Section: Center Middle (Empty for future use)
Expanded(
flex: 2,
child: Container(
color: Colors.transparent,
child: const Center(
child: Text('Center Section (Future Use)'),
),
),
),
const SizedBox(height: 30.0),