Return-Path: <linux-kernel-owner+w=401wt.eu-S945286AbXHMMN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945286AbXHMMN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763405AbXHMGkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2513 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967479AbXHMGkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:22 -0400
Date: Sun, 12 Aug 2007 23:40:04 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       fuganti@netbank.com.br, akpm@linux-foundation.org
Subject: [PATCH] [553/2many] MAINTAINERS - ZF MACHZ WATCHDOG
Message-ID: <46bffcc4.7VJ9ezg0Nu6iioae%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 937df70..b21841e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5236,6 +5236,7 @@ P:	Fernando Fuganti
 M:	fuganti@netbank.com.br
 W:	http://cvs.conectiva.com.br/drivers/ZFL-watchdog/
 S:	Maintained
+F:	drivers/char/watchdog/machzwd.c
 
 ZR36067 VIDEO FOR LINUX DRIVER
 P:	Ronald Bultje
