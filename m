Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbXFSC6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbXFSC6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762960AbXFSC6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:58:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762855AbXFSC6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:58:37 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: mea culpa on the meaning of Tivoization
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706181559.40320.dhazelton@enter.net>
	<orps3t9cfw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706181808.18007.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 23:57:20 -0300
In-Reply-To: <200706181808.18007.dhazelton@enter.net> (Daniel Hazelton's message of "Mon\, 18 Jun 2007 18\:08\:17 -0400")
Message-ID: <orabuw8xdb.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Monday 18 June 2007 17:31:47 Alexandre Oliva wrote:
>> And if you look at GPLv3dd1 or dd2 IIRC, that's how it started.  For
>> some reason, the FSF turned it into the more lax (in some senses)
>> installation information for user products in dd3.  Maybe they decided
>> that the argument about the signature being effectively part of the
>> executable, and therefore the key being effectively part of the source
>> code, was less likely to be upheld in a court of law than this
>> alternate phrasing.  All in all, the effect is the same AFAICT, and
>> the spirit is being complied with.

> But the change has some massive problems.

Such as?  Is the effect really any different?

> If dd1 or dd2 was clearly and concisely written such that the
> conditions were not open to a different interpretation without
> creative re-definition of words then changes would not be
> needed. (I'm still working on the version I mentioned - give me a
> bit, writing english in such a way that a lawyer can't twist it to
> mean whatever they are paid to make it mean is difficult.)

It's very difficult and, worse, it might turn out to be unenforceable.
You'd have to count on signing keys being copyrightable, and they are
unlikely to be, and on signatures being derived works of both, which
is a tough call.  The whole idea resonates very well with the spirit
of the license, but we need more than that, we need it to be very
likely to work.  I suspect this is why the FSF has decided to take
another route to achieve the same (AFAICT) effect.

>> I don't see how this is different from refraining from accepting
>> contributions under any other license, except that you can't use
>> license incompatibility to reason it out as an impossibility you
>> established for yourself in just the very same way.

> I think there was more to it than that, but the point doesn't
> matter. If the license used on contributed code *isn't* completely
> compatible with the license on the project it can't be used
> anyway. (doesn't the GPLv3 cover situations like that?)

I'm not sure what you're asking.  GPLv3 covers additional permissions,
that are really no different from dual-licensing, so anyone can choose
to drop them when combining with works (including their own) that
don't offer such additional permissions.

>> My objection was mainly about the "forcing".  FSF's stance is about
>> educating users as to the moral and ethical reasons, such that they
>> reject non-Free Software, while at the same time providing software
>> authors with means to stop others from hurting users, by depriving
>> them of the freedoms they're morally entitled to have.

> Hrm... When I first hit the end of this massive sentence I was really 
> confused. Took about five minutes for me to remember that "morally entitled" 
> is based on the morals promoted by the FSF.

Yes.  And the 'them' after the last comma refers to the users, not the
authors (although they can be users too), in case it's not clear ;-)
:-D

> Everyone that has been part of this discussion - my personal code of morals 
> will not let me get away without this: "Forgive me if, in the heat of the 
> moment, I offended any of you."

FWIW, I never felt offended by you, but I second your request and
extend it to all participants in the thread too, particularly to Ingo,
to whom I remember having directed some harsh words.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
