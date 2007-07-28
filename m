Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbXG1QVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbXG1QVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXG1QVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:21:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:10199 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXG1QVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lG+sjZzfMjp7rKdDLMqx6LTQI1IK+7DeduDT0s1xictubLDwd+BEJYOLPUEbZEDsycLuin9ajRUDTWmfVnkFfcXWu6bHoxRbUswKrBgbw1pczcnuT2El2bogh/WzlSWX68afL170b8Eb2N/2euIR++A3gzlUCDfNMVl00nhBdtU=
Message-ID: <6bffcb0e0707280921v7a4d5f5ah7cf9d32eeca80aa9@mail.gmail.com>
Date: Sat, 28 Jul 2007 18:21:43 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Reporting bugs (was Re: [ck] Re: Linus 2.6.23-rc1)
Cc: "Martin Steigerwald" <Martin@lichtvoll.de>, ck@vds.kolivas.org,
       "Matthew Hawkins" <darthmdh@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46AB6A83.1060205@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
	 <b21f8390707280036m6781856ckb64b5f10d2295fa5@mail.gmail.com>
	 <200707281240.42308.Martin@lichtvoll.de>
	 <46AB6A83.1060205@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 28/07/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Martin Steigerwald wrote:
> > There are just about 9000 bugs in the kernel bugtracker and about 150000
> > bugs in the KDE bugtracker. Granted KDE bugtracker includes a lot of
> > applications, but still I think the number of bug reports in the kernel
> > bugtracker is ridicolously low. And I think thats because many users
> > don't bother to report bugs upstream for the Linux kernel, not because
> > that those bugs aren't there.
> >
> > I hope that the ck mailing list community will continue to be active and
> > possibly try to get swap prefetch and some other goodies of the ck
> > patchset into mainline. And I think it would also be a good idea for ck
> > mailing list community to report desktop related issues in the kernel
> > bugtracker. I think I will take the courage next time I find anything,
> > and report it straight there.
>
> A word of caution about bugzilla.kernel.org, to those who don't know
> already:  By far not all maintainers and developers use bugzilla.
> I don't know for which subsystems it makes sense to file a report in
> bugzilla.  I think your best bet is to report at the mailinglists
> listed in linux/MAINTAINERS.

Please CC all bug reports to LKML. I've got a large mailbox, but I
don't want to subscribe all linux-* mailing lists :).

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
