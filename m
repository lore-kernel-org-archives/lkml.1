Return-Path: <linux-kernel-owner+w=401wt.eu-S1762809AbXHMLBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762809AbXHMLBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967373AbXHMGhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1991 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967369AbXHMGhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:05 -0400
Date: Sun, 12 Aug 2007 23:36:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbglaw@lug-owl.de, akpm@linux-foundation.org
Subject: [PATCH] [460/2many] MAINTAINERS - SRM (Alpha) environment access
Message-ID: <46bffbfc.aw6EQE4fWM2Hq6vM%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fa8fb1c..3c134fa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4386,6 +4386,8 @@ P:	Jan-Benedict Glaw
 M:	jbglaw@lug-owl.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	arch/alpha/kernel/*srm*
+F:	arch/alpha/lib/srm*
 
 STARFIRE/DURALAN NETWORK DRIVER
 P:	Ion Badulescu
