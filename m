Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZCQLHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZCQLHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZCQLH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:07:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:37211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZCQLH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:07:26 -0400
Date: Tue, 17 Mar 2009 11:06:25 GMT
From: Luis Henriques <henrix@sapo.pt>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       henrix@sapo.pt, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       henrix@sapo.pt, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090316195809.GA6073@hades.domain.com>
References: <20090316195809.GA6073@hades.domain.com>
Subject: [tip:sched/cleanups] sched: fix typos in documentation
Message-ID: <tip-80dd99b368cf6501be88ab517bbbb5bf352b75b8@git.kernel.org>
Git-Commit-ID: 80dd99b368cf6501be88ab517bbbb5bf352b75b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 17 Mar 2009 11:06:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80dd99b368cf6501be88ab517bbbb5bf352b75b8
Gitweb:     http://git.kernel.org/tip/80dd99b368cf6501be88ab517bbbb5bf352b75b8
Author:     Luis Henriques <henrix@sapo.pt>
AuthorDate: Mon, 16 Mar 2009 19:58:09 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Mar 2009 12:04:40 +0100

sched: fix typos in documentation

Fixed typos in function documentation.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
LKML-Reference: <20090316195809.GA6073@hades.domain.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2f28351..489e7d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2082,7 +2082,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * it must be off the runqueue _entirely_, and not
 		 * preempted!
 		 *
-		 * So if it wa still runnable (but just not actively
+		 * So if it was still runnable (but just not actively
 		 * running right now), it's preempted, and we should
 		 * yield - it could be a while.
 		 */
@@ -2574,7 +2574,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 /**
- * preempt_notifier_register - tell me when current is being being preempted & rescheduled
+ * preempt_notifier_register - tell me when current is being preempted & rescheduled
  * @notifier: notifier struct to register
  */
 void preempt_notifier_register(struct preempt_notifier *notifier)
