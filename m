Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbYAQWlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbYAQWlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbYAQWgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:36:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36243 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbYAQWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:36 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>
Subject: [PATCH 27/30] ocfs2: bump version number
Date: Thu, 17 Jan 2008 14:35:53 -0800
Message-Id: <1200609356-17788-28-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump the printed version to 1.5.0. This helps us quickly identify which
version of Ocfs2 a bug filer is running.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/ver.c  |    2 +-
 fs/ocfs2/dlm/dlmfsver.c |    2 +-
 fs/ocfs2/dlm/dlmver.c   |    2 +-
 fs/ocfs2/ver.c          |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/ver.c b/fs/ocfs2/cluster/ver.c
index 7286c48..a56eee6 100644
--- a/fs/ocfs2/cluster/ver.c
+++ b/fs/ocfs2/cluster/ver.c
@@ -28,7 +28,7 @@
 
 #include "ver.h"
 
-#define CLUSTER_BUILD_VERSION "1.3.3"
+#define CLUSTER_BUILD_VERSION "1.5.0"
 
 #define VERSION_STR "OCFS2 Node Manager " CLUSTER_BUILD_VERSION
 
diff --git a/fs/ocfs2/dlm/dlmfsver.c b/fs/ocfs2/dlm/dlmfsver.c
index d2be3ad..a733b33 100644
--- a/fs/ocfs2/dlm/dlmfsver.c
+++ b/fs/ocfs2/dlm/dlmfsver.c
@@ -28,7 +28,7 @@
 
 #include "dlmfsver.h"
 
-#define DLM_BUILD_VERSION "1.3.3"
+#define DLM_BUILD_VERSION "1.5.0"
 
 #define VERSION_STR "OCFS2 DLMFS " DLM_BUILD_VERSION
 
diff --git a/fs/ocfs2/dlm/dlmver.c b/fs/ocfs2/dlm/dlmver.c
index 7ef2653..dfc0da4 100644
--- a/fs/ocfs2/dlm/dlmver.c
+++ b/fs/ocfs2/dlm/dlmver.c
@@ -28,7 +28,7 @@
 
 #include "dlmver.h"
 
-#define DLM_BUILD_VERSION "1.3.3"
+#define DLM_BUILD_VERSION "1.5.0"
 
 #define VERSION_STR "OCFS2 DLM " DLM_BUILD_VERSION
 
diff --git a/fs/ocfs2/ver.c b/fs/ocfs2/ver.c
index 5405ce1..e2488f4 100644
--- a/fs/ocfs2/ver.c
+++ b/fs/ocfs2/ver.c
@@ -29,7 +29,7 @@
 
 #include "ver.h"
 
-#define OCFS2_BUILD_VERSION "1.3.3"
+#define OCFS2_BUILD_VERSION "1.5.0"
 
 #define VERSION_STR "OCFS2 " OCFS2_BUILD_VERSION
 
-- 
1.5.3.6

