Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbXHANb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbXHANb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762108AbXHANbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:31:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56648 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762167AbXHANbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:31:17 -0400
Date: Wed, 1 Aug 2007 15:30:56 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Rutger Nijlunsing <rutger@nospam.com>, Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ppc .gitignore update
Message-ID: <20070801133056.GP3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch/ppc/.gitignore shouldn't exclude arch/ppc/boot/include

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- /dev/null	2006-09-19 00:45:31.000000000 +0200
+++ linux-2.6.23-rc1-mm2/arch/ppc/boot/.gitignore	2007-08-01 15:18:33.000000000 +0200
@@ -0,0 +1 @@
+!include

