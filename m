Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYIPUHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYIPUHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYIPUHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:07:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYIPUHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:07:03 -0400
Date: Tue, 16 Sep 2008 16:06:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 3/7] ftrace: add trace_vprintk()
In-Reply-To: <20080916215824.7b0b69e5@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0809161606340.7650@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com> <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com> <20080827212130.4b8365a8@daedalus.pq.iki.fi> <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com> <20080828214256.296e34ec@daedalus.pq.iki.fi>
 <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com> <20080904203058.7e57729e@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com> <20080915224707.76b2cca0@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
 <20080916215416.16aee2dd@daedalus.pq.iki.fi> <20080916215824.7b0b69e5@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Sep 2008, Pekka Paalanen wrote:

> From 5579d3e6471201524697d1cc32fb37f1a4f70f95 Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Sun, 14 Sep 2008 17:27:05 +0300
> Subject: [PATCH] ftrace: add trace_vprintk()
> 
> trace_vprintk() for easier implementation of tracer specific *_printk
> functions. Add check check for no_tracer, and implement
> __ftrace_printk() as a wrapper.
> 
> Signed-off-by: Pekka Paalanen <pq@iki.fi>

Nice!

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

