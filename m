Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbXHNELY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbXHNELY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXHNELK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:11:10 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:61978 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbXHNELI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nypy5fFT0ZVEh5E3sD1Byfj3FaZVvSUVl4UWBe+ARm5BIOP4wZQiol1ZDIVExuO5seVqiO4ggNJwzDO9CgccsnHZ3Ewsl/amyNkTZ0aoupFmiSMT9/1RygqsehG2N9+uxOkzG9ypvvXDRBeH3/sapMyT8y9mgrdKpTyRiT9pgKs=
Message-ID: <8bd0f97a0708132111w25b39901p2eec57125bb03920@mail.gmail.com>
Date: Tue, 14 Aug 2007 00:11:07 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: Bad addresses in MAINTAINERS
Cc: "Joe Perches" <joe@perches.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200708132354.22273.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187032024.10249.266.camel@localhost>
	 <1187032769.10249.270.camel@localhost>
	 <8bd0f97a0708131256r447890c8q4848b333cf23d4f0@mail.gmail.com>
	 <200708132354.22273.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Mon 13 Aug 2007 15:56, Mike Frysinger pondered:
> > On 8/13/07, Joe Perches <joe@perches.com> wrote:
> > > On Mon, 2007-08-13 at 15:10 -0400, Mike Frysinger wrote:
> > > > On 8/13/07, Joe Perches <joe@perches.com> wrote:
> > > > > But if anyone has a new email address and still wants
> > > > > to be in the maintainers file, please send.
> > > > >
> > > > > BLACKFIN ARCHITECTURE
> > > > > P:      Aubrey Li
> > > > > M:      aubrey.li@analog.com
> > > > > P:      Jerry Zeng
> > > > > M:      jerry.zeng@analog.com
> > > >
> > > > we know these guys needed to be removed as they've recently left ADI,
> > > > we just havent pushed to mainline
> > >
> > > Maybe you can have a "blackfin_arch@analog.com" list as maintainers?
> >
> > we have a mailing list already ... could just drop the general list of
> > people for Blackfin and keep specific e-mails for specific drivers
>
> There is a public mailing list - but it is closed - must be subscribed to post
> (cuts down on spam), and I thought the requirement was to have these be open
> lists?

many other people do the same ... just a subscriber list

but ours is more open -- we moderate e-mails, they dont get flat out rejected ;)
-mike
