Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYGVMcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYGVMcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYGVMby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:31:54 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:47575 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYGVMby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:31:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroEAJdwhUhMRKxB/2dsb2JhbACBWq5Q
Date: Tue, 22 Jul 2008 08:31:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull tip/tracing/ftrace] Port ftrace to tracepoints
Message-ID: <20080722123134.GC25398@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:26:38 up 47 days, 17:07,  5 users,  load average: 1.29, 1.05,
	0.76
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Could you try to pull
git://ltt.polymtl.ca/linux-2.6-instrumentation.git tracing/ftrace-tracepoints-pull

into

tip/tracing/ftrace

?

It adds the commits which add the tracepoint infrastructure and
port ftrace to it, which are :

rcu-read-sched.patch
tracepoints.patch
tracepoints-documentation.patch
tracepoints-samples.patch
lttng-instrumentation-scheduler.patch
ftrace-port-to-tracepoints.patch


Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
