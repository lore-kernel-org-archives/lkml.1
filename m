Return-Path: <linux-kernel-owner+w=401wt.eu-S970805AbXHMJ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970805AbXHMJ3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966976AbXHMGcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1179 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966906AbXHMGc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:27 -0400
Date: Sun, 12 Aug 2007 23:32:13 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [324/2many] MAINTAINERS - MOXA SMARTIO/INDUSTIO SERIAL
 CARD (MXSER 2.0)
Message-ID: <46bffaed.zgG/64zMGWFNDCEO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 451735d..3404f8a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3114,6 +3114,9 @@ P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/moxa-smartio
+F:	drivers/char/moxa.c
+F:	drivers/char/mxser*
 
 MSI LAPTOP SUPPORT
 P:	Lennart Poettering
