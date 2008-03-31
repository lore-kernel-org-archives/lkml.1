Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYCaJKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYCaJKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYCaJIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:13 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54062 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbYCaJIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:09 -0400
Date: Mon, 31 Mar 2008 12:07:54 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] ide/h8300/ide-h8300.c: add MODULE_LICENSE
Message-ID: <20080331090754.GK28445@cs181133002.pp.htv.fi>
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
a10fd089f8f9ddf35319c85e1e124934d3e456f8 diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 520aec0..3c8005b 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -125,3 +125,5 @@ out_busy:
 }
 
 module_init(h8300_ide_init);
+
+MODULE_LICENSE("GPL");

