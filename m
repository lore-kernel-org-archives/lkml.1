Return-Path: <linux-kernel-owner+w=401wt.eu-S1762529AbXEQUaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbXEQUaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761622AbXEQU3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:29:40 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:28544 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761516AbXEQU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SBHKJZlyPBz6O7WU8FjgG8cEqrkz5Dp6lH471IRGJ1Si0KjNhrFRs1bnGqcZ7aUhB7w9mEqW5JO24ZuedV9jFN/rH2QRw12+Cg5x8H+/1DE/3cU6Qsx3dfai7+t7vEvyBIbzLSoapCJD3/Wes/YPa0kyw88ZO+4b6TSZUuRTq3Y=
Message-ID: <b637ec0b0705171329i6da89fa8h655976e823aef41e@mail.gmail.com>
Date: Thu, 17 May 2007 22:29:38 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: radeonfb and X800 cards
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Daniel Drake" <dsd@gentoo.org>,
       "linux list" <linux-kernel@vger.kernel.org>, Jimmy.Jazz@gmx.net
In-Reply-To: <20070517195958.GA6489@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464BB43D.2020407@gentoo.org>
	 <1179367164.32247.256.camel@localhost.localdomain>
	 <20070517195958.GA6489@dreamland.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 5/17/07, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Il Thu, May 17, 2007 at 11:59:23AM +1000, Benjamin Herrenschmidt ha scritto:
> > On Wed, 2007-05-16 at 21:47 -0400, Daniel Drake wrote:
> > > Hi,
> > >
> > > Did anything happen to the patch titled "radeonfb: add support for newer
> > > cards"?
> > > http://lwn.net/Articles/215965/
> > >
> > > Jimmy at http://bugs.gentoo.org/174063 has extended upon this with some
> > > further fixes based on code the in X11 driver. The patches are on the
> > > bug report.
> > >
> > > Ben, where can the most up-to-date radeonfb code be found?
> >
> > upstream. I haven't released anything else so far. Does the patch still
> > apply ?
>
> This is what I'm using here, it's still the same old patch (Solomon's
> plus my stuff). I think I can coordinate with Jimmy.Jazz@gmx.net to
> create an incremental patch to fix radeonfb on his hardware (provided
> that this mega-patch is suitable as baseline that is).
>

[long patch snipped]

Is there a reason why this patch can't go upstream?

Regards,
Fabio

> Luca
> --
> "New processes are created by other processes, just like new
>  humans. New humans are created by other humans, of course,
>  not by processes." -- Unix System Administration Handbook
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at ...
>
> [Message clipped]
