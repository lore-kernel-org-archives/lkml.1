Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbXFSFXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbXFSFXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXFSFXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:23:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXFSFXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:23:23 -0400
To: "David Schwartz" <davids@webmaster.com>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKGEFEELAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 02:23:14 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEFEELAC.davids@webmaster.com> (David Schwartz's message of "Mon\, 18 Jun 2007 19\:17\:39 -0700")
Message-ID: <orps3s5xh9.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> Why is the fact that only the root user can load a kernel module not a
> further restriction?

Because the user (under whose control the computer is, be it person or
company) set up the root password herself?

>> > The GPL was never, until GPLv3, about who gets to make
>> > authorization decisions.

>> I can agree with that.  As long as the authorization decisions are not
>> used as means to deprive users' of the freedoms that must not be
>> restricted, they can be whatever the distributor fancies.

> Right, which is the freedom to modify the software. The freedom to get the
> source code. The freedom to use the source code however you want, absent
> legitimate authorization decisions to the contrary.

What makes them lawful, given the "no further restrictions"?

> However, "you can't load your modified sofware on *MY* hardware" is
> not a further restriction.

As long as you didn't hand me the hardware along with the software,
for me to become a user of the software on that hardware, I agree.

>> >> Tivoizers say "hey, you can still modify and run the software, just
>> >> not on *this* hardware".

>> Tivoization is treating the hardware that comes along with the
>> software as if it was different from others.  But it isn't.

> Of course it is. They have the authorization right on that hardware, and
> they don't have that right on my laptop.

Ok, I stand corrected.  They have that right.

However, since they distribute GPLed software along with the hardware,
such that I'd be a user of the software on that hardware, they should
not impose further restrictions on my freedoms that the GPL stands to
defend WRT the GPLed software.  So, they must not use their
authorization right to deny me, the user of the software, in the
hardware that they meant me to use the software, the freedom to adapt
the software for my own needs, and run it for any purpose.

> That would mean it doesn't permit the distribute to state "BTW, you can't
> install, modify or run this software on *OUR* computers that run our
> corporate network".

No, because the user is not becoming a user of the software on their
own computers.  Only in the computer that was shipped along with the
software.

> Don't you see how obviously absurd that is?

Yes, it would be, if it were so.

>> The "no further restrictions" applies equally to all computers.
>> It's not just because you have some control over some particular
>> hardware that you deliver along with the software that you're
>> entitled to use that to limit the user's freedoms.

> I agree. However, that doesn't mean that people who own or control
> particular pieces of hardware can't put authorization barriers that
> prevent you from running whatever software you want on thos pieces
> of hardware.

That's correct, as long as they didn't give me that hardware with
GPLed software in it.  The moment they do, I become recipient and user
of GPLed software in that computer, and they should relinquish their
power to impose restrictions on my exercise of the freedoms WRT that
software.  And there's no reason whatsoever to exclude restrictions
such as those implemented by means of authorization.

>> > Which is a massive departure from the previous GPL spirit which
>> > was about being able to use the software on *ANY* hardware you
>> > controlled, not some special pieces more than others.

>> It doesn't make the sold hardware special.  How come you think it
>> does?

> Because it becomes the only piece of hardware in the entire universe on
> which the GPL gives you the right to run the software. On every other piece
> of hardware, you must obtain that right from whoever owns the right to
> decide what software runs on that hardware.

I see.  Good point.  Agreed.  That hardware is indeed special.  Per
the GPL, it's the only one in which the distributor must NOT exercise
any restraints whatsoever on my exercise of the freedoms.

Which in turns makes it non-special, in that, from the point of both
the distributor and the user, it becomes just like any other random
piece of hardware: the distributor doesn't limit the freedoms the user
had, and the user isn't limited in enjoying the freedoms she had.

>> It's exactly the opposite.  It just says the distributor can't
>> make the hardware special, so as to restrain the users' freedoms that
>> are inseparable from the software.

> Don't you see that the rule that "this one thing cannot be special" makes
> that one thing special since everything else *can* be special.

It took me several attempts to understand what you meant.  Yes.  It's
special in that it can't be made special.  Poof, there goes the
universe ;-)

>> > Because that is not a right the vendor chooses to give to the user.

>> As in, the vendor can turn to the user and sue her for patent
>> infringement, after distributing GPLed software to her, just because
>> the use of the patent is not a right the vendor chooses to give to the
>> user?

> I don't know what patent you are talking about.

I'm talking about the implicit patent licenses that arise from
distributing software under GPLv2.

>> > You may dislike this decision, but it's not irrational.

>> I never said it was irrational.  I just said it's a further
>> restriction on the exercise of the freedoms that must accompany the
>> software wherever it goes.

> No more than having to be 'root' to load a kernel module. You are free to
> remove it from any hardware for which you have the right to choose what
> software runs.

Yup.  And I get that right (because the distributor must not stop me)
when I receive software under the GPL along with the computer in which
I'm expected to use it.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
