Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZGEUMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZGEUMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 16:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbZGEUMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 16:12:46 -0400
Received: from www.tglx.de ([62.245.132.106]:34328 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbZGEUMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 16:12:45 -0400
Date: Sun, 5 Jul 2009 22:11:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86: Clean up mtrr/cleanup.c
In-Reply-To: <1246799995.2442.7.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0907052134530.2771@localhost.localdomain>
References: <20090703164225.GA21447@elte.hu>  <tip-63f9600fadb10ea739108ae93e3e842d9843c58b@git.kernel.org>  <4A4FC5D0.6090000@kernel.org> <20090705002709.GA28424@elte.hu>  <1246773777.2325.113.camel@jaswinder.satnam>  <84144f020907050459x6a9a11fmf8f3050f085c8d85@mail.gmail.com>
 <1246799995.2442.7.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder,

On Sun, 5 Jul 2009, Jaswinder Singh Rajput wrote:
> On Sun, 2009-07-05 at 14:59 +0300, Pekka Enberg wrote:
> > What's with the attitude? It's perfectly okay for a commiter to change
> > the patch as long as it's mentioned in the changelog. And that's
> > usually much faster to do that for minor issues rather than ping the
> > original submitter and wait for a resend.
> > 
> 
> I was also thankful to him but then he send me a long email and blamed
> me that I wasted his 6 hours to do further cleanup and solve bugs and
> other irrelevant things.

Err, you managed to create _three_ bugs in your trivial cleanup
patches and that's not irrelevant at all. That's a sign of sloppiness
and a pretty good reason not to trust any of your patches at all.

> And told me to not send further patches otherwise he will ignore it.

Right, and he is correct about that. This is not the first time and
you have been asked to be more careful with your patches several times
in the last months. It's _you_ who is not listening and not caring at
all.

> He is doing mistakes and blaming others and misusing maintainer-ship.

Ingo did clean up _your_ mess and there was no mistake at all. He
blames _you_ correctly that _your_ trivial patches are buggy.

There is no misuse at all. Ingo is doing what a responsible maintainer
does: reviewing patches and fixing them up when necessary. 

His decision not to take any more cleanup patches from you is just the
result of your unwillingness to listen and to react on the requests
which were made to you from Ingo, myself and others.

Thanks,

	tglx
