Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZBVMJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZBVMJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZBVMJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:09:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbZBVMJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:09:26 -0500
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
References: <499edf47.1818d00a.060b.2b8d@mx.google.com>
	<499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu>
	<1235302980.4632.8.camel@laptop>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sun, 22 Feb 2009 07:08:55 -0500
In-Reply-To: <1235302980.4632.8.camel@laptop> (Peter Zijlstra's message of "Sun, 22 Feb 2009 12:43:00 +0100")
Message-ID: <y0mocwuptbc.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> I would like to never merge an ftrace_printk() user... just as I'd like
> to get rid of every marker.

But why?  They solve a problem well enough that Ingo had in effect
reinvented them on Friday.

- FChE
