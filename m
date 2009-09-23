Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZIWPI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZIWPI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZIWPI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:08:59 -0400
Received: from fifo99.com ([67.223.236.141]:36691 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZIWPI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:08:58 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Daniel Walker <dwalker@fifo99.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       claudio@evidence.eu.com, michael@evidence.eu.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <4ABA37A5.4000806@redhat.com>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop> <20090922173916.257dff1d@tpl.lwn.net>
	 <1253663739.4317.12.camel@desktop> <20090922180611.7a47adcc@tpl.lwn.net>
	 <1253666423.25689.30.camel@desktop> <4ABA0AA6.3010408@redhat.com>
	 <20090923122530.GB6390@elte.hu> <1253717459.20648.39.camel@desktop>
	 <4ABA37A5.4000806@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 08:08:52 -0700
Message-Id: <1253718532.20648.46.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 17:58 +0300, Avi Kivity wrote:
> On 09/23/2009 05:50 PM, Daniel Walker wrote:
> > On Wed, 2009-09-23 at 14:25 +0200, Ingo Molnar wrote:
> >    
> >> * Avi Kivity<avi@redhat.com>  wrote:
> >>
> >>      
> >>>> discouraging contributions is more something that happens when you
> >>>> get the responses I got earlier in this thread..
> >>>>          
> >>> That's probably intentional.  Whitespace fixes have their place but
> >>> not at this stage in a patch's lifecycle.
> >>>        
> >> Exactly. What might make sense is to scan linux-next for new commits
> >> that show serious cleanliness trouble - and send fix patches to the
> >> parties involved. That's a real effort and brings the code forward.
> >>      
> > Often times when a patch is at youngest that when you want to catch
> > these issues .. This EDF patch will likely get submitted more than
> > twice. If you catch all the minor problems first you will not be dealing
> > with them later when it comes time to include the code.
> >    
> 
> Not true, you want to address the major issues first.  What's the point 
> of fixing whitespace if the whole approach is rejected? if it has to 
> undergo a rewrite? (not an opinion on EDF btw, just as an example)

I'm not sure why your fixated on whitespace , but thinking about it more
I don't think it matters .. If you fix whitespace or major issues first,
it doesn't matter .. All the issues have to eventually get fixed .. Not
to mentioned that LKML is not something you could remotely control in
that way.

> > In this case the author is not totally aware of how to submit this
> > code.. I don't think it's at all inappropriate to comment on that. His
> > next submission will likely be much cleaner and nicer. It may even speed
> > up the inclusion process since he'll be more easily able to submit the
> > code (with practice and comments from us).
> >    
> 
> Give people some credit.

What do you mean?

Daniel

