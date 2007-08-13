Return-Path: <linux-kernel-owner+w=401wt.eu-S942795AbXHMHrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942795AbXHMHrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966395AbXHMG0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4219 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966126AbXHMG0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:48 -0400
Date: Sun, 12 Aug 2007 23:25:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
       davem@davemloft.net, akpm@linux-foundation.org
Subject: [PATCH] [139/2many] MAINTAINERS - CRYPTO API
Message-ID: <46bff96a.HHCwZ6i46IaoRLWU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 794fe99..bc2e348 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1352,6 +1352,7 @@ M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
+F:	crypto/
 
 CS5535 Audio ALSA driver
 P:	Jaya Kumar
