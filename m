Return-Path: <linux-kernel-owner+w=401wt.eu-S934302AbXK3LhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302AbXK3LhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbXK3Lgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:36:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:8696 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbXK3Lgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:36:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eSssJd16R3pUoZNCfmAw5IwlGz/cyQhxdWKmVqFhv7GsSFG7P/aWa8Qt1+MUZ2BLz6rqlWTBrFgL8Sio1abpDIgmKiz2HmX3Qnt7/z/kAcNOrSMGBTIDSkzaDNjIhukZhBKaac9DRN9ZH/mJIcasmrxuFQDUg5pix6WQmy79Z2k=
Message-ID: <ea9232d10711300336m24cabafbk18a8b131f561348a@mail.gmail.com>
Date: Fri, 30 Nov 2007 12:36:49 +0100
From: "Karol Swietlicki" <magotari@gmail.com>
To: Ben.Crowhurst@stellatravel.co.uk
Subject: Re: Kernel Development & Objective-C
Cc: loic.grenie@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <474FF0FE.50208@stellatravel.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <474EAD18.6040408@stellatravel.co.uk>
	 <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
	 <474FF0FE.50208@stellatravel.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/11/2007, Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk> wrote:
> Loïc Grenié wrote:
> > 2007/11/29, Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>:
> >
> >> Has Objective-C ever been considered for kernel development?
> >>

<snip>

> >     Lots of people will think of better reasons why ObjC is not used...
> >
> >         Loïc Grenié
> >
> Which I'm looking forward to hear :)
>
> Thank you for your appropriate response.

Here are a few reasons off the top of my head:
1. Adding extra unneeded complexity. Debugging would be harder.
2. Not many people can code ObjC when compared to the number of C coders.
3. If it ain't broken... Why fix it. The kernel works, right? Good.

You can find a great explanation somewhere out there, I'm not sure who
wrote it and the thing was explaining why C++ is not a great choice
for the Linux kernel. Some things going against C++ will also go
against ObjC. I cannot find it, but it is out there somewhere.

I'm a newbie and I might be wrong, but the above is what I believe to be true.

Karol Swietlicki
