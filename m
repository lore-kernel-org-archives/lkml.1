Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbYJZKgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbYJZKgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYJZKf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:35:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:48562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbYJZKf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:35:58 -0400
Subject: Re: [PATCH v2][RFC] ftrace: function oprofiler
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0810252049020.7650@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0810252049020.7650@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 26 Oct 2008 11:35:57 +0100
Message-Id: <1225017357.27415.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 20:55 -0400, Steven Rostedt wrote:

> This is a function profiler to count the number of times a function is hit.

I have to ask, _why_?

It seems like a nice enough gimmick, but is this information actually
useful?
