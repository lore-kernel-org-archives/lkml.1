Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZIGD4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZIGD4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbZIGD4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:56:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:54831 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809AbZIGD4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:56:13 -0400
MIME-Version: 1.0
In-Reply-To: <20090906205952.GA6516@elte.hu>
References: <20090906205952.GA6516@elte.hu>
Date: Mon, 7 Sep 2009 13:50:16 +1000
X-Google-Sender-Auth: eff67ef9f92dae4a
Message-ID: <7574305f0909062050k4b0d4dd2pf9e71724caf8a189@mail.gmail.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/7 Ingo Molnar <mingo@elte.hu>:
> hi Con,

Sigh..

Well hello there.

>
> I've read your BFS announcement/FAQ with great interest:
>
>    http://ck.kolivas.org/patches/bfs/bfs-faq.txt

> I understand that BFS is still early code and that you are not
> targeting BFS for mainline inclusion - but BFS is an interesting
> and bold new approach, cutting a _lot_ of code out of
> kernel/sched*.c, so it raised my curiosity and interest :-)

Hard to keep a project under wraps and get an audience at the same
time, it is. I do realise it was inevitable LKML would invade my
personal space no matter how much I didn't want it to, but it would be
rude of me to not respond.

> In the announcement and on your webpage you have compared BFS to
> the mainline scheduler in various workloads - showing various
> improvements over it. I have tried and tested BFS and ran a set of
> benchmarks - this mail contains the results and my (quick)
> findings.

/me sees Ingo run off to find the right combination of hardware and
benchmark to prove his point.

[snip lots of bullshit meaningless benchmarks showing how great cfs is
and/or how bad bfs is, along with telling people they should use these
artificial benchmarks to determine how good it is, demonstrating yet
again why benchmarks fail the desktop]

I'm not interested in a long protracted discussion about this since
I'm too busy to live linux the way full time developers do, so I'll
keep it short, and perhaps you'll understand my intent better if the
FAQ wasn't clear enough.


Do you know what a normal desktop PC looks like? No, a more realistic
question based on what you chose to benchmark to prove your point
would be: Do you know what normal people actually do on them?


Feel free to treat the question as rhetorical.

Regards,
-ck

/me checks on his distributed computing client's progress, fires up
his next H264 encode, changes music tracks and prepares to have his
arse whooped on quakelive.
