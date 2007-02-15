Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbXBOMwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbXBOMwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 07:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932348AbXBOMwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 07:52:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:11362 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbXBOMv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 07:51:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TmftVqjCUzZOFK226rAzcCwKHRJar+cdSO7SFDWi9lWAeavZOujQ9zJqotqj3393x1DWvtwWVQ2kZNkMClEfNPqztC+3Mc3s3e48xNESxcb2fHkInlVaKQ5aAs4F/kxo06eNsSep8C/xUQNTW4VvXhxrtV5k47ABtAuIG3SnSDA=
Message-ID: <1a297b360702150451n3dca1140ra6827cfde020eed5@mail.gmail.com>
Date: Thu, 15 Feb 2007 16:51:57 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: Mws <mws@twisted-brains.org>
Subject: Re: GPL vs non-GPL device drivers
Cc: "v j" <vj.linux@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200702151254.39058.mws@twisted-brains.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <200702151254.39058.mws@twisted-brains.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Mws <mws@twisted-brains.org> wrote:
> hi vj,
>
> On Thursday 15 February 2007, v j wrote:
> > This is in reference to the following thread:
> >
> > http://lkml.org/lkml/2006/12/14/63
> >
> > I am not sure if this is ever addressed in LKML, but linux is _very_
> > popular in the embedded space. We (an embedded vendor) chose Linux 3
> > years back because of its lack of royalty model, robustness and
> > availability of infinite number of open-source tools.
> >
> > We recently decided to move to Linux 2.6 for our next product, mainly
> > because Linux has worked so well for us in the past, and we would like
> > to move up to keep up with the latest and greatest.
>
> you choose to move to linux 2.6 for your next product - fine.
> it has worked for you well in the past - fine.
> you would like to keep along with the latest and greatest - fine.
>
> _but_
>
> for all those reasons you have to get along with all rules, licenses and
> at least all changes that the kernel community decided to perform.
>
> > However in moving to  2.6, we noticed a number of alarming things.
> > Porting drivers over from devfs to udev, though easy raised a number
> > of alarming issues. Driver's no longer could dynamically allocate
> > their MAJOR/MINOR numbers. Doing so would mean they would have to use
> > sysfs. However it seems that sysfs (and the class_ interface) is only
> > available to GPL modules. This is very concerning. The drivers which
> > we have written over the last three years are suddenly under threat.
> > We don't mind statically assigning MAJOR/MINOR numbers to our drivers.
> > We can do this and modify our user space applications too.
> >
> > However we have a worrying trend here. If at some point it becomes
> > illegal to load our modules into the linux kernel, then it is
> > unacceptable to us. We would have been better off choosing VxWorks or
> > OSE 3 years ago when we made an OS choice. The fact that Linux is
> > becoming more and more closed is very very alarming.
>
> the trend is not worrying. we are not responsible for your decisions you made
> in the past.
> the only real FACT is that linux is being stated to BE OPEN and what is much more
> important to STAY OPEN for everybody.
>
> you chose it years ago, because of those facts. of course linux is very popular on
> embedded systems. i am working within some open source projects that also run
> on embedded hardware designs.
>
> your main mistake in understanding linux and our way to have it also more open in
> future than by now.
>
> what actually costs you more in future?
> opening your drivers, as much it must be, to have your hardware supported under 2.6
> _or_
> paying license fees for runtime/development tools for vxworks, ose whatever?


marcel,

most of the vendors, who claim IP just cite nonsense. There are really
hardly a few vendors who are really bound to the IP issue. Just that
they do not know how to write proper code, they do not want to open up
their code.

In fact , such vendors do have a think probably like this "if we open
up our driver if people see the pathetic quality, the customers would
probably think how bad is the hardware and probably affect our sales"
. So it would be better if we hide under the shade of the IP umbrella.

Little do that these vendors know that customers wouldn't want to go
alongwith such narrow minded vendors in the long run. But somehow due
to a certain void people do the get along, that's it, not for long
though.

regards,
manu
