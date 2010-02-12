Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0BLABU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:01:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47925 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526Ab0BLABJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:01:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/13] rcu: fix citation of Mathieu's dissertation
Date: Thu, 11 Feb 2010 16:00:38 -0800
Message-Id: <1265932839-25899-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100212000016.GA25781@linux.vnet.ibm.com>
References: <20100212000016.GA25781@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
-- 
1.6.6

