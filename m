Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYC3WmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYC3WmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYC3Wko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:40:44 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57860 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbYC3Wkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:40:43 -0400
Date: Mon, 31 Mar 2008 01:40:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jdike@addtoit.com
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove include/asm-um/keyboard.h
Message-ID: <20080330224031.GG28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused and broken (the normal asm/keyboard.h 
files no longer exists) include/asm-um/keyboard.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-um/keyboard.h |    6 ------
 1 file changed, 6 deletions(-)

bd6cdb1ee8faecc525ce49b25115f2ca21be8981 diff --git a/include/asm-um/keyboard.h b/include/asm-um/keyboard.h
deleted file mode 100644
index ee2e230..0000000
--- a/include/asm-um/keyboard.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_KEYBOARD_H
-#define __UM_KEYBOARD_H
-
-#include "asm/arch/keyboard.h"
-
-#endif

