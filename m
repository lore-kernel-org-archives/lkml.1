Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZJZMMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZJZMMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 08:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZJZMMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 08:12:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:57882 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbZJZMMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 08:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FX1M3MjjjdqVis6i7BbmnGZq++doNO3N+mk0r2LBY8vBrNv8q8+OM0srldAOhoRZoh
         E2X1zNRsOcplREGC8FNgt9dXfiY/euGlvJZD637B2dV2E9sI5SMGrwpzAEqNZZlRkGor
         6d85n+JoMDur+mhjOwiO/aWrLFxeuuZi+A4u8=
MIME-Version: 1.0
In-Reply-To: <4AE4E026.9070402@mandriva.org>
References: <deaa866a0910251559r6c001e6ek553256ac8f81b1f7@mail.gmail.com>
	 <4AE4E026.9070402@mandriva.org>
Date: Mon, 26 Oct 2009 08:12:23 -0400
Message-ID: <deaa866a0910260512p1eca02f6k89aa180aec27558d@mail.gmail.com>
Subject: Re: RFC: Updating the LKML bug reporting/updating framework
From: Robert Bradbury <robert.bradbury@gmail.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, thank you for pointing this out.

I was unaware of the kernel.org bugzilla database.  Sometimes people
will go from AT&T UNIX to SGI IRIX to Linux without making a stop at
kernel.org.  If it comes on a CD and boots relatively easily people
may not bother with such details.  I think I started using Linux
around the time I started using Mosaic and that may have been before
the kernel.org site was as robust as it now appears to be (if it
existed at all).

Given the bugzilla database, is the LKML with its high volume and
noise level (IMO), now largely obsolete [1]?  (I think I a Google
search may have led me in the direction that it was the place to
report bugs).

1. Is there an lkml-interesting sublist (or do subscribers need to
make up their own filters)?

On 10/25/09, Thomas Backlund <tmb@mandriva.org> wrote:
> Robert Bradbury wrote:
>> Now, the LKML seems to to be a throwback almost to 1971 when the first
>> email messages were sent between a couple of PDP-10s.  It has patches
>> that I have no interest in, discussions I have no interest in and were
>> it not for Gmail's search function it would be generally useless (very
>> high Noise-to-Signal ratio).  Now maybe I do not understand the Linux
>> development process.  Maybe this is a "Wizard of Oz" case and there is
>> a hidden bug reporting system hidden behind the curtain -- but in
>> spite of my best efforts I cannot locate it.
>
> You didn't read http://www.kernel.org/  ??
>
> There is a nice section on the first page stating:
>
>
> Reporting Linux Kernel bugs
>
> Please see http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html
> if you want to report a Linux kernel bug. Bug reports sent to the
> kernel.org administrators will be ignored.
>
> There is now a bugzilla setup at bugzilla.kernel.org. Currently this is
> for reporting kernel version 2.6 bugs only.
>
>
> --
> Thomas
>
