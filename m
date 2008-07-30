Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbYG3SWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbYG3SWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYG3SWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:22:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYG3SWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:22:41 -0400
Message-Id: <20080730182053.872043059@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jul 2008 14:20:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2]  RCU preempt updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches have been sitting in the RT tree for some time.
They have been waiting for both RCU preempt and RCU preempt tracing
to get into mainline.

Since those are now in mainline, it is time to send in these patches.

-- Steve

