Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYLJScy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYLJScy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYLJS2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:28:20 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33269 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404AbYLJS2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:28:19 -0500
Subject: [PATCH 15/15] kmemleak: Add the corresponding MAINTAINERS entry
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 10 Dec 2008 18:28:17 +0000
Message-ID: <20081210182817.30323.46388.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:28:17.0667 (UTC) FILETIME=[12437D30:01C95AF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 24741de..44ee125 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2503,6 +2503,12 @@ L:	kernel-janitors@vger.kernel.org
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

