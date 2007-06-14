Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbXFNT1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbXFNT1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbXFNT1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:27:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbXFNT07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:26:59 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Adrian Bunk <bunk@stusta.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
	<ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706140305.50095.dhazelton@enter.net>
	<orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141003550.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 15:35:29 -0300
In-Reply-To: <alpine.LFD.0.98.0706141003550.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 10\:14\:37 -0700 \(PDT\)")
Message-ID: <or8xame64u.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Alexandre Oliva wrote:
>> 
>> It's not that the hardware is deciding to impose restrictions on its
>> own.  It's the hardware distributor that is deciding to use the
>> hardware to impose restrictions on the user.  Seems like a violation
>> of section 6 of GPLv2 to me.

> You *still* haven't figured out the difference between "the software" and 
> "a particular copy of the software", have you?

I have.  And so has GPLv2, look:

  2. You may modify your copy or copies of the Program or any portion
                         ^^^^

> What's your problem?

Trying to get you to see what is so obvious to me.

> So let's look at that "section 6" that you talk about, and quote the 
> relevant parts, will  we:

> 	You may not impose any further restrictions on the recipients' 
> 	exercise of the rights granted herein.

> and then let's look at Red Hat sending me a CD-ROM or a DVD.

> Now, Red Hat clearly *did* "further restrict" my rights as it pertains TO 
> THAT COPY ON THE CD-ROM! I cannot change it! Waa waa waa! I'll sue your 
> sorry ass off!

Red Hat is not stopping you from making changes.  The media is, and
that's not something Red Hat can control.

Compare this with the TiVO.  TiVO *designs* the thing such that it can
still make changes, but customers can't.

That's the difference.

TiVO is using hardware to "impose further restrictions on the
recipients' exercise of the rights granted herein", and this violates
section 6 of GPLv2.

> See the issue? You are continually making the mistake of thinking that the 
> GPLv2 talks about individual copies of software.

It does.  You're making the mistake of thinking that it doens't.  And
even in the legal terms that you claimed to have understood so
thoroughly.

> The rights granted are the rights to "distribute and modify the software". 

More specifically, some of the rights are:

  copy and distribute verbatim copies of the Program's source code as
  you receive it

  modify your copy or copies of the Program or any portion of it, thus
  forming a work based on the Program, and copy and distribute such
  modifications or work

> But by "the software", the license is not talking about a particular 
> *copy* of the software, it's talking about the software IN THE ABSTRACT.

Please read it again.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
