Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbYE0QNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbYE0QNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbYE0QMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:12:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51804 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246AbYE0QMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=LqcQolLMgOVCLGdx0rdAqreUFQVOmJVamSW9INhZXDE9qwt5KioM5Xt+bYQyvqbxnXb3pjRBPrtqGehdyUF5OtgWVzZ4LqDQIV4u8WFNbNYBbp0KYCJFl6fwKY59E+7pvakm4qwpIEAPNr8dZ8LlYvxQSkCARPslz8Gdm1Cu63s=
Date: Tue, 27 May 2008 18:12:46 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] v850: fix typo in header guard
Message-ID: <20080527161246.GF7550@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 17:32:42 +0200
Subject: [PATCH] v850: fix typo in header guard

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-v850/clinkage.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-v850/clinkage.h b/include/asm-v850/clinkage.h
index 2b622ad..c389691 100644
--- a/include/asm-v850/clinkage.h
+++ b/include/asm-v850/clinkage.h
@@ -11,7 +11,7 @@
  * Written by Miles Bader <miles@gnu.org>
  */
 
-#ifndef __CLINKAGE_H__
+#ifndef __V850_CLINKAGE_H__
 #define __V850_CLINKAGE_H__
 
 #include <asm/macrology.h>
-- 
1.5.4.1

