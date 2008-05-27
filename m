Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYE0QJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYE0QJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbYE0QJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:09:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:48103 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbYE0QJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=eFWsrMOSqORYanGButIB8oNB4hVcnq1APRwRa2Wp/gviG9u1IiKR/yPyUni6SP21hkqAjgEOvl/QabMTI3yL2Os9T0bj89OXtfeHLF0RZnfMLEk9HLSKjWAxSlDVnAcqx6G5tcdNiHg9psK6oYBlrHeXLp+IyGYWPiSFOoF+R/A=
Date: Tue, 27 May 2008 18:08:57 +0200
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mips: fix typo in header guard
Message-ID: <20080527160857.GB7550@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 17:27:28 +0200
Subject: [PATCH] mips: fix typo in header guard

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-mips/rtlx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-mips/rtlx.h b/include/asm-mips/rtlx.h
index 20b6660..4ca3063 100644
--- a/include/asm-mips/rtlx.h
+++ b/include/asm-mips/rtlx.h
@@ -3,7 +3,7 @@
  *
  */
 
-#ifndef __ASM_RTLX_H
+#ifndef __ASM_RTLX_H_
 #define __ASM_RTLX_H_
 
 #include <irq.h>
-- 
1.5.4.1

