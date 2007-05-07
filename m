Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbXEGNuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbXEGNuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbXEGNux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:50:53 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:22283 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933826AbXEGNuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cb+ND5i8TpbMQl+tZVKZwl8KurdFhYr2F4C0Blhy9fkkMm1NfSuU1vZuEDMl7Gm9mDwjZcBOLmwDCWSqbGNrcJiZoTKlYMRYehtT4hZFUOCPkRIQ0yjveyDLsS/2PeaBYoGyXcBn0Q+d94cjE/tCaoE/y4OEOb+vO82SY/0XgyU=
Message-ID: <170fa0d20705070650g47ede2b6q9d1ad899d55ed57f@mail.gmail.com>
Date: Mon, 7 May 2007 09:50:52 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Daniel Phillips" <phillips@google.com>
Subject: Re: [patch] CFS scheduler, -v9
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Willy Tarreau" <w@1wt.eu>, "Gene Heskett" <gene.heskett@gmail.com>,
       "Mark Lord" <lkml@rtr.ca>, buddabrod <buddabrod@gmail.com>,
       "Balbir Singh" <balbir@in.ibm.com>
In-Reply-To: <4d47a5d10705070302k3f081074k89f0122cee7ae2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070503140911.GA21916@elte.hu>
	 <4d47a5d10705070302k3f081074k89f0122cee7ae2e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Daniel Phillips <phillips@google.com> wrote:
> Hi Ingo,
>
> I just thought I would mention this, because it is certainly on my
> mind.  I can't help
> wondering if other folks are also concerned about this.  The thing is,
> why don't you
> just send your patches to Con who got this whole ball rolling and did a bunch of
> great work, proving beyond any reasonable doubt that he is capable of
> maintaining
> this subsystem, whatever algorithm is finally adopted?  Are you worried that Con
> might steal your thunder?  That somehow the scheduler is yours alone?  That you
> might be perceived as less of a genius if somebody else gets credit
> for their good
> work?  NIH?
>
> My perception is that you barged in to take over just when Con got things moving
> after the scheduler sat and rotted for several years.  If that is in
> any way accurate,
> then shame on you.

Daniel, I can't hold a candle to your abilities and I respect your
talents and Linux contributions but what are your motives with this
flame?

I think injecting such uninformed/speculative negativity is an awkward
and misplaced distraction.  If you look at the archives there was a
flurry of (sometimes heated) discussion between Con and Ingo.  They
seemed to bury the hatchet and get back to critical discussion and
analysis of CFS et al.

Maybe I'm naive and/or missing something but Ingo doesn't seem to be
the glory whore type.  He clearly has a strong interest in improving
Linux and brings his unique abilities to bear on very complex Linux
subsystems.  We should be grateful that he has elected to dedicate so
much time to improving the CPU scheduler.  Ingo has injected new
momentum and innovation, yes he leveraged Con's work.  But to be
clear: he did so in an open forum and has engaged Con and the rest of
LKML the entire time.

Mike
