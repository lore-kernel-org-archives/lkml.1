Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbZI3MGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbZI3MGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZI3MGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:06:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46968 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZI3MGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:06:09 -0400
Date: Wed, 30 Sep 2009 14:05:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Raistlin <raistlin@linux.it>,
       Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
Message-ID: <20090930120535.GE1412@ucw.cz>
References: <1253615424.20345.76.camel@Palantir> <1253625878.6575.34.camel@desktop> <20090922173916.257dff1d@tpl.lwn.net> <1253663739.4317.12.camel@desktop> <20090922180611.7a47adcc@tpl.lwn.net> <1253666423.25689.30.camel@desktop> <4ABA0AA6.3010408@redhat.com> <20090923122530.GB6390@elte.hu> <1253717459.20648.39.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253717459.20648.39.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-23 07:50:59, Daniel Walker wrote:
> On Wed, 2009-09-23 at 14:25 +0200, Ingo Molnar wrote:
> > * Avi Kivity <avi@redhat.com> wrote:
> > 
> > >> discouraging contributions is more something that happens when you 
> > >> get the responses I got earlier in this thread..
> > >
> > > That's probably intentional.  Whitespace fixes have their place but 
> > > not at this stage in a patch's lifecycle.
> > 
> > Exactly. What might make sense is to scan linux-next for new commits 
> > that show serious cleanliness trouble - and send fix patches to the 
> > parties involved. That's a real effort and brings the code forward.
> 
> Often times when a patch is at youngest that when you want to catch
> these issues .. This EDF patch will likely get submitted more than
> twice. If you catch all the minor problems first you will not be dealing
> with them later when it comes time to include the code.

You  want to deal with them later, because many patches end up  in
trashcan...

Now, Ingo's idea of scanning -next (and fixing it) sounds sane...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
