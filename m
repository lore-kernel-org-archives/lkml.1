Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZKGWMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZKGWMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZKGWMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:12:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43650 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbZKGWMr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:12:47 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Jaya Kumar <jayalk@intworks.biz>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 22:12:50 +0000
Message-ID: <1257631970.15927.510.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 74/75] metronomefb: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/metronomefb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index df1f757..46bd386 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -792,3 +792,4 @@ module_exit(metronomefb_exit);
 MODULE_DESCRIPTION("fbdev driver for Metronome controller");
 MODULE_AUTHOR("Jaya Kumar");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("metronome.wbf");
-- 
1.6.5.2



