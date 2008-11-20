Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYKTLe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYKTLe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYKTLbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:31:34 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47410 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755489AbYKTLbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:31:33 -0500
Subject: [PATCH 2.6.28-rc5 11/11] kmemleak: Add the corresponding MAINTAINERS
	entry
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 20 Nov 2008 11:31:30 +0000
Message-ID: <20081120113130.16607.40876.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 11:31:30.0461 (UTC) FILETIME=[888BACD0:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 627e4c8..93400a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2502,6 +2502,12 @@ L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
+KERNEL MEMORY LEAK DETECTOR
+P:	Catalin Marinas
+M:	catalin.marinas@arm.com
+W:	http://www.procode.org/kmemleak/
+S:	Maintained
+
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
 M:	bfields@fieldses.org

