Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYBWQRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYBWQRs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYBWQRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:17:38 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:51382 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYBWQRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:17:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] hwrng: Remove me as a HWRNG maintainer
Date: Sat, 23 Feb 2008 17:16:50 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802231716.50622.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that I rewrote the HWRNG core once to make it
pluggable, but I'm not a crypto-expert at all. So I'm
certainly the wrong person for being a maintainer of
the HWRNG core. Let's orphan it.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-testing/MAINTAINERS
===================================================================
--- wireless-testing.orig/MAINTAINERS	2008-02-16 19:08:05.000000000 +0100
+++ wireless-testing/MAINTAINERS	2008-02-23 17:13:36.000000000 +0100
@@ -1721,9 +1721,7 @@ T:	git lm-sensors.org:/kernel/mhoffman/h
 S:	Maintained
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
-P:	Michael Buesch
-M:	mb@bu3sch.de
-S:	Maintained
+S:	Orphaned
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 P:	Robert Love

-- 
Greetings Michael.
