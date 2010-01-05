Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973Ab0AEADp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0AEADp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481Ab0AEADm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:03:42 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39569 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0AEADl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:03:41 -0500
Date: Mon, 4 Jan 2010 16:03:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] rcu: improve diagnostics and
	documentation of source files
Message-ID: <20100105000337.GA23307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch set corrects the file specifiers for the RCU sources in the
MAINTAINERS file and also makes a couple of minor improvements to RCU's
diagnostics.

							Thanx, Paul


 MAINTAINERS             |   14 +++++++-------
 kernel/rcutree.c        |   10 ++++++++--
 kernel/rcutree_plugin.h |    4 +++-
 3 files changed, 18 insertions(+), 10 deletions(-)
