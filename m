Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbXHMKyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbXHMKyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967375AbXHMGgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1916 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967355AbXHMGgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:38 -0400
Date: Sun, 12 Aug 2007 23:36:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [449/2many] MAINTAINERS - SPI SUBSYSTEM
Message-ID: <46bffbe3.6n/Ek/czawNxYYo0%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a168f36..14633c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4263,6 +4263,9 @@ P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	spi-devel-general@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/spi/
+F:	drivers/spi/
+F:	include/linux/spi/
 
 STABLE BRANCH:
 P:	Greg Kroah-Hartman
