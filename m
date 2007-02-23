Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbXBWUlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbXBWUlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXBWUlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:41:53 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44350 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933203AbXBWUlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:41:52 -0500
Date: Fri, 23 Feb 2007 12:34:30 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/18] 2.6.18-stable review
Message-ID: <20070223203430.GR10574@sequoia.sous-sol.org>
References: <20070221014927.GA3684@kroah.com> <Pine.LNX.4.64.0702232000550.5954@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702232000550.5954@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins (hugh@veritas.com) wrote:
> On Tue, 20 Feb 2007, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.18.8 release.
> > 
> > This will be the last release of the 2.6.18-stable series, so if there
> > are patches that you feel should be applied to that tree, please let me
> > know.
> > 
> > Responses should be made by Friday February 23 00:00 UTC.  Anything
> > received after that time might be too late.
> 
> Sorry I'm late to the party, just climbed through 2000 mails.
> 
> I do hope you'll manage an -rc2,
> I seem not the only one to notice wanted patches missing.
> 
> There's two from 2.6.19-stable that I thought Chris had agreed
> for 2.6.18-stable (Linus' mincore and my read_zero_pagealigned);
> two that I sent Chris cc stable for 2.6.18-stable on 4th January
> (msync and powerpc current); one I know about from 2.6.19-stable
> equally desirable in 2.6.18-stable (Badari's shmem_truncate); and
> a new one I was waiting to appear in 2.6.21-rc1 before sending
> (Tigran's extN noacl umask).

Yes, you're right.  I've got the first five here, will get those
sorted shortly.

thanks,
-chris
