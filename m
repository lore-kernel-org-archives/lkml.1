Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZHXLBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZHXLBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZHXLBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:01:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43026 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZHXLBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:01:38 -0400
Date: Mon, 24 Aug 2009 13:01:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824110123.GA6162@elte.hu>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org> <20090824084101.GE2424@elte.hu> <20090824085944.GA15330@linux-sh.org> <20090824095652.GC25267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824095652.GC25267@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ( Also, could you please fix your mailer so that it does not damage 
>   threads? It generates such bogus headers:
> 
>     Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
>         Ingo Molnar <mingo@elte.hu>,
>         Frederic Weisbecker <fweisbec@gmail.com>,
>         Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
>         Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
>        	Steven Rostedt <rostedt@goodmis.org>,
>         Peter Zijlstra <peterz@infradead.org>,
>         Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
>         Jiaying Zhang <jiayingz@google.com>,
>         Martin Bligh <mbligh@google.com>,
>         Lai Jiangshan <laijs@cn.fujitsu.com>
> 
>   which messes up replies. )

Paul, you forgot to reply to this bit. Mail-Followup-To is quite a 
PITA on lkml.

	Ingo
