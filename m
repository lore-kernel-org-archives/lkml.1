Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYCaJKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYCaJKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYCaJIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:14 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51821 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097AbYCaJIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:11 -0400
Date: Mon, 31 Mar 2008 12:07:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] ide/legacy/gayle.c: add MODULE_LICENSE
Message-ID: <20080331090757.GL28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that it can be built modular it needs a MODULE_LICENSE.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4bd68e53bc0477dd694b87acacc27bac412b9bf4 diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index b7d8109..e3b4638 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -195,3 +195,5 @@ found:
 }
 
 module_init(gayle_init);
+
+MODULE_LICENSE("GPL");

