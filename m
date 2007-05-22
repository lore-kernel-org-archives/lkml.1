Return-Path: <linux-kernel-owner+w=401wt.eu-S1763262AbXEVBuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763262AbXEVBuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXEVBuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:50:44 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57666 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785AbXEVBun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:50:43 -0400
Date: Mon, 21 May 2007 18:46:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, jeff@garzik.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Alan Cox <alan@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org
Subject: Re: [stable] [patch 07/69] libata-sff: Undo bug introduced with
	pci_iomap changes
Message-ID: <20070522014635.GU3429@sequoia.sous-sol.org>
References: <20070521191612.800400000@sous-sol.org> <20070521191701.791285000@sous-sol.org> <alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org> <20070521233840.GS3429@sequoia.sous-sol.org> <20070522013640.5232029b@the-village.bc.nu> <20070522010941.GT3429@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522010941.GT3429@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Yeah - fix your mailer, you got a reply 5 days ago.
> 
> Sure wouldn't be the first time something broke.  I'll take a look.

Thanks for the prod.  I found 2 quite stale RBL entries, causing
long connection delay (enough from some MTAs to walk away perhaps).

thanks,
-chris
