Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbXGKTTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbXGKTTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761209AbXGKTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760172AbXGKTTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:10 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 01/33] x86 setup: MAINTAINERS: formally take responsibility for the i386 boot code
Date: Wed, 11 Jul 2007 12:18:26 -0700
Message-Id: <118418153862-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184181538674-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
Message-Id: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Change MAINTAINERS to formally take responsibility for the i386 boot code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index df40a4e..7f92ce2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1750,8 +1750,8 @@ T:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
 
 i386 BOOT CODE
-P:	Riley H. Williams
-M:	Riley@Williams.Name
+P:	H. Peter Anvin
+M:	hpa@zytor.com
 L:	Linux-Kernel@vger.kernel.org
 S:	Maintained
 
-- 
1.5.2.2

