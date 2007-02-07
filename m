Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXBGGwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXBGGwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965653AbXBGGwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:52:53 -0500
Received: from koto.vergenet.net ([210.128.90.7]:56743 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965650AbXBGGwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:52:51 -0500
Date: Wed, 7 Feb 2007 15:49:25 +0900
From: Horms <horms@verge.net.au>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <trivial@kernel.org>, Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH] [IA64] whitespace fixes for include/asm-ia64/sal.h
Message-ID: <20070207064924.GA726@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Make use of spaces and tabs consistent
* Make long line < 80col

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/include/asm-ia64/sal.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/sal.h	2007-02-07 11:53:12.000000000 +0900
+++ linux-2.6/include/asm-ia64/sal.h	2007-02-07 12:46:57.000000000 +0900
@@ -860,12 +867,13 @@
  */
 struct sal_to_os_boot {
 	u64 rr[8];		/* Region Registers */
-	u64	br[6];		/* br0: return addr into SAL boot rendez routine */
+	u64 br[6];		/* br0:
+				 * return addr into SAL boot rendez routine */
 	u64 gr1;		/* SAL:GP */
 	u64 gr12;		/* SAL:SP */
 	u64 gr13;		/* SAL: Task Pointer */
 	u64 fpsr;
-	u64	pfs;
+	u64 pfs;
 	u64 rnat;
 	u64 unat;
 	u64 bspstore;

