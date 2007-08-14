Return-Path: <linux-kernel-owner+w=401wt.eu-S933080AbXHNE6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbXHNE6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761736AbXHNE6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:58:18 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:25836 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbXHNE6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iuLSGSFs5hgYbcZ8NThOdEAG4TK3ELsIsKef31o/l7LOevaQ7p7+7bVasxZXrMes+7IgN2aB8g4kRLA5R8w8c2TFsS0UcNzb65AviCB0bJUFgZHf9/QQ1UwlniaYNjwvHNgfzu7L/WFPS9wp/YEDIsclAN3Ip1QYQW/Uorqqlhg=
Message-ID: <8bd0f97a0708132158r764ce172g2c8302fa6e72e8d3@mail.gmail.com>
Date: Tue, 14 Aug 2007 00:58:14 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: Bad addresses in MAINTAINERS
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, "Joe Perches" <joe@perches.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1187064764.21177.20.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187032024.10249.266.camel@localhost>
	 <1187032769.10249.270.camel@localhost>
	 <8bd0f97a0708131256r447890c8q4848b333cf23d4f0@mail.gmail.com>
	 <200708132354.22273.rgetz@blackfin.uclinux.org>
	 <1187064764.21177.20.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/07, Bryan Wu <bryan.wu@analog.com> wrote:
> On Mon, 2007-08-13 at 23:54 -0400, Robin Getz wrote:
> > On Mon 13 Aug 2007 15:56, Mike Frysinger pondered:
> > > On 8/13/07, Joe Perches <joe@perches.com> wrote:
> > > > On Mon, 2007-08-13 at 15:10 -0400, Mike Frysinger wrote:
> > > > > On 8/13/07, Joe Perches <joe@perches.com> wrote:
> > > > > > But if anyone has a new email address and still wants
> > > > > > to be in the maintainers file, please send.
> > > > > >
> > > > > > BLACKFIN ARCHITECTURE
> > > > > > P:      Aubrey Li
> > > > > > M:      aubrey.li@analog.com
> > > > > > P:      Jerry Zeng
> > > > > > M:      jerry.zeng@analog.com
> > > > >
> > > > > we know these guys needed to be removed as they've recently left ADI,
> > > > > we just havent pushed to mainline
> > > >
> > > > Maybe you can have a "blackfin_arch@analog.com" list as maintainers?
> > >
> > > we have a mailing list already ... could just drop the general list of
> > > people for Blackfin and keep specific e-mails for specific drivers
> >
> > There is a public mailing list - but it is closed - must be subscribed to post
> > (cuts down on spam), and I thought the requirement was to have these be open
> > lists?
>
> Yes, open a public mailing list is a good choice to replace the whole
> team member list.

something@analog.com would not be an open public mailing list, it'd be
a private alias that only ADI people can subscribe to.  what we have
now (uclinux-dist-devel@blackfin.uclinux.org) is best i think:
[quickly] moderated for non-subscribers, open subscription, no spam.
-mike
