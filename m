Return-Path: <linux-kernel-owner+w=401wt.eu-S1763184AbYHFVSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763184AbYHFVSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbYHFVMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:12:22 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47629 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760694AbYHFVMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:21 -0400
Date: Thu, 7 Aug 2008 00:10:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] MAINTAINERS: remove ZF MACHZ WATCHDOG entry
Message-ID: <20080806211052.GM1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- maintainer has not been active for years
- maintainer email bounces
- URL no longer exists
- covered by the WATCHDOG DEVICE DRIVERS entry

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 20 May 2008

3f02b057b07dee95e02f58a0f9109a8c8815ae2c diff --git a/MAINTAINERS b/MAINTAINERS
index 52b7035..2f74092 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4521,12 +4521,6 @@ L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
-ZF MACHZ WATCHDOG
-P:	Fernando Fuganti
-M:	fuganti@netbank.com.br
-W:	http://cvs.conectiva.com.br/drivers/ZFL-watchdog/
-S:	Maintained
-
 ZR36067 VIDEO FOR LINUX DRIVER
 P:	Ronald Bultje
 M:	rbultje@ronald.bitfreak.net


