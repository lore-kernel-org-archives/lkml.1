Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYJ3H1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYJ3H1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYJ3H0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:26:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61694 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbYJ3H0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:26:32 -0400
Message-ID: <490960FB.6020904@cn.fujitsu.com>
Date: Thu, 30 Oct 2008 15:23:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: remove sched-design.txt from 00-INDEX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched-design.txt has been removed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/scheduler/00-INDEX |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/scheduler/00-INDEX b/Documentation/scheduler/00-INDEX
index fc234d0..aabcc3a 100644
--- a/Documentation/scheduler/00-INDEX
+++ b/Documentation/scheduler/00-INDEX
@@ -4,8 +4,6 @@ sched-arch.txt
 	- CPU Scheduler implementation hints for architecture specific code.
 sched-coding.txt
 	- reference for various scheduler-related methods in the O(1) scheduler.
-sched-design.txt
-	- goals, design and implementation of the Linux O(1) scheduler.
 sched-design-CFS.txt
 	- goals, design and implementation of the Complete Fair Scheduler.
 sched-domains.txt
-- 
1.5.4.rc3

