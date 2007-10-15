Return-Path: <linux-kernel-owner+w=401wt.eu-S1763688AbXJOJxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763688AbXJOJxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbXJOJxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:53:20 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51366
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323AbXJOJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:53:19 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add Documentation/block/00-INDEX
Date: Mon, 15 Oct 2007 04:53:15 -0500
User-Agent: KMail/1.9.6
Cc: Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710150453.15484.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add Documentation/block/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
---

By the way, shouldn't request.txt be in htmldocs somewhere?

 Documentation/block/00-INDEX |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ hg/Documentation/block/00-INDEX	2007-10-15 04:32:49.000000000 -0500
@@ -0,0 +1,20 @@
+00-INDEX
+	- This file
+as-iosched.txt
+	- Anticipatory IO scheduler
+barrier.txt
+	- I/O Barriers
+biodoc.txt
+	- Notes on the Generic Block Layer Rewrite in Linux 2.5
+capability.txt
+	- Generic Block Device Capability (/sys/block/<disk>/capability)
+deadline-iosched.txt
+	- Deadline IO scheduler tunables
+ioprio.txt
+	- Block io priorities (in CFQ scheduler)
+request.txt
+	- The members of struct request (in include/linux/blkdev.h)
+stat.txt
+	- Block layer statistics in /sys/block/<dev>/stat
+switching-sched.txt
+	- Switching I/O schedulers at runtime

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
