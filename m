Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbYA1TLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbYA1TLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYA1TJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:09:47 -0500
Received: from smtp.nokia.com ([192.100.105.134]:52142 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762031AbYA1TJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:09:44 -0500
Message-ID: <479E27DA.8090804@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:06 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] MMC: OMAP: Include missing from previous merging
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:08:51.0617 (UTC) FILETIME=[38100910:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>

This patch adds an include missing from previous merging
mainline tree into linux-omap tree.

Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index c9dfeb1..9374163 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
+#include <linux/mmc/mmc.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
 #include <linux/clk.h>
-- 1.5.3.GIT

