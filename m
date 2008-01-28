Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYA1Kk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYA1Kk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYA1Kkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:40:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:24407 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYA1Kkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RZLN6+A3ikkiBuu1tXgROQ2DkM5V8QVP+9TZ2gS3jiYOSlPuN0tFhi9O8RhW8jPUbtHp8d+097rx6dKEe4DAg0kY0kNW5cdSfBMgR4KjH442Q9Xv3DCvAwaSBrlBIzc+O6wjJgcQLgqNtYfnYRhB9OOX1MzFiZiDzDTwfq0oMto=
Message-ID: <38b2ab8a0801280240j7826470haf2b32541d739cf0@mail.gmail.com>
Date: Mon, 28 Jan 2008 11:40:41 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: Question about DMA
Cc: "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <20080128112945.401d8a45@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>
	 <479D06E0.3090601@gmail.com>
	 <38b2ab8a0801280055j6d1d235boe79e6aea058f8f96@mail.gmail.com>
	 <20080128102149.545c0619@dhcp-252-066.norway.atmel.com>
	 <38b2ab8a0801280222m3aadc1b1t792165174733b04d@mail.gmail.com>
	 <20080128112945.401d8a45@dhcp-252-066.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Paul in CC ]

On Jan 28, 2008 11:29 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> On Mon, 28 Jan 2008 11:22:49 +0100
> "Francis Moreau" <francis.moro@gmail.com> wrote:
>
> > > Please let me know if you think this will work for your hardware.
> >
> > Thanks for pointing this out. I currently can't look at this but I'll
> > try to give it
> > a deep look this week.
>
> Great. I'll Cc you on the next round of patches.
>
> > > What platform are you working on, btw?
> > >
> >
> > SH
>
> Nice. That means we have potential users on three different
> architectures (the other two being avr32 and arm; I wouldn't be too
> surprised if powerpc and mips want a piece of the fun at some point
> too.)
>

I think it's worth to CC Paul as well. He plans to move SH architecture to
use the dmaengine API soon, and he's definitively the right person who
can give you some useful feedbacks from SH architecture.

-- 
Francis
