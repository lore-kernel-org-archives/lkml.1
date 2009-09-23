Return-Path: <linux-kernel-owner+w=401wt.eu-S1752132AbZIWVjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbZIWVjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZIWVjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:39:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36401 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZIWVjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:39:35 -0400
Date: Wed, 23 Sep 2009 17:39:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Raistlin <raistlin@linux.it>
cc: Daniel Walker <dwalker@fifo99.com>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
In-Reply-To: <1253628061.20345.173.camel@Palantir>
Message-ID: <alpine.DEB.2.00.0909231737001.811@gandalf.stny.rr.com>
References: <1253615424.20345.76.camel@Palantir>  <1253625878.6575.34.camel@desktop> <1253628061.20345.173.camel@Palantir>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 22 Sep 2009, Raistlin wrote:

> I see. Problem is that last time I sent a patch, I inlined it and it
> worked without any issue... It seems something has changed either in me
> or my MUA... Too bad. :-(
> 
> > I realize
> > this is an RFC , so the next time you submit this try to make it utf8 ..
> > 
> You're definitely right and, now that you pointed this out to me, I'm
> not able to produce a clean version, even if I set utf8 encoding...
> 
> So, I'm sorry, but, for now, the only thing I can do is attaching the
> patch, hoping it works. The next one will be stop using Evolution! :-/
> 

Hmm, I use evolution with no issues with patches. I just set it to 
Preformatted (from Normal), and then hit "Insert->Text File ..." and it 
inlines quite nicely.

/me says this while sending via pine ;-)

-- Steve

