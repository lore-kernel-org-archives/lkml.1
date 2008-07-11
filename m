Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYGKJLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYGKJLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYGKJKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:10:44 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:28556 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbYGKJKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:10:43 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-164.messagelabs.com!1215767441!11808936!2
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Greg KH <greg@kroah.com>, "Hans J. Koch" <hjk@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] uio_pdrv: fix license specification
Date: Fri, 11 Jul 2008 11:10:37 +0200
Message-ID: <1215767437-20583-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1215767437-20583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <DOR-SMS-MAIL1KqnjYT00000466@dor-sms-mail1.digi.com>
 <1215767437-20583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
 <1215767437-20583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Jul 2008 09:10:37.0549 (UTC) FILETIME=[FBB0A9D0:01C8E335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Magnus Damm for pointing that out.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
---
 drivers/uio/uio_pdrv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
index aa3bff8..0b4ef39 100644
--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -116,5 +116,5 @@ module_exit(uio_pdrv_exit);
 
 MODULE_AUTHOR("Uwe Kleine-Koenig");
 MODULE_DESCRIPTION("Userspace I/O platform driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.5.6.2

