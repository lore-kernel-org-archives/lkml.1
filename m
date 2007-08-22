Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXHVOzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXHVOzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761386AbXHVOzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:55:20 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:17553 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761076AbXHVOzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:55:17 -0400
X-IronPort-AV: i="4.19,294,1183348800"; 
   d="scan'208"; a="37743991:sNHT69731207"
Subject: [PATCH take #2] MAINTAINTERS: use our mail list as Blackfin arch
	maintainters.
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, bryan.wu@analog.com,
       joe@perches.com, yi.li@analog.com, vivi.li@analog.com,
       torvalds@linux-foundation.org, sonic.zhang@analog.com,
       roy.huang@analog.com, robin.getz@analog.com,
       michael.hennerich@analog.com, michael.frysinger@analog.com,
       marc.hoffman@analog.com, linux-kernel@vger.kernel.org,
       jie.zhang@analog.com, grace.pan@analog.com, bernd.schmidt@analog.com,
       akpm@linux-foundation.org
In-Reply-To: <8bd0f97a0708220345g26c35288g5e96b6f1f8491f0e@mail.gmail.com>
References: <46bff904.ANPWrqncsP8VpmBH%joe@perches.com>
	 <1187777706.24914.2.camel@roc-desktop>
	 <6bffcb0e0708220323w5592df25n9c21c7e3aca1dbfb@mail.gmail.com>
	 <8bd0f97a0708220345g26c35288g5e96b6f1f8491f0e@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 22 Aug 2007 22:55:11 +0800
Message-Id: <1187794511.6805.3.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 22 Aug 2007 14:55:15.0258 (UTC) FILETIME=[72B9A9A0:01C7E4CC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 MAINTAINERS |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 371fe67..982e51a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -717,35 +717,7 @@ M:	rpurdie@rpsys.net
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
-L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 
-- 
1.5.2
