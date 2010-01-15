Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580Ab0AOALF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0AOALF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266Ab0AOALE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:11:04 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39159 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab0AOALE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:11:04 -0500
Date: Thu, 14 Jan 2010 16:10:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/2] Update RCU documentation and fix sparse
	warnings
Message-ID: <20100115001021.GA25878@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following two patches update the RCU documentation based on last
year's changes to RCU, and also fix a few sparse warnings.  These are
good to go.

							Thanx, Paul
