Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbXFRXpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbXFRXpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762556AbXFRXpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:45:34 -0400
Received: from keil-draco.com ([216.193.185.50]:50507 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbXFRXpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:45:33 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Mon, 18 Jun 2007 19:45:16 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org> <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181945.16343.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007 19:31:30 Alexandre Oliva wrote:
> On Jun 18, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
<snip>
>
> > With the GPLv2, you need to give your software modifications back, but
> > the
>                                    ^^^^  BZZT!
> > GPLv2 never *ever* makes any technical limitations on the end result.
>
> Actually, just think of how many times you've heard the argument "I
> can't give you the source code for this driver/firmware/etc under the
> GPLv2 because the law says so."

Sorry to tell you this, but anyone that makes a modification to GPLv2 covered 
code and distributes that modification is bound by the license. If a law 
makes following the license illegal, then they can't use any rights granted 
by the license. They are breaking the law by refusing to follow the license.

<snip>
> > The GPLv2 requires that you give source code out.
>                  ^^^^^^^^ BZZT ;-)
> > But if you want to make your hardware in a way that it only runs
> > signed versions, because of some reason like an FCC rule, or banking
> > rule, or just because you damn well want, the GPLv2 doesn't stop
> > that.
>
> And then, the user is stopped from making appropriate technical
> decisions.

You marked the "requires" as an error. Technically it is. Practically, 
however, it is rare for a modification to not fall under the "distribution" 
part of the license, making the "release the source" requirement active 
almost all the time.

<snip>
> > b) I think you're simply wrong in your math. I think more people
> > like the middle-ground and not-frothing-at-the-mouth spirit of "open
> > source" over the religious dogma of "free software".
>
> It looks like the math you're talking about is in no way related with
> anything I've argued about.  You seem to be thinking about the number
> of people who claim to be on the "free software" or "open source"
> sides, but I can't fathom in what way this is related with whether you
> get more or less contributions from users as a consequence of users'
> being permitted to tinker with the free software in their own devices.

"More Developers" (either "Free Software" or "Open Source") == "More 
Contributions"

That equation is very simple to understand - claiming its wrong is impossible.
<snip>
> > See? Those are three totally different reasons why I think the GPLv2 is
> > the right license for me, and for the kernel.
>
> Ok, the only one that stands is the moral reason.  

Apparently because you can't admit that a good reason *IS* a good reason when 
it conflicts with your belief that the FSF is correct. (The same as 
the "Science can't be right because it conflicts with the bible" I hear from 
all kinds of Xtians these days)

DRH
PS: I know I've said I'm done with this conversation, but this is like a bad 
habit. I just couldn't help myself.

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
