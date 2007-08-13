Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXHMKI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXHMKI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967187AbXHMGeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1535 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967155AbXHMGeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:22 -0400
Date: Sun, 12 Aug 2007 23:34:10 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, paulus@samba.org, linux-ppp@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [384/2many] MAINTAINERS - PPP PROTOCOL DRIVERS AND
 COMPRESSORS
Message-ID: <46bffb62.YUHsMJB9NIlhwots%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 62354a9..70667e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3679,6 +3679,7 @@ P:	Paul Mackerras
 M:	paulus@samba.org
 L:	linux-ppp@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ppp_*
 
 PPP OVER ATM (RFC 2364)
 P:	Mitchell Blank Jr
