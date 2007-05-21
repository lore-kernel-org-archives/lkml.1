Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbXEUXmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbXEUXmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbXEUXmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:42:25 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:42033 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490AbXEUXmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:42:24 -0400
Date: Mon, 21 May 2007 16:38:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Tejun Heo <htejun@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, jeff@garzik.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Alan Cox <alan@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 07/69] libata-sff: Undo bug introduced with
	pci_iomap changes
Message-ID: <20070521233840.GS3429@sequoia.sous-sol.org>
References: <20070521191612.800400000@sous-sol.org> <20070521191701.791285000@sous-sol.org> <alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Mon, 21 May 2007, Chris Wright wrote:
> > ---
> > [chrisw: Why is this not upstream yet?]
> 
> And equally importantly, why is it even in the stable queue if it's not 
> upstream.
> 
> It's against stable rules, and it means that we may have stuff that gets 
> fixed in -stable and not in -upstream, if people don't notice. THAT IS 
> BAD!

It's there specifically to fish out why it was sent to -stable w/out
ever making it upstream.  Having sent the same question w/ no response
5 days ago
