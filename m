Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbXFONlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbXFONlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXFONlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:41:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:62057 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbXFONlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NalASl1yZp2YzUJPzx++00zAqFfeUJD6oKHwNDZ68fbSVy+vL1Dk3hKFCzgGqhG+DxpBzyyQ3WxwWc/45noR7SSEm//LrKiTxeNheoGWY0ALjPqIXTqtX0o9qjptJ381Nt5id2Q8itk0tz8KLt4sVCDQ8Fj/t287RyPM1zP5o8g=
Message-ID: <9a8748490706150641s4669c7ffrb64e1f0b92e5c931@mail.gmail.com>
Date: Fri, 15 Jun 2007 15:41:04 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Nicolas Mailhot" <nicolas.mailhot@gmail.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Daniel Hazelton" <dhazelton@enter.net>, linux-kernel@vger.kernel.org
In-Reply-To: <52052.192.54.193.51.1181907121.squirrel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <9a8748490706150353i452cf529oc5c0e8119f91e64e@mail.gmail.com>
	 <52052.192.54.193.51.1181907121.squirrel@rousalka.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/07, Nicolas Mailhot <nicolas.mailhot@gmail.com> wrote:
>
> Le Ven 15 juin 2007 12:53, Jesper Juhl a écrit :
> > On 15/06/07, Nicolas Mailhot <nicolas.mailhot@laposte.net> wrote:
> >> >> > by your argument, the user has some "right to modify the
> >> software", on
> >> >> > that piece of hardware it bought which had free software on it,
> >> correct?
> >> >>
> >> >> Yes.  This means the hardware distributor who put the software in
> >> >> there must not place roadblocks that impede the user to get where
> >> she
> >> >> wants with the software, not that the vendor must offer the user
> >> a
> >> >> sport car to take her there.
> >>
> >> >Okay. That means that if I ship Linux on a ROM chip I have to
> >> somehow
> >> make
> >> >it so that the person purchasing the chip can modify the copy of
> >> Linux
> >> >installed on the chip *if* I want to follow both the spirit and the
> >> letter
> >> >of the GPLv2.
> >>
> >> The key word there is "can"
> >>
> >> You don't have to send the buyer the hardware design, replace the
> >> ROM
> >> with a flash, use a rom socket that allows easy switching etc.
> >>
> >> But you can not add measures to your hardware specifically designed
> >> to
> >> stop the user from modifying the GPL software part. Especially if
> >> those measures are something like DRM that do not make the tinkering
> >> just technically hard, but legally forbidden.
> >>
> >> As long as the restrictions result from technical choices not
> >> targetted at forbidding changes you're ok.
> >>
> > That's simply not true.
> >
> > As long as you get a copy of the source code for the software that's
> > running on the hardware it's OK. That's all the GPLv2 says.
>
> You'll note I was answering to a message about what the GPL intended,
> not the strict literal reading of the GPLv2 words.
>
> And what the GPL authors intended is obvious from the fact it all
> started with a printer driver and the need to change the software used
> to control this particular hardware (not some mythical other device
> without manufacturer restrictions
>
But the only thing that *actually* matters is what the license text
*says*. It doesn't matter what the authors of the license text
intended - if they intended something else than what they actually
wrote in the license text, then they made a mistake, but that's their
problem. And what is actually in the license text is obviously what
some other people (like Linus for instance) want, so for those people
the GPLv2 is a perfectly fine license that doesn't need to be fixed
because it says exactely what they want it to say.

You can talk all you want about the spirit of the license but that
will never change the fact that it's the actual text of the license
that matters in the end.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
