Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbZFRSJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbZFRSJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZFRSIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:08:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1521 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbZFRSII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:08:08 -0400
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/5] MAINTAINERS: kmemtrace pattern update
Date: Thu, 18 Jun 2009 11:08:05 -0700
Message-Id: <d9a9c82a20e0b5129dce854eb670f7dd73ee98aa.1245345515.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245345515.git.joe@perches.com>
References: <cover.1245345515.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2375de3..4cf7ba2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3407,7 +3407,7 @@ P:	Eduard - Gabriel Munteanu
 M:	eduard.munteanu@linux360.ro
 S:	Maintained
 F:	Documentation/trace/kmemtrace.txt
-F:	include/trace/kmemtrace.h
+F:	include/linux/kmemtrace.h
 F:	kernel/trace/kmemtrace.c
 
 KPROBES
-- 
1.6.3.1.10.g659a0.dirty

