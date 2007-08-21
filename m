Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbXHUQ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbXHUQ7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 12:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761944AbXHUQ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 12:58:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40598 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761905AbXHUQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 12:58:50 -0400
Date: Tue, 21 Aug 2007 18:57:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [2.6 patch] ppc .gitignore update
Message-ID: <20070821165758.GB30705@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

arch/ppc/.gitignore shouldn't exclude arch/ppc/boot/include

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- a/arch/ppc/.gitignore
+++ b/arch/ppc/.gitignore
@@ -1 +1 @@
-include
+/include

