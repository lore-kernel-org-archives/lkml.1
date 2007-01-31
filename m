Return-Path: <linux-kernel-owner+w=401wt.eu-S932811AbXAaDqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbXAaDqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932786AbXAaDpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:45:13 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:32153 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbXAaDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:44:37 -0500
From: Divy Le Ray <None@chelsio.com>
Subject: [PATCH 9/10] cxgb3 - Add <linux/mutex.h>
Date: Tue, 30 Jan 2007 19:44:29 -0800
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Message-Id: <20070131034429.8662.70355.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Include <linux/mutex.h> in adapter.h

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/adapter.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/cxgb3/adapter.h b/drivers/net/cxgb3/adapter.h
index 8902007..97e35c8 100644
--- a/drivers/net/cxgb3/adapter.h
+++ b/drivers/net/cxgb3/adapter.h
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/timer.h>
 #include <linux/cache.h>
+#include <linux/mutex.h>
 #include "t3cdev.h"
 #include <asm/semaphore.h>
 #include <asm/bitops.h>
