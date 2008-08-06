Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbYHFVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbYHFVSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbYHFVMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:12:19 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59612 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758331AbYHFVMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:17 -0400
Date: Thu, 7 Aug 2008 00:10:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] Alpha Miata: remove dead URL
Message-ID: <20080806211049.GL1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a dead URL.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 20 May 2008

deb4137671451a172bc7b9ed62cae9fbfd1decba diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 729cdbd..97d58e8 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -224,8 +224,7 @@ config ALPHA_MIATA
 	bool "Miata"
 	help
 	  The Digital PersonalWorkStation (PWS 433a, 433au, 500a, 500au, 600a,
-	  or 600au).  There is an Installation HOWTO for this hardware at
-	  <http://eijk.homelinux.org/~stefan/miata.html>.
+	  or 600au).
 
 config ALPHA_MIKASA
 	bool "Mikasa"

