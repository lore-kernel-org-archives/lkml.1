Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbYKIOOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbYKIOOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 09:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYKIOOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 09:14:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58886 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbYKIOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 09:14:18 -0500
Date: Sun, 9 Nov 2008 09:14:15 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com
Subject: Re: Tracing framework regression in 2.6.28-rc3
In-Reply-To: <20081109121349.4b0531be@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0811090913340.29560@gandalf.stny.rr.com>
References: <20081102183534.1bdc6779@daedalus.pq.iki.fi> <20081109121349.4b0531be@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 9 Nov 2008, Pekka Paalanen wrote:
> > 
> > Steven, can you reproduce these?
> > I'm on x86_64.
> 
> With 2.6.28-rc3, the bug is on the exact same line.
> Steps to reproduce:
> cd /debug/tracing
> echo 0 > tracing_enabled
> echo 200 > trace_entries

Thanks Pekka, I'll take a look at this on Monday.

-- Steve
