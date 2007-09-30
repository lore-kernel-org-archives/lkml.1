Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXI3DVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXI3DVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXI3DV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:21:29 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53913
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753785AbXI3DV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:21:28 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add Documentation/{w1,w1/masters}/00-INDEX
Date: Sat, 29 Sep 2007 22:21:25 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709292221.25745.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Two 00-INDEX files under Documentation/w1

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/w1/00-INDEX         |    8 ++++++++
 Documentation/w1/masters/00-INDEX |    6 ++++++
 2 files changed, 14 insertions(+)

--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ kdocs/Documentation/w1/00-INDEX	2007-09-29 13:24:40.000000000 -0500
@@ -0,0 +1,8 @@
+00-INDEX
+	- This file
+masters/
+	- Individual chips providing 1-wire busses.
+w1.generic
+	- The 1-wire (w1) bus
+w1.netlink
+	- Userspace communication protocol over connector [1].
--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ kdocs/Documentation/w1/masters/00-INDEX	2007-09-29 13:23:28.000000000 -0500
@@ -0,0 +1,6 @@
+00-INDEX
+	- This file
+ds2482
+	- The Maixm/Dallas Semiconductor DS2482 provides 1-wire busses.
+ds2490
+	- The Maixm/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
