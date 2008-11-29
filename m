Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbYK2Ksh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbYK2Ksh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbYK2Koi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:44:38 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41436 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbYK2Koh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:44:37 -0500
Subject: [PATCH 15/15] kmemleak: Add the corresponding MAINTAINERS entry
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Sat, 29 Nov 2008 10:44:30 +0000
Message-ID: <20081129104430.16726.53600.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.288.gdd3f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2008 10:44:30.0437 (UTC) FILETIME=[7565E950:01C9520F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 627e4c8..06c2a3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2502,6 +2502,12 @@ L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
+KERNEL MEMORY LEAK DETECTOR
+P:	Catalin Marinas
+M:	catalin.marinas@arm.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
 M:	bfields@fieldses.org

