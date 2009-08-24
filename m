Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZHXInH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZHXInH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZHXInE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:43:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZHXInD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:43:03 -0400
Date: Mon, 24 Aug 2009 10:42:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 1/4] tracing: Rename TIF_SYSCALL_FTRACE->_TRACEPOINT
Message-ID: <20090824084245.GF2424@elte.hu>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <20090823211625.GH6256@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090823211625.GH6256@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Aug 21, 2009 at 09:58:42PM -0700, Josh Stone wrote:
>
> > This thread flag is no longer specific to just ftrace, so 
> > TIF_SYSCALL_TRACEPOINT may be a more apt name.
> 
> Adding Paul Mundt <lethal@linux-sh.org> in Cc, the sh tree also 
> has the syscalls tracing support (in a seperate branch).

Btw., is there an URI for that separate branch?

	Ingo
