Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbYDXTdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbYDXTdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762262AbYDXTcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:32:32 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50457 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759129AbYDXTca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:32:30 -0400
Date: Thu, 24 Apr 2008 21:32:28 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] Remove -numa from EXTRAVERSION
Message-ID: <20080424193228.GA30634@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <sebastian@breakpoint.cc>

I guess this should net get in via 919ee67.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index d35c524..3dbc826 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 25
-EXTRAVERSION = -numa
+EXTRAVERSION =
 NAME = Funky Weasel is Jiggy wit it
 
 # *DOCUMENTATION*
-- 
1.5.4.4

