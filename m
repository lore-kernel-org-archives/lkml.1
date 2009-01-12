Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbZALWvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbZALWvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZALWf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:35:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44925 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427AbZALWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:35:57 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       trivial@kernel.org
Date: Mon, 12 Jan 2009 23:35:46 +0100
Message-Id: <1231799750-21060-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] fix typo "thier" -> "their"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: trivial@kernel.org
---
 drivers/base/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index c98c31e..a0361ae 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -299,7 +299,7 @@ void sysdev_unregister(struct sys_device * sysdev)
  *	and the class driver.
  *
  *	Note: The list is iterated in reverse order, so that we shut down
- *	child devices before we shut down thier parents. The list ordering
+ *	child devices before we shut down their parents. The list ordering
  *	is guaranteed by virtue of the fact that child devices are registered
  *	after their parents.
  */
-- 
1.5.6.5

