import 'package:flutter/material.dart';

import 'download_controler.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;

  // TODO

  @override
  Widget build(BuildContext context){
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child){
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.ressource.name,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text("${controller.ressource.size} MB"),

              const SizedBox(height: 15),

              _buildContent(),
            ],
          ),
        );
      },
    );
  }
  // TODO

  Widget _buildContent() {
    if (controller.status == DownloadStatus.notDownloaded){
      return ElevatedButton(
        onPressed: controller.startDownload,
        child: const Text("Download"),
      );
    }

    if (controller.status == DownloadStatus.downloading){
      double totalSize = controller.ressource.size.toDouble();
      double downloadedSize = totalSize * controller.progress;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: controller.progress),
          const SizedBox(height: 5),
          Text(
            "${(controller.progress * 100).toInt()} % completed - "
            "${downloadedSize.toInt()} of ${totalSize.toInt()} MB",
             ),
        ],
      );
    }


    return const Text(
      "Downloaded ✔",
      style: TextStyle(color: Colors.green),
    );
  }
}
