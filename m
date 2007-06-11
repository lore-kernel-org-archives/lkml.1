Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXFKWSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXFKWSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXFKWRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:17:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:60205 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbXFKWRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:17:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XjCPqdrkIGtvgF/7hXr0sw1751+iD3lHsSULEhPYLmbOvdoGhxHZ2DpckN68DyLzTGMQtqosTFfvO5rypB5OG6f9zJrRibKvVUSg+o+/i3W6qwhT5WQ5TJHUruD0yEOAQ94dWnYpL/3EHEKSPJW3ySV5mK0i3zGDn8Y7gXp8H/A=
Message-ID: <cab9a6fd0706111517i4dd4e3bdu6664e4b684b95e48@mail.gmail.com>
Date: Mon, 11 Jun 2007 23:17:52 +0100
From: "Miguel Pais" <miguelpais@gmail.com>
To: "Miguel Figueiredo" <elmig@debianpt.org>
Subject: Re: 2.6.22-rc4-ck1 - Re: -ck patch | Feedback
Cc: Celso <celsopr@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <466C76B9.7010404@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1181341039.28846.0.camel@localhost>
	 <466A7321.4060304@debianpt.org> <1181494360.4026.10.camel@localhost>
	 <466C76B9.7010404@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

After a lot of good feedback about the -ck patch from Celso Ramos, I
decided to try my chances and see for myself the difference.
I had a few problems to struggle first, but nothing to do with ck...

When I finally rebooted my Pentium4 computer, I truly noticed a
difference in the loading time of the operating system. I can be
mistaken, but it appeared to me a gain of 1,50 % of the loading speed.

On a graphic environment the changes are more difficult to notice, and
I may be wrong if I say it's faster, just because I'm expecting to see
speed improvements.

By the way, I'm using it on a  2.6.21 kernel.

Many thanks to the developers,
Miguel Pais

On 6/10/07, Miguel Figueiredo <elmig@debianpt.org> wrote:
> Celso wrote:
> > Sáb, 2007-06-09 às 10:30 +0100, Miguel Figueiredo escreveu:
> >> Celso wrote:
> >>> Hello, I'm using -ck since... along time ago (I start using it with the
> >>> kernel 2.6.16) . I started using it with Ubuntu and  the response of the
> >>> system  was better. Since that I always compile my kernels with -ck.
> >>> Actually I use 2.6.20-ck1 and I have no problems, even with things that
> >>> needs kernel-sources like gspca for my webcam.
> >>>
> >>> Thanks a lot for the patches.
> >>>
> >>> PS: when will this go into the official kernel?
> >>>
> >> Hi there,
> >>
> >>   have you tryied a newer kernel with -ck2 [1] ?
> >>
> >> I am also using a -ck patch, 2.6.21-ck2, mostly on 2 machines where i
> >> use as desktop and also play games. With -ck2 the experience seems less
> >> slugish and more smooth while playing 'second life' and have a bunch of
> >> other programs open (mail, a zillion web pages, irc client, feed reader,
> >> consoles, ...).
> >> The desktop seems more confortable to use than with the vanilla kernel.
> >> I also tryed cfs, it's also much better than the vanilla kernel but i
> >> still prefer -ck2 for playing second life as it feels more responsive.
> >>
> >>
> >> If you try the -ck2 or SD 1.0 please report your experience. It's nice
> >> to hear that people are testing/using these improvements on desktop usage.
> >>
> >>
> >>
> >> 1 - ck2 patch to add to vanilla 2.6.21,
> >> http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-ck2/patch-2.6.21-ck2.bz2
> >>
> >> PS: I remember i read somewhere that the SD patch (included in -ck) has
> >> became stable (version 1.0) with a few small improvements!
> >>
> >
> > Well, I upgrade to 2.6.21-ck2 and install it on my two pcs (I had before
> > 2.6.20-ck1 on both) and the installation work, like always, fine. No
> > problems. On the pc I use most (the better one :) ) I didn't feel much
> > difference from 2.6.20-ck1 to 2.6.21-ck2 (for regular Desktop use), but
> > in the older pc, where my brother works, he says that was even more
> > "fluid"*.
> >
> > * direct translation sorry if it doesn't sound well
> >
>
> I don't know if there is an official announcement of patch releases but
> today i spotted and started to use the new 2.6.22-rc4-ck1.
>
> The list of patches included on 2.6.22-rc4-ck1 it's on
> http://ck.kolivas.org/patches/pre-releases/2.6.22-rc4/2.6.22-rc4-ck1/patches/
>
> It's working...
>
>
> --
>
> Com os melhores cumprimentos/Best regards,
>
> Miguel Figueiredo
> http://www.DebianPT.org
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
