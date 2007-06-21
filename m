Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXFUXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXFUXYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXFUXYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:24:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbXFUXYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:24:06 -0400
To: davids@webmaster.com
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKEEINEMAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 20:23:57 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEINEMAC.davids@webmaster.com> (David Schwartz's message of "Thu\, 21 Jun 2007 13\:48\:17 -0700")
Message-ID: <orvedgj3hu.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> > Wouldn't that defeat the entire purpose of the GPLv3? Couldn't
>> > I take any
>> > GPLv3 program, combine it with a few lines of Linux code, and
>> > Tivoize the
>> > result?

>> No.  This is not permission to relicense.  This is permission to
>> combine.  Each author still gets to enforce the terms of her own code.

> This makes no sense. We are not talking mere aggregation here, we are
> talking developmental convergence. If I wrote some code that was in the
> Linux kernel, how can I enforce the terms of my code (guaranteed write to
> Tivoize) in the derivative work that it becomes mixed with?

In just the same way you'd enforce it today: with help from a lawyer
who understands these issues that you clearly don't understand.

>> So a tivoizer would have to take out the code licensed under the
>> GPLv3, and use only the code that permits tivoization.  Same as today,
>> but without the possibility of cooperation for licensees who don't
>> tivoize.

> I am baffled how this could possibly work. You understand that the GPLv2
> specifically guarantees that any derivative work will be Tivoizable and the
> people who chose the GPLv2 specifically want it that way?

Yes.  And the GPLv2 code would remain that way.

If GPLv3 had this provision I suggested, and you wanted to cooperate
with some other project that offered GPLv3 drivers, then you could use
them by adding the mutual-cooperation provision I suggested.

Of course you're free to not want to cooperate with anyone else who
doesn't share your opinion.  That's your call.

> If I chose the GPLv2 over the GPLv3 as a conscious choice, that means I want
> people to be able to Tivoize any derivative work made from my work that is
> distributed.

This provision was not intended to prevent anyone from tivoizing your
work or derived works thereof.  It was only intended to enable you to
use code from GPLv3 projects as long as these GPLv3 projects could
also use your code.  Mutual cooperation, as opposed to no cooperation
whatsoever.

I *think* lawyers would probably recommend you to keep code under
different licenses in separate files, like you already do with code
licensed under GPLv2-compatible licenses.

I *think* that, with this pair of mutual cooperation provisions, you
could even use code licensed under the Apache 2.0 license.  And
OpenSolaris drivers, if it's licensed under GPLv3.

And you wouldn't be departing from your intent to enable people to
tivoize your code, which you currently choose not to enforce even
though GPLv2 might very well enable you to; you could keep on
cooperating with people who understand GPLv2 doesn't permit
tivoization, and you'd be able to establish mutual cooperation with
people who choose a license that makes this point clear.

It's not like anyone can safely tivoize devices with GPLv2 already, so
refusing to cooperate with GPLv3 on these grounds buys you nothing.
It is only a public statement of refusal to cooperate, with you are
entitled to make, even if it comes off as silly because you chose a
license that already contains the provisions for "complete
corresponding source code" and "no further restrictions on the
exercise of the rights granted by the license" that tivoizers fail to
comply with.

At which point one gets to wonder why you chose this license in the
first place, if it doesn't give you what you want.

FWIW, all of my (very few) contributions to Linux were made with the
intent of not permitting tivoization or any form of restricting users
freedoms.  I guess this means, from now on, you'd stop accepting my
contributions and take out whatever contributions I've made, since
otherwise I'd be able to enforce them against tivoizers.  And what's
more, I could still use your code in my GPLv2 projects, and enforce
that against tivoizers, and there's nothing you can do to stop me.

So what exactly are you trying to accomplish by pretending that mutual
compatibility with GPLv3 would set you back in any way?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
