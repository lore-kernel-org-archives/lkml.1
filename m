Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbXFSDZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbXFSDZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 23:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764748AbXFSDZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 23:25:37 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50707 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbXFSDZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 23:25:36 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: mea culpa on the meaning of Tivoization
Date: Mon, 18 Jun 2007 23:25:21 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <200706181808.18007.dhazelton@enter.net> <orabuw8xdb.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orabuw8xdb.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706182325.22067.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007 22:57:20 Alexandre Oliva wrote:
> On Jun 18, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Monday 18 June 2007 17:31:47 Alexandre Oliva wrote:
> >> And if you look at GPLv3dd1 or dd2 IIRC, that's how it started.  For
> >> some reason, the FSF turned it into the more lax (in some senses)
> >> installation information for user products in dd3.  Maybe they decided
> >> that the argument about the signature being effectively part of the
> >> executable, and therefore the key being effectively part of the source
> >> code, was less likely to be upheld in a court of law than this
> >> alternate phrasing.  All in all, the effect is the same AFAICT, and
> >> the spirit is being complied with.
> >
> > But the change has some massive problems.
>
> Such as?  Is the effect really any different?

I haven't looked at it, in depth, today but one of the problems I saw was the 
apparent loopholes in the text. No specifics, but I remember thinking "a 
lawyer would have a field day with this - dozens of ways they could sidestep 
these issues"

> > If dd1 or dd2 was clearly and concisely written such that the
> > conditions were not open to a different interpretation without
> > creative re-definition of words then changes would not be
> > needed. (I'm still working on the version I mentioned - give me a
> > bit, writing english in such a way that a lawyer can't twist it to
> > mean whatever they are paid to make it mean is difficult.)
>
> It's very difficult and, worse, it might turn out to be unenforceable.
> You'd have to count on signing keys being copyrightable, and they are
> unlikely to be, and on signatures being derived works of both, which
> is a tough call.  The whole idea resonates very well with the spirit
> of the license, but we need more than that, we need it to be very
> likely to work.  I suspect this is why the FSF has decided to take
> another route to achieve the same (AFAICT) effect.

Agreed. I'm still stuck trying to keep the language concise and understandable 
without delving into the descriptive flights of fancy I enjoy. (I write a lot 
more fiction than I do code, even though I started writing code a long time 
before I started on fiction)

> >> I don't see how this is different from refraining from accepting
> >> contributions under any other license, except that you can't use
> >> license incompatibility to reason it out as an impossibility you
> >> established for yourself in just the very same way.
> >
> > I think there was more to it than that, but the point doesn't
> > matter. If the license used on contributed code *isn't* completely
> > compatible with the license on the project it can't be used
> > anyway. (doesn't the GPLv3 cover situations like that?)
>
> I'm not sure what you're asking.  GPLv3 covers additional permissions,
> that are really no different from dual-licensing, so anyone can choose
> to drop them when combining with works (including their own) that
> don't offer such additional permissions.

What I was getting at, here, is that the GPLv3 isn't backwards compatible with 
GPLv2, because you aren't allowed to remove rights from the GPLv3. Remember, 
there are rights encoded in the GPLv3 that don't appear in v2. In fact, if 
you want to use GPLv3 code in a GPLv2 project you have to use GPLv3. For some 
projects, like the Linux Kernel, the upgrade is impossible to accomplish.

> >> My objection was mainly about the "forcing".  FSF's stance is about
> >> educating users as to the moral and ethical reasons, such that they
> >> reject non-Free Software, while at the same time providing software
> >> authors with means to stop others from hurting users, by depriving
> >> them of the freedoms they're morally entitled to have.
> >
> > Hrm... When I first hit the end of this massive sentence I was really
> > confused. Took about five minutes for me to remember that "morally
> > entitled" is based on the morals promoted by the FSF.
>
> Yes.  And the 'them' after the last comma refers to the users, not the
> authors (although they can be users too), in case it's not clear ;-)
>
> :-D

Yes. I almost replied "-ENOPARSE" because, when I first read it, I parsed it 
as "by depriving [the authors] of the freedoms they're morally entitled to 
have". When my brain finally rebooted after that bought of idiocy I was able 
to parse it properly.

DRH

> > Everyone that has been part of this discussion - my personal code of
> > morals will not let me get away without this: "Forgive me if, in the heat
> > of the moment, I offended any of you."
>
> FWIW, I never felt offended by you, but I second your request and
> extend it to all participants in the thread too, particularly to Ingo,
> to whom I remember having directed some harsh words.



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
