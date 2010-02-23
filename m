Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab0BWBHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:07:54 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43216 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab0BWBFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:17 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/21] rcu: fix citation of Mathieu's dissertation
Date: Mon, 22 Feb 2010 17:04:58 -0800
Message-Id: <1266887105-1528-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
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

