Return-Path: <linux-kernel-owner+w=401wt.eu-S966927AbXHMGbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966927AbXHMGbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965708AbXHMGWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3504 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965523AbXHMGWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:39 -0400
Date: Sun, 12 Aug 2007 23:22:24 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, fizban@tin.it,
       akpm@linux-foundation.org
Subject: [PATCH] [32/2many] MAINTAINERS - AEDSP16 DRIVER
Message-ID: <46bff8a0.TQYAEoSsaucAE3zL%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1db3c5d..b84e0e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -326,6 +326,7 @@ AEDSP16 DRIVER
 P:	Riccardo Facchetti
 M:	fizban@tin.it
 S:	Maintained
+F:	sound/oss/aedsp16.c
 
 AFFS FILE SYSTEM
 P:	Roman Zippel
