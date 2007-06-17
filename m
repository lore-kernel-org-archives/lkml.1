Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbXFQDw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbXFQDw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 23:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbXFQDwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 23:52:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507AbXFQDwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 23:52:49 -0400
To: "David Schwartz" <davids@webmaster.com>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKKEIFEKAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 00:52:38 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEIFEKAC.davids@webmaster.com> (David Schwartz's message of "Sat\, 16 Jun 2007 19\:35\:34 -0700")
Message-ID: <orodjfkzjt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> On Jun 16, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> > No, this is completely and utterly wrong. By this logic, Linux
>> > isn't free if
>> > I can't run it on *YOUR* laptop. TiVo places restrictions on
>> > *hardware*. The
>> > hardware is not free.

>> TiVo uses the hardware to stop the user from adapting the software to
>> suit his/her needs.  TiVo is imposing an artificial restriction on
>> what you can do with the software you use.

> Sure, and you use the hardware to stop me from modifying the Linux on your
> laptop.

Do I?  How so?

>> You don't use the software in my laptop.  The laptop is not yours.
>> You have no claims whatsoever about it.

> Exactly. And I have no *GPL* claims to my laptop either. The GPL
> doesn't talk about who owns what hardware and it would be insane for
> it to do so.  Even though the TiVo hardware is yours, you have no
> more *GPL* claims to it than you do to someone else's laptop. The
> GPL does not talk about who owns what hardware.

This is absolutely correct.

What it does is impose conditions for whoever wants to distribute the
software.  And GPLv3 makes it explicit that one such condition is to
permit the user to install and run modified versions of the program in
the hardware that ships with the program.  A condition that is
arguably already encoded in the "no further restrictions to the rights
granted" by the license" and to the requirement for complete
corresponding source code to accompany the binary.

That you disagree with it doesn't make you right.

But that it is within the spirit of the GPL defined by its authors
(which is all I'm trying to show here), it is.

> The GPL (at least through version 2) is about free access to source
> code.

Some think so, but this was GPLv1.

v2 added stuff such as:

  if a patent license would not permit royalty-free redistribution of
  the Program by all those who receive copies directly or indirectly
  through you, then the only way you could satisfy both it and this
  License would be to refrain entirely from distribution of the
  Program

Do you realize that the patent is unrelated with the program, but
nevertheless the copyright license establishes conditions about what
kind of patent licenses you may accept in order for you to have
permission to distribute the program.

Why should restrictions through patents be unacceptable, but
restrictions through hardware and software be acceptable.

Both are means to disrespect users' freedoms.

It is the duty of the FSF to defend these freedoms.  It's its public
mission.  That's a publicly stated goal of the GPL, for anyone who
cares to understand it, or miss it completely and then complain about
changes in spirit.

> They just do not include being able to use the source code on whatever
> hardware you want because that hardware could be restricted for any number
> of reasons.

That's true.  Per the license, it's only who distributes the hardware
to you that shouldn't impose such restrictions.

>> I see what you're getting at.  This might be relevant.  If I granted
>> you remote access to my desktop, I probably wouldn't want to grant you
>> permission to install and boot whatever kernel fancies you.

>> The difference is that, when I grant you remote access to my desktop,
>> I'm not distributing the software to you.  But when TiVo places its
>> DVR in your home, it is.

> Assume the access includes the right to download copies of the software, in
> that case, it is distribution. For GPL purposes, all that matters is whether
> the software is distributed or not, and the rights must be the same
> regardless of anything else.

I'm inclined to agree.

> The GPL doesn't care what your motivations are. If you can't fulfill
> your GPL obligations, no matter how nice your intentions, you can't
> distribute at all.

That's right.  But one of the obligations is to impose no further
restrictions on the exercise of the rights.  What is "imposing a
restriction"?  Installing the software in ROM isn't regarded as such,
it's just a technical decision.  Installing the software in modifiable
non-volatile storage, but denying the user the ability to change it,
is regarded as imposing a restriction.  (note the "denying")  It is a
matter of intent.

It's not because you only install say 32MB of RAM on the machine that
you're denying the user the ability to run OOo on the machine.  But if
you ship the computer with plenty of memory, but somehow configure the
hardware or the operating system so as to prevent the user from
upgrading an OOo that shipped with it, while you can still install
that upgrade, then you're actively placing limits on the user's
freedom WRT to that software, and an anti-tivoization clause would
then stop you from distributing the software under these conditions.

>> > They just want the source code, and TiVo gives it to them. GPL was about
>> > source code not being secret, to them and to many others.

>> They chose the GPL because it worked this way for them.  But this is
>> not what the GPL is *all* about.  And GPLv3 shows the difference.

> That's what it was about to many people, including Linus. It was about
> getting source code.

I've never disputed that this is how they perceive it.

I've never disputed that GPLv2 serves this goal.

I still think GPLv3 serves this same goal, and better than v2.

But this is not what my participation here is about.

My participation here is about showing that GPLv3, and anti-tivozation
in particular, don't violate the spirit of the defending users'
freedoms WRT the covered software, such that the Free Software remains
Free.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
