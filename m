Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbXBPFsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbXBPFsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbXBPFsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:48:45 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:20865 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbXBPFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:48:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r6mnDd0VvY5u4x4AozFUmzJ0q9lk7wHkLtpY0nDY5hPACFBWAJBIKF5YBeeWOKupC8gZtHSz1aGHoPA2lfLtE8ZPTdfPTGnGsG/pWvbLQhAq2wUrJe23SM8RQ4RI8x6fLZeUOhLxEkhgm1/0y6jL1hxY7YsCg1kYo6gGo0rn74o=
Message-ID: <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com>
Date: Thu, 15 Feb 2007 21:48:43 -0800
From: "v j" <vj.linux@gmail.com>
To: "David Lang" <david.lang@digitalinsight.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Scott Preece" <sepreece@gmail.com>, "Miguel Ojeda" <maxextreme@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com>
	 <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com>
	 <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > So, how are such companies any different from the myriad individuals
> > and companies that use Linux on the desktop or in their server rooms
> > without ever modifying it and who also contribute nothing back to the
> > community? They are also, in many (most?) cases taking advantage of
> > the free (as in beer) nature of Linux - saving money by using the work
> > of others without returning anything, but the product builders seem to
> > get a lot more abuse...
>
> if they don't modify it and don't distribute it there is not issue.

This is only because of the terms of GPL. Morally, as many here have
pointed out this should fall into the same category.

> it's people who modify it (by creating a derived work) and then redistribute it
> that get the abuse.

Atleast we try and report genuine bugs and submit patches when
necessary. We get abuse however because it is not clear what the terms
of GPL are WRT loadable modules. If this were written in black and
white and we knew what we were fighting against, this would not be an
issue. We only get crap because no one here yet knows how to interpret
proprietary modules loaded into the kernel.
