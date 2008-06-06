Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYFFEhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYFFEhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 00:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYFFEhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 00:37:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:59224 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbYFFEhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 00:37:22 -0400
Subject: Re: Linux 2.6.26-rc5 (G5 SATA broken)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Olaf Hering <olaf@aepfle.de>, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0806051255340.28792@blonde.site>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
	 <20080605112436.GA4533@aepfle.de>
	 <Pine.LNX.4.64.0806051255340.28792@blonde.site>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 14:36:46 +1000
Message-Id: <1212727006.12464.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I've been bisecting that on Quad G5 (sata_svw): irq 18: nobody cared ...,
> then later endless ata1.00: exception..., blah blah, ata1: EH complete.
> It comes down to:

Thanks for finding that !

/me likes when he wakes up in the morning to find a G5 bug ... and the
fix in the same thread :-)

Cheers,
Ben.


