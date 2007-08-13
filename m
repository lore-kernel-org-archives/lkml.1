Return-Path: <linux-kernel-owner+w=401wt.eu-S939297AbXHMJdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939297AbXHMJdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967046AbXHMGcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1212 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966963AbXHMGcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:39 -0400
Date: Sun, 12 Aug 2007 23:32:26 -0700
From: joe@perches.com
To: vandrove@vc.cvut.cz, torvalds@linux-foundation.org, linware@sh.cvut.cz,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [331/2many] MAINTAINERS - NCP FILESYSTEM
Message-ID: <46bffafa.sN6Vsxjg2xz6a1/X%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b7039c..e372aeb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3170,6 +3170,7 @@ P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
 L:	linware@sh.cvut.cz
 S:	Maintained
+F:	fs/ncpfs/
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
 P:	James E.J. Bottomley
