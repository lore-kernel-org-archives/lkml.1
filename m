Return-Path: <linux-kernel-owner+w=401wt.eu-S972072AbXHMJyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972072AbXHMJyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967061AbXHMGdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1411 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967113AbXHMGdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:44 -0400
Date: Sun, 12 Aug 2007 23:33:29 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, parisc-linux@parisc-linux.org,
       matthew@wil.cx, linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       grundler@parisc-linux.org, akpm@linux-foundation.org
Subject: [PATCH] [364/2many] MAINTAINERS - PARISC ARCHITECTURE
Message-ID: <46bffb39.r38pD9JiTg/Z0inR%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0134f18..2166416 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3504,6 +3504,8 @@ W:	http://www.parisc-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 T:	cvs cvs.parisc-linux.org:/var/cvs/linux-2.6
 S:	Maintained
+F:	arch/parisc/
+F:	include/asm-parisc/
 
 PARAVIRT_OPS INTERFACE
 P:	Jeremy Fitzhardinge
