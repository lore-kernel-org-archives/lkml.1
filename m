Return-Path: <linux-kernel-owner+w=401wt.eu-S970216AbXHMIlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970216AbXHMIlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966671AbXHMGaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:08 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4729 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966849AbXHMG37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:59 -0400
Date: Sun, 12 Aug 2007 23:29:43 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, akpm@linux-foundation.org
Subject: [PATCH] [252/2many] MAINTAINERS - INTEL I8XX RANDOM NUMBER
 GENERATOR SUPPORT
Message-ID: <46bffa57.t5ArQ+2PcfemRA2p%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index cb1c725..773dd76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2392,6 +2392,7 @@ P:	Jeff Garzik
 M:	jgarzik@pobox.com
 W:	http://sourceforge.net/projects/gkernel/
 S:	Maintained
+F:	drivers/char/hw_random/intel-rng.c
 
 INTEL IA32 MICROCODE UPDATE SUPPORT
 P:	Tigran Aivazian
