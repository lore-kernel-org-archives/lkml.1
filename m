Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbXBWVNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbXBWVNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932767AbXBWVNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:13:24 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59460 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbXBWVNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:13:20 -0500
X-AuditID: d80ac21c-9419bbb000007de4-60-45df58f02618 
Date: Fri, 23 Feb 2007 21:13:23 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Chris Wright <chrisw@sous-sol.org>
cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/18] 2.6.18-stable review
In-Reply-To: <20070223203430.GR10574@sequoia.sous-sol.org>
Message-ID: <Pine.LNX.4.64.0702232110170.9182@blonde.wat.veritas.com>
References: <20070221014927.GA3684@kroah.com> <Pine.LNX.4.64.0702232000550.5954@blonde.wat.veritas.com>
 <20070223203430.GR10574@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 23 Feb 2007 21:13:20.0102 (UTC) FILETIME=[71972860:01C7578F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Chris Wright wrote:
> * Hugh Dickins (hugh@veritas.com) wrote:
> > 
> > There's two from 2.6.19-stable that I thought Chris had agreed
> > for 2.6.18-stable (Linus' mincore and my read_zero_pagealigned);
> > two that I sent Chris cc stable for 2.6.18-stable on 4th January
> > (msync and powerpc current); one I know about from 2.6.19-stable
> > equally desirable in 2.6.18-stable (Badari's shmem_truncate); and
> > a new one I was waiting to appear in 2.6.21-rc1 before sending
> > (Tigran's extN noacl umask).
> 
> Yes, you're right.  I've got the first five here, will get those
> sorted shortly.

Okay, thanks a lot Chris, I'll minimize the noise and stick to
just sending the .18 .19 .20 versions of the last one (umask).

Hugh
