Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZIPUQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZIPUQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbZIPUQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:16:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZIPUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:16:28 -0400
Subject: mailing list for trace users
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 16 Sep 2009 16:16:22 -0400
Message-Id: <1253132182.20020.242.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What are people's thoughts about creating a linux-trace-users mailing
list on vger.kernel.org?

This would be a place for users of tracers and even perf. For asking
questions about how to use the debugfs/tracing directory or the perf
tool.

This will not be a place for kernel development. Patches for the tracing
infrastructure should still go through LKML. This will be a place to ask
how-to questions, or any other kind of help questions.

LKML can be quite intimidating, and it is not a place to ask help
questions anyway. I think adding a linux-trace-users mailing list would
be a good idea.

Thoughts?

-- Steve


