Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYHURlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYHURlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760425AbYHURkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:40:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760281AbYHURkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:40:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Magnus Damm <magnus.damm@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/15] UIO: uio_pdrv: fix license specification
Date: Thu, 21 Aug 2008 10:33:01 -0700
Message-Id: <1219339983-9634-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Thanks to Magnus Damm for pointing that out.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.5.6.5

