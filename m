Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbZDXQqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbZDXQqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZDXQnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:43:04 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41739 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760245AbZDXQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:43:03 -0400
Subject: [PATCH 14/14] kmemleak: Add the corresponding MAINTAINERS entry
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Apr 2009 17:42:16 +0100
Message-ID: <20090424164216.4476.43562.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:43:01.0219 (UTC) FILETIME=[BB224330:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6baace3..2401fc2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3344,6 +3344,12 @@ F:	Documentation/vm/kmemtrace.txt
 F:	include/trace/kmemtrace.h
 F:	kernel/trace/kmemtrace.c
 
+KMEMLEAK
+P:	Catalin Marinas
+M:	catalin.marinas@arm.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com

