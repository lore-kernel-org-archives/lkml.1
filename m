Return-Path: <linux-kernel-owner+w=401wt.eu-S1763888AbXF1A4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763888AbXF1A4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 20:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbXF1A4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 20:56:42 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:60444 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758944AbXF1A4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 20:56:41 -0400
To: davids@webmaster.com
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKAELBEOAC.davids@webmaster.com>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Wed, 27 Jun 2007 21:56:22 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAELBEOAC.davids@webmaster.com> (David Schwartz's message of "Wed\, 27 Jun 2007 16\:53\:14 -0700")
Message-ID: <ory7i4zykp.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 27, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> Alexandre Oliva writes:

>> Yes, but in the scenario I proposed, the source code *is* in the
>> preferred form for making modifications, it just so happens to be
>> behind a barrier you cannot trespass.  This is not different from
>> shipping binaries and sources in a CD inside a locked box that you
>> can't open.  You've received both, but how is the fact that you can't
>> reach the source code (or the binaries) a violation of the GPL in this
>> case?

> Behind a barrier is not the preferred form for modification.

Where does it state that there must not be a barrier?  I see it saying
the source must accompany the binary, under 3a.  

> Encrypted with a key you don't have is not the preferred form for
> modification.

Indeed, but why does it matter?  In a CD is not the preferred form for
making modifications either.  In fact, in the CD, you can't modify it
at all.  What's *behind* encryption is the source code, along with the
binary it accompanies.

>> And, if it's not a violation, what is it that makes the case of
>> shipping programs in a locked enclosure different from shipping them
>> in a locked computing device?

> I honestly don't see what relevance this could possibly
> have. Getting access to the source is a fundamental GPL right.

That's the spirit.  But where does the *letter* of the GPL state it?

> By this argument, shipping a GPL'd work in ROM would violate the GPL
> because you cannot easily modify that particular copy.

I've already explained that the inability to modify what's in the CD
is not a restriction imposed by whoever recorded the bits in there as
a means to stop you from making modifications.

>> I ought to be entitled to modify any bit in the executable and
>> expect that to have the same effect as modifying that bit on that
>> executable on any other computer.

> Nope, sorry. If this were true, you ought to be entitled to modify a bit in
> the Linux kernel and have it have the same effect as modifying that Linux
> kernel on my desktop.

If your desktop is sufficiently similar, and the kernel binaries are
identical, why should I not expect the same result to arise?

> Again, nonsense view leads to nonsense conclusions.  The fix is to
> reject the nonsense view. There are no special GPL rights to
> particular copies of works or particular hardware.

  2. You may modify your copy or copies of the Program or any portion
     of it          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

>> The fact that it stops
>> working as a result of TiVo's design to prohibit modification, rather
>> than by any other differences in the computer (e.g., the absence of
>> the signature checks), just goes to show that there is intent to
>> impose further restrictions on modification of the software.

> Intent is not the issue.

Imposing further restrictions is the issue.

> If modifying software in this way is a GPL right, then anything that
> prevents you from modifying software in this way is a GPL violation.

If it is imposed by the licensee, yes, it is indeed.

> If you can't distribute so as to give all GPL rights, you can't
> distribute at all.

Exactly.

> If the GPL says I can modify my distributed copy, then distributing
> on CDROM is a GPL violation.

It doesn't state "you must distribute sources in modifyable media", it
says "you may modify your copies, and the distributor must not have
imposed restrictions on your exercise of this right"

If you can't modify your copies because others get in the way, too
bad.  If you can't just because the distributor stops you, there's a
GPL violation.

> It is mind-bogglingly obvious that any sort of "right to modify one
> particular copy" is *not* a GPL right.

Please read the license instead of assuming you know what it says.
You clearly don't.  See above.

> You are wasting an awful lot of time and effort analyzing things that have
> *NO* GPL consequence at all.

Let's just say I honestly hope you are right and I'm wrong.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
