import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dotnetapiflutter/modle.dart';
import 'package:stack_trace/stack_trace.dart';


class api_hendler {
  final String baseUrl = 'http://10.0.2.2:5249/api/users'; // Use the correct IP address

  Future<List<User>> getUserData() async {
    List<User> data = [];
    final uri = Uri.parse(baseUrl);

    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        data = jsonData.map((json) => User.fromJson(json)).toList();
        // Print each user individually
        data.forEach((user) => print('User: $user'));
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Exception: $e');
      throw Exception('Failed to connect to the server');
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      print('Address: ${e.address}, Port: ${e.port}');
      throw Exception('Network error: Failed to connect to the server');
    } on FormatException catch (e) {
      print('Format Exception: $e');
      throw Exception('Invalid data format received from server');
    } catch (e) {
      print('Error: $e');
      throw Exception('An unexpected error occurred');
    }

    return data;
  }
   Future<http.Response> updateUser(
      {required int userId, required User user}) async {
    final uri = Uri.parse("$baseUrl/$userId");

    late http.Response response;

    try {
      response = await http.put(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
        body: json.encode(user),
      );
    } catch (e) {
      return response;
    }

    return response;
  }


  Future<http.Response> postUser({required User user}) async {
  final uri = Uri.parse("$baseUrl");

  try {
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-type': 'application/json; charset=utf-8'
      },
      body: json.encode(user),
    );
    return response;
  } catch (e) {
    // Handle the error here, such as logging or rethrowing
    print('Error occurred: $e');
    // Return a meaningful error response or throw the exception
    return http.Response('Error occurred during HTTP request', 500);
  }
}

Future<http.Response> DeleteUser(
      {required int userId}) async {
    final uri = Uri.parse("$baseUrl/$userId");

    late http.Response response;

    try {
      response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=utf-8'
        },
      );
    } catch (e) {
      return response;
    }

    return response;
  }

}
