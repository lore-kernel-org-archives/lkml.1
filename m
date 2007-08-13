Return-Path: <linux-kernel-owner+w=401wt.eu-S969371AbXHMI0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969371AbXHMI0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966601AbXHMG3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4587 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966522AbXHMG3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:05 -0400
Date: Sun, 12 Aug 2007 23:28:52 -0700
From: joe@perches.com
To: venkatesh.pallipadi@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [226/2many] MAINTAINERS - HPET:	i386
Message-ID: <46bffa24.QnW17OwYqtAV9xb+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 571279b..2cd96ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2158,6 +2158,8 @@ HPET:	i386
 P:	Venkatesh Pallipadi (Venki)
 M:	venkatesh.pallipadi@intel.com
 S:	Maintained
+F:	arch/i386/kernel/hpet.c
+F:	include/asm-i386/hpet.h
 
 HPET:	x86_64
 P:	Andi Kleen and Vojtech Pavlik
