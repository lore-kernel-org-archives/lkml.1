Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbXFVO7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbXFVO7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbXFVO7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:59:06 -0400
Received: from mail02.vsnet.ch ([153.109.10.41]:48445 "EHLO mail02.vsnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938AbXFVO7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:59:05 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [PATCH] mmc-atmel : fix kunmap wrong usage
Date: Fri, 22 Jun 2007 16:58:09 +0200
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Pierre Ossman <drzeus@drzeus.cx>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706221237330.26363@blonde.wat.veritas.com> <467BCFCF.6020509@rfo.atmel.com>
In-Reply-To: <467BCFCF.6020509@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221658.10431.marc.pignat@hevs.ch>
X-VSnet-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007 15:34, Nicolas Ferre wrote:
> Hugh Dickins :
> Here:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b9bae3402572dc50a1e084c5b1ae5117918ef0f0
> 
> > But it would be good to hear from Nicolas whether that indeed fixes
> > his oops: I couldn't actually try my patch on ARM either.
> 
> Ok tested on Atmel ARM AT91 (at91sam9263), this fixes this oops.
> 
Just tested and working on my atmel at91rm9200.
(at91sam9263 core is ARM926EJ-S and at91rm9200 core is ARM920T).

Thanks!

Regards

Marc

