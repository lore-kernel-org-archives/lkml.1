Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZETHCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZETHCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZETHC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:02:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZETHC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:02:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Fcc: ~/Mail/linus
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, jiayingz@google.com,
       mbligh@google.com, "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
In-Reply-To: Mathieu Desnoyers's message of  Tuesday, 19 May 2009 20:33:14 -0400 <20090520003314.GA8790@Krystal>
References: <cover.1242763826.git.jbaron@redhat.com>
	<20090519211704.GA3325@Krystal>
	<alpine.DEB.2.00.0905191826031.7816@gandalf.stny.rr.com>
	<20090520003314.GA8790@Krystal>
X-Windows: power tools for power losers.
Message-Id: <20090520070140.96F24FC38D@magilla.sf.frob.com>
Date: Wed, 20 May 2009 00:01:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I concur about a shorter/prettier macro name.  Perhaps TRACE is better,
since I'm fairly sure 'trace' will have been used many times as a local
variable name and the like.


Thanks,
Roland
