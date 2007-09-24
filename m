Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbXIXSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbXIXSsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbXIXSsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:48:07 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:51167 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbXIXSsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bpaW3OlsMQ3jQDxvQZIzS9OwuGX4+Y1pN4iJ51XbbUjoi1sLyXQfDi86S60G9902ne8Q3kP/wto+bhLx2N3fXLdiDs2g18PMM51RIuMLZi9fzxus95C3bnRlWaq7UGrgU/4epLsd1wl1VAz+tGIcu2nNWDLnBzCfZxTlmEf3b2Q=
Message-ID: <64bb37e0709241148r58a99403k5f51f364de64eeb5@mail.gmail.com>
Date: Mon, 24 Sep 2007 20:48:03 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "FUJITA Tomonori" <tomof@acm.org>
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
In-Reply-To: <64bb37e0709230831t16eaa86dub5abcb97fdce12eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070921085711.GG2367@kernel.dk>
	 <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
	 <20070923225320I.tomof@acm.org>
	 <64bb37e0709230831t16eaa86dub5abcb97fdce12eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> On 9/23/07, FUJITA Tomonori <tomof@acm.org> wrote:
> > Can you try Jens's sglist-arch branch? If it works, probably libata in
> > -mm has bugs.
> >
> > For your convenience, I put a sglist-arch branch patch against v2.6.23-rc7:
> >
> > http://www.kernel.org/pub/linux/kernel/people/tomo/misc/v2.6.23-rc7-sglist-arch.diff.bz2
>
> Thanks for the patch.
> I tried it and 3 out of 3 boot attempts worked without problems.
> But I can't rule out that the bug is still there, as I have no way to
> trigger it on demand.

Short update:
2 more boots with that kernel did also work.
I have just installed 2.6.23-rc7-mm1 and booted three times.
Also no problems with that version.

I will keep on using 2.6.23-rc7-mm1 and post again, if the error shows up again.

Torsten
