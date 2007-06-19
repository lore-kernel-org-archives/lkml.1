Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXFSIXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXFSIXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXFSIXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:23:09 -0400
Received: from www.osadl.org ([213.239.205.134]:49787 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754397AbXFSIXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:23:07 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: mea culpa on the meaning of Tivoization
Date: Tue, 19 Jun 2007 10:22:21 +0200
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <200706182331.19571.hjk@linutronix.de> <orejk88xvd.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orejk88xvd.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706191022.21869.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 19 Juni 2007 04:46 schrieb Alexandre Oliva:
> On Jun 18, 2007, Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> 
> > Am Montag 18 Juni 2007 23:18 schrieb Alexandre Oliva:
> >> On Jun 18, 2007, Hans-Jürgen Koch <hjk@linutronix.de> wrote:
> >> 
> >> >> Vendor would be entitled to the benefit of the doubt as to the
> >> >> motivations in this case, so it would likely be unenforceable anyway.
> >> 
> >> > Right. If GPL v3 comes out, there'll probably be a new task for
> >> > hardware development engineers: How to find excuses for hardware that
> >> > prevents software modifications and how to conceal the true intent.
> >> 
> >> Yup.  And then GPLv4 will have to plug whatever holes they find to
> >> disrespect users' freedoms.  That's how I expect the game to be
> >> played.
> 
> > If you were right and it turned out that way, the whole GPL would
> > become so ridiculous that it won't have any of its intended effects.
> 
> How so?  The intended effects are to protect users' freedoms, by
> requiring them to be respected.  If we keep on plugging holes as they
> appear, it will keep close to achieving its intended effects.  

No. Credible licenses should be simple like physical laws. Newton's law
is expressed in terms of a single mathematical equation. That's why it's
still valid, and you still learn it at school although meanwhile people
know that there are limitations to it.

If you come up with a new version of a license every year, you will only
weaken it. Please note that quantum mechanics is _not_ such a hole-plugging
addition to Newton's law. It's a new simple physical law, expressed in terms
of a single simple mathematical equation that contains the old law as a
border case. If that were not the case, it would have never been accepted.

If you want a GPLv3, please make it simple and make it contain GPLv2 as
a border case. The current draft isn't like that.

> It's 
> earlier versions of the license that will get more and more distant
> from it.

No. GPLv2 is a simple set of rights and restrictions that's easy to
understand and therefore accepted by many courts all over the world.
I cannot see any danger for the code I put under it, at least none
that would be mitigated by GPLv3.

> 
> > As far as the kernel is concerned, I expect the game's played by
> > simply keeping GPLv2. And I like it that way.
> 
> Just think about it...  What if, today, some law passed, or some court
> decision came up, that rendered a significant defense provision of
> GPLv2 or GPLv3 ineffective?

The best way to prevent that is to make the license simple and easy to 
follow. If many important open source software developers have problems
with the wording of a license, lawyers and judges will have them, too.

> 
> GPLv4 could plug that, and anyone using GPLvN+ would be able to switch
> to it immediately.  This wouldn't revoke previous licenses, of course,
> but further developments could be made under the newer license, and at
> least those could still be defended, and, as time elapsed, earlier
> versions of the software would become less and less relevant, to the
> point that the holes in their license also become less and less
> relevant, until copyright finally expires and they enter the public
> domain.

Ah, now I get the point. Yes, that's one in favor of a complicated and
confusing license. You can lengthen court proceedings until copyright
expires...

> 
> 
> The distrust for the FSF led to this very short-sighted decision of
> painting the Linux community into a corner from which it is very
> unlikely to be able to ever leave, no matter how badly it turns out to
> be needed.  

I'm neither in a corner nor do I feel the need for a different license.
I've got some code in the kernel, and I've got it under GPLv2, and I'm
happy with it. It's the FSF that thinks I should see myself in a corner. 


> Let's just hope it never is, or that some influx of 
> long-sighted comes in 

Kernel programmers are short-sighted? What kind of arrogance is that?

> and introduces mechanisms for the license of 
> Linux to be patched, should this ever be needed.  

You know pretty well that Linus clearly said he would change the license
when _he_ thinks it's needed. The point is that _you_ want him to change
the license to support _your_ political ideas.

> I'm not even talking 
> about GPLv2+, there are many other ways to accomplish this, that I've
> already mentioned in another posting in another recent huge thread.
>

I partly read that "recent huge thread". Linus elaborated his point of 
view in detail, and I very much share his opinion.

Hans

