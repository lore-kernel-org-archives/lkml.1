Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYIDUYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYIDUYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbYIDUXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:23:49 -0400
Received: from mail.work.de ([212.12.32.20]:34076 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbYIDUXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:23:48 -0400
Message-ID: <48C043D0.70507@gmail.com>
Date: Fri, 05 Sep 2008 00:23:44 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 5/31] increment api minor
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------090702030903080708020306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090702030903080708020306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 66d17eea7f3962e571fbb3b8809cc5696a050878 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:20:30 +0200
Subject: [PATCH] DVB API update: Increment API minor version

* Increment API minor version to reflect the changes to the
frontend API

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--------------090702030903080708020306
Content-Type: text/x-patch;
 name="5.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="5.patch"

>From 66d17eea7f3962e571fbb3b8809cc5696a050878 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:20:30 +0200
Subject: [PATCH] DVB API update: Increment API minor version

* Increment API minor version to reflect the changes to the
frontend API

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
index 126e0c2..2dd76c8 100644
--- a/include/linux/dvb/version.h
+++ b/include/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 3
-#define DVB_API_VERSION_MINOR 2
+#define DVB_API_VERSION_MINOR 3
 
 #endif /*_DVBVERSION_H_*/


--------------090702030903080708020306--
