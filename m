Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbXFPBjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbXFPBjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 21:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbXFPBj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 21:39:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756921AbXFPBj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 21:39:28 -0400
To: "Scott Preece" <sepreece@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rob Landley" <rob@landley.net>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<20070614122031.4751a52b@the-village.bc.nu>
	<20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net>
	<20070615120926.GD6269@elte.hu>
	<orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
	<7b69d1470706151503v23253546w5648f04673741c8f@mail.gmail.com>
	<orodjgvm5v.fsf@oliva.athome.lsd.ic.unicamp.br>
	<7b69d1470706151752x30aeaaacl305d964b0ae4cc2d@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 22:38:45 -0300
In-Reply-To: <7b69d1470706151752x30aeaaacl305d964b0ae4cc2d@mail.gmail.com> (Scott Preece's message of "Fri\, 15 Jun 2007 19\:52\:22 -0500")
Message-ID: <orlkeku196.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, "Scott Preece" <sepreece@gmail.com> wrote:

> On 6/15/07, Alexandre Oliva <aoliva@redhat.com> wrote:
>> > The FSF's approval of this distinction (ROM versus replaceable) places
>> > the FSF's particular principles over users interests, for no
>> > particular reason

>> Over *users* interest?  How so?

> Users benefit from the ability to get software updates, from the
> manufacturer, to resolve problems, fix security vulnerabilities, and
> provide updated functionality.

Which they could have the option to do themselves if the manufacturer
didn't prohibit them from doing so.

>> > if the manufacturer believes that it cannot legally allow software
>> > modification, all the restriction does is force them either to make
>> > the software unmodifiable (which advances freedom not at all) or to
>> > use software under a different license (which advances freedom not
>> > at all).

>> Right.

>> But if the manufacturer believes that it can legally allow it, and
>> wants to be able to install, software modifications, then it must
>> decide between giving that up and letting the user do it as well.  And
>> this is where the users interests may prevail.

> Whether it's a legal requirement or a business decision, the result is
> the same - neither forcing the manufacturer to make the device
> non-updatable nor forcing the manufacturer to use different software
> benefits anyone.

I agree.  But that's an incomplete picture.

It's the other part of the picture, that you left out twice, that is
the case that is good for the users *and* for the community.

> I don't believe that the existence of this clause will lead to more
> manufacturers making their devices modifiable - there are too many
> other options if they think that non-modifiability is important to
> them.

> [Note that I *do* think it's perfectly appropriate that authors who
> feel that they don't want their work used in such devices should be
> able to license them in line with that belief. I just don't think it
> has any practical value aside from making them feel better.]

They can do that with GPLv3.  And those who don't want to stop this
can then add a special permission.  And then everybody wins.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
