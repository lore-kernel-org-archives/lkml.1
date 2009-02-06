Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbZBFNxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbZBFNxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbZBFNxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:53:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47666 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370AbZBFNxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:53:23 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] =?utf-8?q?add=20another=20mailmap=20entry=20for=20Uwe=20Kleine-K=C3=B6nig?=
Date: Fri,  6 Feb 2009 14:53:19 +0100
Message-Id: <1233928399-22012-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233928399-22012-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1233928399-22012-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created commit 7971db5a4b4176ad5df590fce07a962c643a2740 on a machine
where I forgot to set user.name and user.email before.  The default
values were not optimal.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 .mailmap |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/.mailmap b/.mailmap
index aa934d1..a62e6a8 100644
--- a/.mailmap
+++ b/.mailmap
@@ -101,6 +101,7 @@ Tejun Heo <htejun@gmail.com>
 Thomas Graf <tgraf@suug.ch>
 Tony Luck <tony.luck@intel.com>
 Tsuneo Yoshioka <Tsuneo.Yoshioka@f-secure.com>
-Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
 Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
+Uwe Kleine-König <ukl@pengutronix.de>
+Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
 Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
-- 
1.5.6.5

