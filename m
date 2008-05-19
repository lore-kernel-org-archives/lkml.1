Return-Path: <linux-kernel-owner+w=401wt.eu-S1764410AbYESWQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764410AbYESWQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765125AbYESWKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:10:20 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40341 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764744AbYESWKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:10:18 -0400
Date: Tue, 20 May 2008 01:08:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] Alpha Miata: remove dead URL
Message-ID: <20080519220813.GR17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a dead URL.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
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

