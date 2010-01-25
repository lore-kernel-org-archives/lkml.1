Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468Ab0AYFIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab0AYFIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 00:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805Ab0AYFIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 00:08:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab0AYFIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 00:08:18 -0500
Date: Mon, 25 Jan 2010 00:07:30 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Amerigo Wang <amwang@redhat.com>
Message-Id: <20100125051052.3999.28082.sendpatchset@localhost.localdomain>
Subject: [Patch] perf: ignore perf.data.old
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell git to ignore this file.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index fe08660..124760b 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -13,6 +13,7 @@ perf*.xml
 perf*.html
 common-cmds.h
 perf.data
+perf.data.old
 tags
 TAGS
 cscope*
