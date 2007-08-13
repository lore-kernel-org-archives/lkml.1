Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbXHMHVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbXHMHVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966055AbXHMGZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3940 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966125AbXHMGZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:08 -0400
Date: Sun, 12 Aug 2007 23:24:55 -0700
From: joe@perches.com
To: zambrano@broadcom.com, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [112/2many] MAINTAINERS - BROADCOM B44 10/100 ETHERNET
 DRIVER
Message-ID: <46bff937.AYK9gmwTiXwzbOgL%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a21ccf1..9be0816 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1097,6 +1097,7 @@ P:	Gary Zambrano
 M:	zambrano@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/b44.*
 
 BROADCOM BNX2 GIGABIT ETHERNET DRIVER
 P:	Michael Chan
