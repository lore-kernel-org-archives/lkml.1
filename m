Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZBRKaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZBRKaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZBRKaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:30:09 -0500
Received: from mfow300.po.2iij.net ([210.128.50.201]:41803 "EHLO
	mfow.po.2iij.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbZBRKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:30:06 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 05:30:05 EST
Date: Wed, 18 Feb 2009 19:09:23 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: yoichi_yuasa@tripeaks.co.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix opensound URL in oss Introduction
Message-Id: <20090218190923.cab5adcc.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff --git a/Documentation/sound/oss/Introduction b/Documentation/sound/oss/Introduction
index f04ba6b..75d967f 100644
--- a/Documentation/sound/oss/Introduction
+++ b/Documentation/sound/oss/Introduction
@@ -80,7 +80,7 @@ Notes:
     additional features.
 
 2.  The commercial OSS driver may be obtained from the site:
-    http://www/opensound.com.  This may be used for cards that
+    http://www.opensound.com.  This may be used for cards that
     are unsupported by the kernel driver, or may be used
     by other operating systems.  
 
