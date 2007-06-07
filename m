Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbXFGRha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbXFGRha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760781AbXFGRhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:37:23 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:24379 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760834AbXFGRhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ToRQseaGLUhxeepiNCmDHCA4zVRDI/MIGlTBpyeoiajWofe/zkiAPZEihFjl1V7zebqVlXiBSb6W34E1db+kZ3u1FngzvybHDup0RAOWIcUa/FDvfy0z111+/jJHuBW5tYOWNV9Pm9pQZwWSpitVFHZH2LevSHDHib7r6NJkQ3g=
Message-ID: <f4527be0706071037l5278fe61v1a733ab874aec136@mail.gmail.com>
Date: Thu, 7 Jun 2007 18:37:21 +0100
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: "Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
In-Reply-To: <46682FED.2080506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.58.0706061356310.2657@be1.lrz>
	 <20070606143723.GF10008@csclub.uwaterloo.ca>
	 <46673135.30105@zytor.com>
	 <f4527be0706061541ifd49a8fg60442532d72f1d06@mail.gmail.com>
	 <46682FED.2080506@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Andrew Lyon wrote:
> >
> > Could this also cause a system to be unstable? my abit athlon64 at
> > work will not run x64 with more than 1gb ram, and i have a colo server
> > with supermicro & 2 x dual core xeons that will not run with more than
> > 2gb.
> >
> > Both systems have long uptimes but if i add ram they crash within
> > minutes of booting.
> >
>
> That's much more likely to be caused by bad memory bus layout so that it
> doesn't handle the higher loading.
>
> Run memtest86+ on the expanded memory for some time.
>
>         -hpa
>

I have run memtest86+ for days at a time on both systems with no errors at all.

broken hardware i guess, i am not surprised about the abit board, ive
had nothing but trouble with abit motherboards and do not use them any
more, but the supermicro is a xeon server board and i was using
kingston ram, i wouldnt expect that to have issues.

latest bios on both.

Andy
