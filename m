Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZBJOJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZBJOJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZBJOIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:08:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZBJOIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:08:53 -0500
Date: Tue, 10 Feb 2009 09:08:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/3] git pull request for tip/tracing/ftrace
In-Reply-To: <20090210130050.GA8341@elte.hu>
Message-ID: <alpine.DEB.1.10.0902100907450.23505@gandalf.stny.rr.com>
References: <20090209172830.087244662@goodmis.org> <20090210130050.GA8341@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 10 Feb 2009, Ingo Molnar wrote:
> 
> A small request regarding the commit logs, could you please
> in the future make the titles more consistent:
> 
>  34cd499: tracing: clean up splice code
>  ff98781: tracing: Move pipe waiting code out of tracing_read_pipe().
>  3c56819: tracing: splice support for tracing_pipe
> 
> the closing period in the second commit is unnecessary, and
> capitalization should be consistent as well.

Ah sorry, my fault. I even updated his subject to s/trace/tracing/. I 
missed the period and the Capital :-/

-- Steve

