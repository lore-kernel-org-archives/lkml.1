Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbXFNRQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbXFNRQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbXFNRQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:16:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbXFNRP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:15:59 -0400
Date: Thu, 14 Jun 2007 10:14:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Daniel Hazelton <dhazelton@enter.net>, Adrian Bunk <bunk@stusta.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706141003550.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr>
 <alpine.LFD.0.98.0706131957440.14121@woody.linux-foundation.org>
 <ortztbgi03.fsf@oliva.athome.lsd.ic.unicamp.br> <200706140305.50095.dhazelton@enter.net>
 <orr6oefpg4.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Jun 2007, Alexandre Oliva wrote:
> 
> It's not that the hardware is deciding to impose restrictions on its
> own.  It's the hardware distributor that is deciding to use the
> hardware to impose restrictions on the user.  Seems like a violation
> of section 6 of GPLv2 to me.

You *still* haven't figured out the difference between "the software" and 
"a particular copy of the software", have you?

What's your problem?

I doubt you're really stupid, so I think your problem is that if you admit 
that "the software" is something *different* from "a particular copy of 
the software", you realize (perhaps subconsciously) that your arguments do 
not make any sense. So you do not allow yourself to think clearly about 
the matter.

So let's look at that "section 6" that you talk about, and quote the 
relevant parts, will  we:

	You may not impose any further restrictions on the recipients' 
	exercise of the rights granted herein.

and then let's look at Red Hat sending me a CD-ROM or a DVD.

Now, Red Hat clearly *did* "further restrict" my rights as it pertains TO 
THAT COPY ON THE CD-ROM! I cannot change it! Waa waa waa! I'll sue your 
sorry ass off!

See the issue? You are continually making the mistake of thinking that the 
GPLv2 talks about individual copies of software. And I'm continually 
having to point out that that is a MISTAKE.

And it's OBVIOUSLY a mistake, because your reading is nonsensical. If you 
think that Tivo does somethign bad, then hat Red Hat does is the same 
badness, thousads times over! I strongly suspect Red Hat has shipped a lot 
more CD-ROM's than Tivo has shipped boxes!

So let me iterate AGAIN:

 - the rights that the GPLv2 gives *cannot* be about "the particular copy" 
   that you send, since that would be INSANE. Red Hat sends lots of copies 
   of software that are NOT MODIFIABLE!

 - ergo, the rights about "the software" in the GPLv2 must be about 
   something else. 

See? Your argument about "individual copies" simply DOES NOT MAKE SENSE!

Just admit it.

> > What the GPL *does* say is that you can't "add additional
> > restrictions to the license"
> 
> Not quite.  It's more general than that:
> 
>   You may not impose any further restrictions on the recipients'
>   exercise of the rights granted herein.

And your point is? Nothing.

The rights granted are the rights to "distribute and modify the software". 
But by "the software", the license is not talking about a particular 
*copy* of the software, it's talking about the software IN THE ABSTRACT.

In other words, the reason that Red Hat is not violating the GPLv2 is that 
no, I cannot change the copy on the software on the particular CD-ROM or 
DVD, but I can get a copy of the sources other ways, and make my own 
modifications *SOMEWHERE*ELSE*!

The fact that Red Hat made a "restricted copy" is totally irrelevant.

In fact, it's exactly as irrelevant as the fact that Tivo makes a 
"restricted copy". The *software* is still free!

		Linus
