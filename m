Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZCZPuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZCZPuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbZCZPuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:50:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57811 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbZCZPuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:50:04 -0400
Message-Id: <20090326154918.330439698@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Mar 2009 11:49:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] updates for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (2):
      tracing: increase size of number of possible events
      tracing: add size checks for exported ftrace internal structures

----
 kernel/trace/trace.h        |    5 ++++-
 kernel/trace/trace_events.c |    5 ++++-
 kernel/trace/trace_export.c |    4 ++++
 kernel/trace/trace_output.c |    2 ++
 4 files changed, 14 insertions(+), 2 deletions(-)
-- 
