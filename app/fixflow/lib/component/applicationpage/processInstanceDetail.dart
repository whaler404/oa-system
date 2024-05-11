// ignore_for_file: prefer_interpolation_to_compose_strings, unused_field, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:fixflow/config/api_url.dart';
import 'package:fixflow/config/classDefinition.dart';
import 'package:fixflow/config/function.dart';
import 'package:fixflow/config/user_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ProcessInstanceDetailWidget extends StatefulWidget {
  final String processInstanceId;

  const ProcessInstanceDetailWidget({Key? key, required this.processInstanceId})
      : super(key: key);

  @override
  _ProcessInstanceDetailWidgetState createState() =>
      _ProcessInstanceDetailWidgetState();
}

class _ProcessInstanceDetailWidgetState
    extends State<ProcessInstanceDetailWidget> {
  late Future<ProcessInstanceDetail> _processInstanceDetail;
  late Future<Uint8List?> _imageData;

  @override
  void initState() {
    super.initState();
    _processInstanceDetail = _fetchProcessInstanceDetail();
    _imageData = _fetchImageData();
  }

  Future<Uint8List?> _fetchImageData() async {
    final token = Provider.of<UserTokenProvider>(context, listen: false).token;
    final String imageUrl =
        ApiUrls.getProcessInstanceDiagram + '/' + widget.processInstanceId;
    print(imageUrl);

    try {
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'Accept': 'image/png',
          'Authorization': token ?? '',
        },
      );

      print(response);
      print(response.statusCode);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print(response.statusCode);
        return null; // Return null if image request fails
      }
    } catch (e) {
      return null; // Return null if there is a network error
    }
  }

  Future<ProcessInstanceDetail> _fetchProcessInstanceDetail() async {
    final token = Provider.of<UserTokenProvider>(context, listen: false).token;
    final String url =
        ApiUrls.getProcessInstance + '/' + widget.processInstanceId;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': '*/*',
          'Authorization': token ?? '',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(decodedResponse);
        final int code = responseData['code'];
        if (code == 0) {
          final data = responseData['data'];
          return ProcessInstanceDetail.fromJson(data);
        } else {
          throw Exception('Failed to load process instance detail');
        }
      } else {
        throw Exception('Failed to load process instance detail');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Widget _buildDetailItem(String title, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start, // 让文本顶部对齐
          children: [
            Flexible(
              // 使用 Flexible 包裹文本，使其自动换行
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18, // 增加字体大小
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8), // 添加间距，使标题和内容之间有一定的距离
            Expanded(
              // 使用 Expanded 包裹文本，使其自动换行
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 18, // 增加字体大小
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 创建时间轴项的UI表示
  Widget _buildTimelineTile(
      Progress progress, bool isFirstItem, bool isLastItem) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.1, // 这定义了线条和内容的相对位置
      isFirst: isFirstItem,
      isLast: isLastItem,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: Colors.blue,
        padding: EdgeInsets.all(6),
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(progress.taskName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(parseDateFormat(progress.endTime),
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 4),
            Text(progress.description ?? '无描述', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('流程实例详情'),
  //     ),
  //     body: FutureBuilder<ProcessInstanceDetail>(
  //       future: _processInstanceDetail,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else {
  //           final processInstanceDetail = snapshot.data!;
  //           final progressList = processInstanceDetail.progress;

  //           return SingleChildScrollView(
  //             // 使用 SingleChildScrollView 来使整个页面都能滚动
  //             child: Column(
  //               children: [
  //                 ListView(
  //                   shrinkWrap: true, // 使用shrinkWrap来让ListView只占用其内容的大小
  //                   physics: NeverScrollableScrollPhysics(), // 禁止ListView本身滚动
  //                   padding: EdgeInsets.all(16.0),
  //                   children: [
  //                     _buildDetailItem(
  //                         '流程名称',
  //                         processInstanceDetail
  //                             .processDefinition.processDefinitionName),
  //                     _buildDetailItem(
  //                         '流程ID', processInstanceDetail.processInstanceId),
  //                     _buildDetailItem('开始时间',
  //                         parseDateFormat(processInstanceDetail.startTime)),
  //                     _buildDetailItem(
  //                         '结束时间',
  //                         processInstanceDetail.endTime != null
  //                             ? parseDateFormat(processInstanceDetail.endTime!)
  //                             : '暂无'),
  //                     _buildDetailItem('是否完成',
  //                         processInstanceDetail.isCompleted ? '是' : '否'),
  //                   ],
  //                 ),
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: progressList.length,
  //                   itemBuilder: (context, index) {
  //                     final progress = progressList[index];
  //                     return _buildTimelineTile(progress, index == 0,
  //                         index == progressList.length - 1);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('流程实例详情'),
    ),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '当前流程进度图',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FutureBuilder<Uint8List?>(
            future: _imageData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final Uint8List? imageBytes = snapshot.data;
                if (imageBytes != null) {
                  return Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  );
                } else {
                  return Center(child: Text('Failed to load image'));
                }
              }
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '流程进度记录',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return FutureBuilder<ProcessInstanceDetail>(
                future: _processInstanceDetail,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final detail = snapshot.data!;
                    final progressList = detail.progress;
                    return Column(
                      children: progressList.map((progress) =>
                        _buildTimelineTile(progress, progress == progressList.first, progress == progressList.last)).toList(),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            },
            childCount: 1, // We expect a single child in this build delegate
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '流程实例信息',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return FutureBuilder<ProcessInstanceDetail>(
                future: _processInstanceDetail,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final detail = snapshot.data!;
                    return Column(
                      children: [
                        _buildDetailItem('流程名称', detail.processDefinition.processDefinitionName),
                        _buildDetailItem('流程ID', detail.processInstanceId),
                        _buildDetailItem('开始时间', parseDateFormat(detail.startTime)),
                        _buildDetailItem('结束时间', detail.endTime != null ? parseDateFormat(detail.endTime!) : '暂无'),
                        _buildDetailItem('是否完成', detail.isCompleted ? '是' : '否'),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            },
            childCount: 1, // We expect a single child in this build delegate
          ),
        ),
      ],
    ),
  );
}

}
