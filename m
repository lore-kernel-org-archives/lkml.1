Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbXFPAwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbXFPAwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbXFPAwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:52:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:62229 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbXFPAwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RqjLj1+Tp/WjX0He3U8s/WtABwCBBfDp5FLMeNCN51dwLPpsfH7ZG5CvWH6HvXxN7PowOchG8/IxvX1+NSqdVdtF1g1GxcWFGyy7824nkSO6jD6ycm7EA1gAUUydNpgX/UZ11w59micEXD+tpHg76IjSrLd0TcSpO0f7zixkZk4=
Message-ID: <7b69d1470706151752x30aeaaacl305d964b0ae4cc2d@mail.gmail.com>
Date: Fri, 15 Jun 2007 19:52:22 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rob Landley" <rob@landley.net>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <orodjgvm5v.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr>
	 <20070614122031.4751a52b@the-village.bc.nu>
	 <20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net>
	 <20070615120926.GD6269@elte.hu>
	 <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <7b69d1470706151503v23253546w5648f04673741c8f@mail.gmail.com>
	 <orodjgvm5v.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> On Jun 15, 2007, "Scott Preece" <sepreece@gmail.com> wrote:
>
> >> That's not true.  They can just as well throw the key away and refrain
> >> from modifying the installed software behind the users' back.
>
> > This characterization misses something important.  For many product
> > devices, like cell phones, the modification is never "behind the
> > user's back"
>
> Okay, take out the "behind the users' back", it makes no difference.
> That was just to highlight the frequent evil intentions behind keeping
> the keys.
---

Yes, but in highlighting the possibility of evil intentions you
distort the fact that usually there are no such evil intentions...

---
>
> I wonder if giving half the key to the user and keeping the other half
> would be enough to satisfy the GPLv3 language while still enabling the
> vendor and user to update the software together.
---

I think that's a possibility. I don't see how it's functionally
different from the usual case where the manufacturer can't modify the
device without the user's consent simply because the user has physical
access to the device and the manufacturer doesn't.

---
>
> > The FSF's approval of this distinction (ROM versus replaceable) places
> > the FSF's particular principles over users interests, for no
> > particular reason
>
> Over *users* interest?  How so?
---

Users benefit from the ability to get software updates, from the
manufacturer, to resolve problems, fix security vulnerabilities, and
provide updated functionality.

---
>
> > if the manufacturer believes that it cannot legally allow software
> > modification, all the restriction does is force them either to make
> > the software unmodifiable (which advances freedom not at all) or to
> > use software under a different license (which advances freedom not
> > at all).
>
> Right.
>
>
> But if the manufacturer believes that it can legally allow it, and
> wants to be able to install, software modifications, then it must
> decide between giving that up and letting the user do it as well.  And
> this is where the users interests may prevail.
---

You're harping on the "cannot legally", which is fine but irrelevant.
Whether it's a legal requirement or a business decision, the result is
the same - neither forcing the manufacturer to make the device
non-updatable nor forcing the manufacturer to use different software
benefits anyone. I don't know of interesting cases where the
manufacturer makes the device non-modifiable out of sheer
bloody-mindedness.

I don't believe that the existence of this clause will lead to more
manufacturers making their devices modifiable - there are too many
other options if they think that non-modifiability is important to
them.

[Note that I *do* think it's perfectly appropriate that authors who
feel that they don't want their work used in such devices should be
able to license them in line with that belief. I just don't think it
has any practical value aside from making them feel better.]

scott
