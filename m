Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbXFOWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbXFOWDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbXFOWDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:03:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:40418 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbXFOWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kSAQat/nTGLv7x+BXmUvoU2cfIzb2PMZlSPHQYDlz72e4mV9mzDchSSfwXnPWuRcFtwcxMfA0N8JwXZ8X6KwY/QRJPU74NteGnZXjDm/H4xDFkQGhv4+IcLh9SGZkHCS3FVk2/B7dJXWR5HADltIjoQLTwJ9yiVGRL7F7URNbYA=
Message-ID: <7b69d1470706151503v23253546w5648f04673741c8f@mail.gmail.com>
Date: Fri, 15 Jun 2007 17:03:07 -0500
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
In-Reply-To: <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr>
	 <20070614122031.4751a52b@the-village.bc.nu>
	 <20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net>
	 <20070615120926.GD6269@elte.hu>
	 <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:
>
> > it irreversibly cuts off certain people from being to distribute
> > GPLv3-ed software alongside with certain types of hardware that the
> > FSF's president does not like.
>
> That's not true.  They can just as well throw the key away and refrain
> from modifying the installed software behind the users' back.
---

This characterization misses something important.  For many product
devices, like cell phones, the modification is never "behind the
user's back", but is done because the user has requested it (to fix a
problem or add a new feature). If you go to ROM-based software, the
user loses, because problems can't be fixed. For certain kinds of
problems the user might be able to get a replacement device, but
potentially involving losing any data stored on the device.

The FSF's approval of this distinction (ROM versus replaceable) places
the FSF's particular principles over users interests, for no
particular reason - if the manufacturer believes that it cannot
legally allow software modification, all the restriction does is force
them either to make the software unmodifiable (which advances freedom
not at all) or to use software under a different license (which
advances freedom not at all). The result? The user STILL has no
freedom to modify the software and the community around the software
is diminished.

To go back to the "behind your back" claim, the only cases I know
where the software is replaced behind the users' back are cases were
the updates are done by a service (usually not operated by the device
manufacturer) that the user has voluntarily requested (like TiVo
program guides or cable system subscriptions), which is generally a
cases outside the scope of the license in any case.

scott
