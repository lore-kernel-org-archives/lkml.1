Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYCFG7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYCFG7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYCFG7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:59:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339AbYCFG7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:59:13 -0500
Date: Thu, 06 Mar 2008 15:58:52 +0900 (JST)
Message-Id: <20080306.155852.266167763.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH][TRIVIAL] Typo in Documentation/scheduler/sched-stats.txt
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
X-Mailer: Mew version 5.2.52 on Emacs 22.0.51 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have found a very small typo in Documentation/scheduler/sched-stats.txt.
See the end of this mail.

BTW, a broken link is found in Documentation/SubmittingPatches.

    For small patches you may want to CC the Trivial Patch Monkey
    trivial@kernel.org managed by Adrian Bunk; which collects "trivial"
    patches. Trivial patches must qualify for one of the following rules:
     Spelling fixes in documentation
    ...
    URL: <http://www.kernel.org/pub/linux/kernel/people/bunk/trivial/>

The page for the URL doesn't exist.


Signed-off-by: Masatake YAMATO <yamato@redhat.com>

--- linux/Documentation/scheduler/sched-stats.txt	2008-02-08 04:33:34.000000000 +0900
+++ linux/Documentation/scheduler/sched-stats.txt.new	2008-03-06 15:41:51.000000000 +0900
@@ -142,7 +142,7 @@
 
 /proc/<pid>/schedstat
 ----------------
-schedstats also adds a new /proc/<pid/schedstat file to include some of
+schedstats also adds a new /proc/<pid>/schedstat file to include some of
 the same information on a per-process level.  There are three fields in
 this file correlating for that process to:
      1) time spent on the cpu

