Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYICVsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYICVsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYICVr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:47:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYICVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:47:56 -0400
Message-Id: <20080903214249.661170580@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 17:42:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] ftrace: ftrace_printk fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter Zijlstra is starting to use ftrace_printk to debug the scheduler.
He quickly came across a few issues.

These two patches address some of the things he has concerns about.

I'm expecting that Peter will be sending some more patches to help with
the interface.

-- Steve

