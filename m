Return-Path: <linux-kernel-owner+w=401wt.eu-S1763591AbXGNSuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763591AbXGNSuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbXGNSuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:50:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:18045 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765AbXGNSuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:50:18 -0400
X-IronPort-AV: i="4.16,539,1175486400"; 
   d="scan'208"; a="34898729:sNHT25350045"
Subject: [PATCH 3/3] Blackfin On-Chip RTC driver update for supporting BF54x
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <michael.frysinger@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Sun, 15 Jul 2007 02:50:08 +0800
Message-Id: <1184439008.3140.25.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 14 Jul 2007 18:50:15.0629 (UTC) FILETIME=[D11747D0:01C7C647]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/rtc/rtc-bfin.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 260ead9..1aa709d 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -1,6 +1,6 @@
 /*
  * Blackfin On-Chip Real Time Clock Driver
- *  Supports BF531/BF532/BF533/BF534/BF536/BF537
+ *  Supports BF53[123]/BF53[467]/BF54[2489]
  *
  * Copyright 2004-2007 Analog Devices Inc.
  *
-- 
1.5.2
