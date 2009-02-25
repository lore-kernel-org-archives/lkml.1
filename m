Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbZBYWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbZBYWN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbZBYWNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:13:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790AbZBYWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:13:47 -0500
Message-Id: <20090225221304.097297742@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 17:13:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 0/2] [git pull] for tip/tracing/ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (2):
      tracing: rename DEFINE_TRACE_FMT to just TRACE_FORMAT
      tracing: wrap arguments with PARAMS

----
 include/linux/tracepoint.h        |    5 +++--
 include/trace/sched_event_types.h |   26 +++++++++++++-------------
 kernel/trace/trace_events.h       |    4 ++--
 3 files changed, 18 insertions(+), 17 deletions(-)

-- 
