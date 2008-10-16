Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYJPRgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYJPRgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYJPRgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:36:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:21079 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYJPRgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=khQSIEMQ8tpiRezMmeZ5lAQsdXiryeYEXeaNcNnSa5e90DVW+PF0+oR7BNVEIECKrT
         XecyHsvXTdXZIeerOZRRHxKs8+GHyjUByFvQBgrgGaUXhHQ8awRpWMTkyKHQn7Vhy29L
         cB8EyluiA87lukm24v7L4DEUkujuUK3zYf/oI=
From: Bryan Wu <cooloney@kernel.org>
To: linux@dominikbrodowski.net
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Robin Getz <rgetz@blackfin.uclinux.org>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] cpu-freq/Documentation: Add Blackfin to list of supported processors
Date: Fri, 17 Oct 2008 01:36:43 +0800
Message-Id: <1224178603-12070-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 Documentation/cpu-freq/user-guide.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/cpu-freq/user-guide.txt b/Documentation/cpu-freq/user-guide.txt
index 6c442d8..4f3f384 100644
--- a/Documentation/cpu-freq/user-guide.txt
+++ b/Documentation/cpu-freq/user-guide.txt
@@ -23,6 +23,7 @@ Contents:
 1.3 sparc64
 1.4 ppc
 1.5 SuperH
+1.6 Blackfin
 
 2. "Policy" / "Governor"?
 2.1 Policy
@@ -97,6 +98,17 @@ The following SuperH processors are supported by cpufreq:
 SH-3
 SH-4
 
+1.6 Blackfin
+------------
+
+The following Blackfin processors are supported by cpufreq:
+
+BF522, BF523, BF524, BF525, BF526, BF527, Rev 0.1 or higher
+BF531, BF532, BF533, Rev 0.3 or higher
+BF534, BF536, BF537, Rev 0.2 or higher
+BF561, Rev 0.3 or higher
+BF542, BF544, BF547, BF548, BF549, Rev 0.1 or higher
+
 
 2. "Policy" / "Governor" ?
 ==========================
-- 
1.5.6

