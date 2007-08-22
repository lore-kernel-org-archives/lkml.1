Return-Path: <linux-kernel-owner+w=401wt.eu-S1761058AbXHVKR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058AbXHVKR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXHVKRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:17:20 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:32552 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbXHVKRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:17:19 -0400
X-IronPort-AV: i="4.19,294,1183348800"; 
   d="scan'208"; a="37724667:sNHT686564501"
Subject: [PATCH] MAINTAINTERS: use  our mail list as Blackfin arch
	maintainters.
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: joe@perches.com
Cc: yi.li@analog.com, vivi.li@analog.com, torvalds@linux-foundation.org,
       sonic.zhang@analog.com, roy.huang@analog.com, robin.getz@analog.com,
       michael.hennerich@analog.com, michael.frysinger@analog.com,
       marc.hoffman@analog.com, linux-kernel@vger.kernel.org,
       jie.zhang@analog.com, grace.pan@analog.com, bryan.wu@analog.com,
       bernd.schmidt@analog.com, akpm@linux-foundation.org
In-Reply-To: <46bff904.ANPWrqncsP8VpmBH%joe@perches.com>
References: <46bff904.ANPWrqncsP8VpmBH%joe@perches.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 22 Aug 2007 18:15:06 +0800
Message-Id: <1187777706.24914.2.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 22 Aug 2007 10:17:03.0545 (UTC) FILETIME=[95B06290:01C7E4A5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 MAINTAINERS |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4dde7f..55ac8e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -717,34 +717,6 @@ M:	rpurdie@rpsys.net
 S:	Maintained
 
 BLACKFIN ARCHITECTURE
-P:	Aubrey Li
-M:	aubrey.li@analog.com
-P:	Bernd Schmidt
-M:	bernd.schmidt@analog.com
-P:	Bryan Wu
-M:	bryan.wu@analog.com
-P:	Grace Pan
-M:	grace.pan@analog.com
-P:	Marc Hoffman
-M:	marc.hoffman@analog.com
-P:	Michael Hennerich
-M:	michael.hennerich@analog.com
-P:	Mike Frysinger
-M:	michael.frysinger@analog.com
-P:	Jerry Zeng
-M:	jerry.zeng@analog.com
-P:	Jie Zhang
-M:	jie.zhang@analog.com
-P:	Robin Getz
-M:	robin.getz@analog.com
-P:	Roy Huang
-M:	roy.huang@analog.com
-P:	Sonic Zhang
-M:	sonic.zhang@analog.com
-P:	Vivi Li
-M:	vivi.li@analog.com
-P:	Yi Li
-M:	yi.li@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
-- 
1.5.2.4
