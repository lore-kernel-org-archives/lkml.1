Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYAIErR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYAIErR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYAIErG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:47:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbYAIErF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:47:05 -0500
Date: Tue, 8 Jan 2008 20:45:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mingo@elte.hu, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Message-Id: <20080108204530.2b82c91b.akpm@linux-foundation.org>
In-Reply-To: <200801091528.00402.rusty@rustcorp.com.au>
References: <20080108063113.GA21287@fattire.cabal.ca>
	<200801091420.19273.rusty@rustcorp.com.au>
	<20080108193350.ffc94e44.akpm@linux-foundation.org>
	<200801091528.00402.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 15:27:59 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:

> > >  I assume you've
> > > queued these because you're thinking of applying them before 2.6.24?  I'd
> > > say only
> > > modules-de-mutex-more-symbol-lookup-paths-in-the-module-code.patch
> > > warrants that (the other is unlikely and not a regression).
> >
> > Actually I was thinking 2.6.25 on both.
> 
> Then, you should get them next time you grab my series, no?  Or is that 
> particular lever not working yet?
> 
> Hmm, I see my link was not updated (damn, ln -sfn, not ln -sf!).  Fixed now:
> 	http://ozlabs.org/~rusty/kernel/rr-latest/
> 
> More goodies there than a UK comedy convention...

My 850-email backlog is down to 759.  You're in there somewhere.  I'm
wondering if I can spin it out to next Christmas.  

I may end up throwing up my hands, trolling it all for bugfixes and then
having an accident with the rest.

