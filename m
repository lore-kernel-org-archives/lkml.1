Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbXBWUVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbXBWUVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932689AbXBWUVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:21:47 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:28105 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbXBWUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:21:46 -0500
X-AuditID: d80ac287-9d799bb000002978-89-45df4cd95701 
Date: Fri, 23 Feb 2007 20:21:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/18] 2.6.18-stable review
In-Reply-To: <20070221014927.GA3684@kroah.com>
Message-ID: <Pine.LNX.4.64.0702232000550.5954@blonde.wat.veritas.com>
References: <20070221014927.GA3684@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 23 Feb 2007 20:21:38.0348 (UTC) FILETIME=[38CD0EC0:01C75788]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.18.8 release.
> 
> This will be the last release of the 2.6.18-stable series, so if there
> are patches that you feel should be applied to that tree, please let me
> know.
> 
> Responses should be made by Friday February 23 00:00 UTC.  Anything
> received after that time might be too late.

Sorry I'm late to the party, just climbed through 2000 mails.

I do hope you'll manage an -rc2,
I seem not the only one to notice wanted patches missing.

There's two from 2.6.19-stable that I thought Chris had agreed
for 2.6.18-stable (Linus' mincore and my read_zero_pagealigned);
two that I sent Chris cc stable for 2.6.18-stable on 4th January
(msync and powerpc current); one I know about from 2.6.19-stable
equally desirable in 2.6.18-stable (Badari's shmem_truncate); and
a new one I was waiting to appear in 2.6.21-rc1 before sending
(Tigran's extN noacl umask).

I'm reassembling the six patches against 2.6.18.8-rc1 for these
now (plus a 2.6.19-stable and a 2.6.20-stable for the latter),
will send them to Greg cc stable shortly.

I wonder whether Chris has a tree somewhere, or a mailbox,
containing further goodies which have been missed.

Hugh
