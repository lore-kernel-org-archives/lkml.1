Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbXKME2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbXKME2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbXKME2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:28:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:34624 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbXKME2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:28:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m/8yLo5Amx2iY00iTNKViN2H3zm7RBnXJwyfvR6UrpukK6acOh3HSBI44FtW0gCXIzdDyzITev0P2Qn7PkdLfMZMh4MOVuPqTIG8njhxuDhZZ4Kfglg7oc9aCMEIud2V9V6iVHW1dBzDXn8ZcSvn4jy2PSrdkps4TTHvgQkGyLw=
Message-ID: <aa79d98a0711122028o506c9642j6ebee8252a97e543@mail.gmail.com>
Date: Tue, 13 Nov 2007 07:28:23 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 1/1] [IA32-EMU] Remove trailing spaces
Cc: "David Miller" <davem@davemloft.net>, tglx@linutronix.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200711130008.34311.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711122201.45269.ak@suse.de> <200711122355.55314.ak@suse.de>
	 <20071112.145921.193112020.davem@davemloft.net>
	 <200711130008.34311.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is just an addition to second one. So if you dont like it -
just drop it, if it do conflict with other patches - just drop it.
That simple :) what is the benefit of removing spaces? "try to keep
your code clean" i've read somwhere...

On 11/13/07, Andi Kleen <ak@suse.de> wrote:
> On Monday 12 November 2007 23:59:21 David Miller wrote:
> > From: Andi Kleen <ak@suse.de>
> > Date: Mon, 12 Nov 2007 23:55:54 +0100
> >
> > > Sure, it's likely not your time that will be wasted.
> >
> > I have to respin in excess of 800 networking patches at a time due to
> > these kinds of things.  It's absolutely trivial, whether by hand
> > or using tool options that help you with this kind of task.
>
> Sure, but what benefit did it have?
>
> Could you have done something more useful in the time you needed to
> write the scripts for that?
>
> Also it's not only my time -- there are a lot of people who have x86
> patches. e.g. if 20 people have patches and they need half an hour
> each to write and test and apply scripts for that we're talking about more
> than a man-day overall wasted.
>
> > Suck it up Andi.
>
> Well it just seems a dumb thing to do and I like to complain about dumb
> things.
> Sorry that you are more generous about wasting other people's time.
>
> The end white space tends to disappear over time anyways because
> it is filtered out on everything new, but bulk changing it on old
> unchanged code is not a good idea.
>
> -Andi (who will shut up because he's approaching the half hour limit
> for such silly topics. At least it was only me and you though, not 20
> people)
>
