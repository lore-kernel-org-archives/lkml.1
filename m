Return-Path: <linux-kernel-owner+w=401wt.eu-S967246AbXHMGfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967246AbXHMGfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965756AbXHMGWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3520 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965710AbXHMGWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:43 -0400
Date: Sun, 12 Aug 2007 23:21:52 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, ehaase@inf.fu-berlin.de,
       akpm@linux-foundation.org, A2232@gmx.net
Subject: [PATCH] [15/2many] MAINTAINERS - A2232 SERIAL BOARD DRIVER
Message-ID: <46bff880.F3THEWshSSEbUMkt%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index acba68e..7989432 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -194,6 +194,7 @@ M:	ehaase@inf.fu-berlin.de
 M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
+F:	drivers/char/ser_a2232*
 
 AIO
 P:	Benjamin LaHaise
