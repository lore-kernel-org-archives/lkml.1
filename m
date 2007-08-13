Return-Path: <linux-kernel-owner+w=401wt.eu-S1764442AbXHMKKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764442AbXHMKKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967182AbXHMGe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1542 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966865AbXHMGeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:25 -0400
Date: Sun, 12 Aug 2007 23:34:12 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mitch@sfgoth.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [385/2many] MAINTAINERS - PPP OVER ATM (RFC 2364)
Message-ID: <46bffb64.f8MZ035Z9dhqViPX%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 70667e6..216a280 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3685,6 +3685,7 @@ PPP OVER ATM (RFC 2364)
 P:	Mitchell Blank Jr
 M:	mitch@sfgoth.com
 S:	Maintained
+F:	net/atm/pppoatm.c
 
 PPP OVER ETHERNET
 P:	Michal Ostrowski
