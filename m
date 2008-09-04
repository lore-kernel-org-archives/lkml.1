Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYIDUdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYIDUdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbYIDU11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:27:27 -0400
Received: from mail.work.de ([212.12.32.20]:42156 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671AbYIDU1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:27:25 -0400
Message-ID: <48C044A9.9060807@gmail.com>
Date: Fri, 05 Sep 2008 00:27:21 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 27/31] remove unreferenced delivery
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------050306000209020402090801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050306000209020402090801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From ff9e7a53cae5acdbe0195346303275e5e712ee02 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:51:40 +0200
Subject: [PATCH] DVB remove unreferenced delivery

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 frontend.h |    1 -
 1 file changed, 1 deletion(-)



--------------050306000209020402090801
Content-Type: text/x-patch;
 name="27.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="27.patch"

>From ff9e7a53cae5acdbe0195346303275e5e712ee02 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:51:40 +0200
Subject: [PATCH] DVB remove unreferenced delivery

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 6f5fecf..ee48864 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -588,7 +588,6 @@ struct dvbfe_atsc_info {
 /* DVB Frontend related Information	*/
 struct dvbfe_info {
 	char				name[128];
-	enum dvbfe_delsys		delivery;
 
 	union {
 		struct dvbfe_dvbs_info	dvbs;


--------------050306000209020402090801--
