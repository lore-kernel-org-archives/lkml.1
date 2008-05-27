Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYE0QIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYE0QIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbYE0QH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:07:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:46910 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbYE0QH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=dbcnSco+NF5pVcEbDAwDU6Ly9N21tMVExTxUE9Gzef85akPouJpVqM6MnLXvvJSfZP0bfrm9JaHAAF18aSZqRBCtD9o9fsa2oO/SG/a+lE54pYKgWkSlLNq5B9vQ1Bcul1C2AZDBU6YuODBdlIsZnqckaxqjya4zMQrc1fnEc2U=
Date: Tue, 27 May 2008 18:07:50 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] h8300: fix typo in header guard
Message-ID: <20080527160750.GA7550@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I'm not sure who exactly to mail this as I couldn't find a MAINTAINERS
entry for the arch. I hope this is OK too.

Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 17:25:42 +0200
Subject: [PATCH] h8300: fix typo in header guard

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-h8300/cacheflush.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-h8300/cacheflush.h b/include/asm-h8300/cacheflush.h
index 71210d1..5ffdca2 100644
--- a/include/asm-h8300/cacheflush.h
+++ b/include/asm-h8300/cacheflush.h
@@ -3,7 +3,7 @@
  */
 
 #ifndef _ASM_H8300_CACHEFLUSH_H
-#define _AMS_H8300_CACHEFLUSH_H
+#define _ASM_H8300_CACHEFLUSH_H
 
 /*
  * Cache handling functions
-- 
1.5.4.1

