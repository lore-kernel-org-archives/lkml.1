Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbXEASMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbXEASMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbXEASMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:12:14 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:52187 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755298AbXEASMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:12:13 -0400
Message-id: <88401795395522653@wsc.cz>
Subject: [PATCH 1/3] Char: mxser, schedule for removal
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue,  1 May 2007 20:12:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser, schedule for removal

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 429ee8495d50042ae8894b8302887b191f56fe5f
tree 97c280fc9246e5972d14f049837306b2bc0ec6f5
parent 60afd67836e502a099db6a5b78512f37cb44b81a
author Jiri Slaby <jirislaby@gmail.com> Tue, 01 May 2007 20:06:29 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 01 May 2007 20:06:29 +0200

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 6df26bc..44e55d6 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,14 @@ be removed from this file.
 
 ---------------------------
 
+What:	MXSER
+When:	December 2007
+Why:	Old mxser driver is obsoleted by the mxser_new. Give it some time yet
+	and remove it.
+Who:	Jiri Slaby <jirislaby@gmail.com>
+
+---------------------------
+
 What:	V4L2 VIDIOC_G_MPEGCOMP and VIDIOC_S_MPEGCOMP
 When:	October 2007
 Why:	Broken attempt to set MPEG compression parameters. These ioctls are
