Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZIFTaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZIFTaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 15:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbZIFTaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 15:30:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56211 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbZIFTaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 15:30:23 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: update a filename in documentation
Date: Sun,  6 Sep 2009 21:26:23 +0200
Message-Id: <1252265183-7626-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SA Timed out after 240 secs
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/power/regulator/overview.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/power/regulator/overview.txt b/Documentation/power/regulator/overview.txt
index 0cded69..b471575 100644
--- a/Documentation/power/regulator/overview.txt
+++ b/Documentation/power/regulator/overview.txt
@@ -168,4 +168,4 @@ relevant to non SoC devices and is split into the following four interfaces:-
       userspace via sysfs. This could be used to help monitor device power
       consumption and status.
 
-        See Documentation/ABI/testing/regulator-sysfs.txt
+        See Documentation/ABI/testing/sysfs-class-regulator
-- 
1.6.3.3

