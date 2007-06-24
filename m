Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbXFXWsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbXFXWsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXFXWsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:48:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:46705 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXFXWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:48:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kNL++SmJDAPTr1jycaU0tT7wVKrbuQeseuGO9tcNgfbRV8o07MiimjC3kQv0tfRKxcVdRRbhcsgooj12382HksJ2GxeRwHoOaazNYSVo+/5XDOn+bQmVHviDxx7fSWh+2ejP8WB0ArbGgoJuwW/qVLhFe7B+LSfYG1vXmALV/Ro=
Message-ID: <9a8748490706241548r5a2bab5fw20daf424beb338d0@mail.gmail.com>
Date: Mon, 25 Jun 2007 00:48:45 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Carlo Wood" <carlo@alinoe.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "=?ISO-8859-2?Q?Tomasz_K=B3oczko?=" <kloczek@rudy.mif.pg.gda.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <20070624224411.GB21724@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
	 <20070624200837.16e11305@the-village.bc.nu>
	 <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
	 <20070624215724.025a5de5@the-village.bc.nu>
	 <20070624224411.GB21724@alinoe.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/07, Carlo Wood <carlo@alinoe.com> wrote:
> On Sun, Jun 24, 2007 at 09:57:24PM +0100, Alan Cox wrote:
> > > Sory Alan but I don't want philosophical/historical discuss.
> > > Try to answer on question "ALSA or OSS ?" using *only* technical arguments.
> >
> > We dropped OSS for ALSA for technical reasons. Those being that ALSA
> > - has a better audio API
> > - is more flexible
> > - provides OSS as emulation
> > - supports more hardware
>
> I sent a patch to the ALSA developers 4 years ago.
> It was never included in the kernel :/
>
Did you try resending it?
Sometimes patches get missed, overlooked, dropped on the floor by mistake etc.

[snip]
>
> My (four year old) patch can be found here:
>
> http://www.xs4all.nl/~carlo17/alsa/index.html
>
> I STILL think that ALSA should restart the stream after an underrun,
> but I am not someone who asks twice :p usually.
>
When it comes to getting patches into mainline, asking twice (or more)
is sometimes required, and it's considered your responsability as
submitter to resend a patch if noone reacts to it the first time
around.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
