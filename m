Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYGZSaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYGZSaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYGZSaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:30:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:55182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYGZSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:30:10 -0400
Subject: Re: 2.6.24.7-rt15
From: Jaswinder Singh <jaswinder@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Sebastian Sewior <bigeasy@linutronix.de>,
       Greg Ungerer <gerg@snapgear.com>, Carsten Emde <ce@ceag.ch>
In-Reply-To: <Pine.LNX.4.58.0807260827240.12591@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
	 <1985e0f60807252248n581bdfa0s363f6ce0d283ec2c@mail.gmail.com>
	 <1217070800.22147.8.camel@jaswinder.satnam>
	 <Pine.LNX.4.58.0807260827240.12591@gandalf.stny.rr.com>
Content-Type: text/plain; charset=utf8
Date: Sat, 26 Jul 2008 23:58:54 +0530
Message-Id: <1217096934.8053.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Sat, 2008-07-26 at 08:28 -0400, Steven Rostedt wrote:
> 
> On Sat, 26 Jul 2008, Jaswinder Singh wrote:
> 
> > Hello all,
> >
> > > We are pleased to announce the 2.6.24.7-rt15 tree, which can be
> > > downloaded from the location:
> > >
> > >  http://rt.et.redhat.com/download/
> > >
> >
> > linux-2.6/scripts/checkpatch.pl patch-2.6.24.7-rt15 is saying :
> >
> > total: 479 errors, 813 warnings, 65464 lines checked
> >
> > patch-2.6.24.7-rt15 has style problems, please review.  If any of these errors
> > are false positives report them to the maintainer, see
> > CHECKPATCH in MAINTAINERS.
> >
> > It seems many of errors and warnings are quite simple and easily removable.
> 
> Yes, and they will be before going into mainilne.
> 

I convert ﻿patch-2.6.24.7-rt15 to git patch and located here :-
http://git.infradead.org/users/jaswinder/linux-2.6-rt.git?a=shortlog;h=refs/heads/2.6.24.7-rt15

I also try to fix style problems and also did some cleanup.

﻿scripts/checkpatch.pl is now saying :
total: 108 errors, 347 warnings, 65486 lines checked

I left these style problems for developers.
You can get updated version from :-
http://git.infradead.org/users/jaswinder/linux-2.6-rt.git?a=shortlog;h=refs/heads/2.6.24.7-rt15-jsr

Thank you,

Jaswinder Singh.

