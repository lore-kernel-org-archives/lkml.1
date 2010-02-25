Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab0BYKOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:14:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:40944 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759000Ab0BYKOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:14:06 -0500
Date: Thu, 25 Feb 2010 10:13:13 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-14-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-14-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Fix citation of Mathieu's dissertation
Message-ID: <tip-998f2ac3fea93bfa8b55c279fff68f7c5b9ab93d@git.kernel.org>
Git-Commit-ID: 998f2ac3fea93bfa8b55c279fff68f7c5b9ab93d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:13:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  998f2ac3fea93bfa8b55c279fff68f7c5b9ab93d
Gitweb:     http://git.kernel.org/tip/998f2ac3fea93bfa8b55c279fff68f7c5b9ab93d
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:58 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:54 +0100

rcu: Fix citation of Mathieu's dissertation

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-14-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/RCU/RTFP.txt |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 5051209..96b7c00 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -864,9 +864,12 @@ Revised:
 }
 
 @phdthesis{MathieuDesnoyersPhD
-, title  = "Low-impact Operating System Tracing"
+, title  = "Low-Impact Operating System Tracing"
 , author = "Mathieu Desnoyers"
 , school = "Ecole Polytechnique de Montr\'{e}al"
 , month  = "December"
 , year   = 2009
+,note="Available:
+\url{http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12-v24.pdf}
+[Viewed December 9, 2009]"
 }
