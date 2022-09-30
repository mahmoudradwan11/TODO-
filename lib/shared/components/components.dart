import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultTextedButton({
  bool textUpper = false,
  double width = double.infinity, //default value;
  Color background = Colors.blue, //default value;
  required var onPressed,
  required String text,
}) =>
    Container(
      width: width,
      color: background,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          textUpper ? text.toUpperCase() : text.toLowerCase(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  var onTap,
  var onSubmit,
  var onChanged,
  var suffixPressed,
  required var validator,
  required String label,
  IconData? prefixIcon,
  IconData? suffixIcon,
  bool hiddenPassword = true,
}) =>
    TextFormField(
      onTap: onTap,
      obscureText: hiddenPassword,
      controller: controller,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        border:OutlineInputBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: suffixPressed,
              )
            : null,
      ),
    );
Widget builtTaskItem(Map model, context) => Dismissible(
      key:Key(model['id'].toString()),
      onDismissed:(direction)
      {
          TodoCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: const Icon(
                Icons.done_all,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context).updateData(
                  status: 'archived',
                  id: model['id'],
                );
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
