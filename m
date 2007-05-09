Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbXEIS46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbXEIS46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbXEIS4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:56:51 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2109 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbXEIS4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:56:46 -0400
Date: Wed, 9 May 2007 19:56:36 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
Message-ID: <20070509185636.GB26981@flint.arm.linux.org.uk>
Mail-Followup-To: Pierre Ossman <drzeus-list@drzeus.cx>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <46375B18.4080802@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46375B18.4080802@drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 05:22:00PM +0200, Pierre Ossman wrote:
> Linus, please pull from
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus
> 
> to receive the following updates:

Dug out from the ARM kautobuild...

drivers/mmc/host/pxamci.c: In function 'pxamci_cmd_done':
drivers/mmc/host/pxamci.c:236: error: 'MMC_ALL_SEND_CID' undeclared (first use in this function)
drivers/mmc/host/pxamci.c:236: error: (Each undeclared identifier is reported only once
drivers/mmc/host/pxamci.c:236: error: for each function it appears in.)
drivers/mmc/host/pxamci.c:237: error: 'MMC_SEND_CSD' undeclared (first use in this function)
drivers/mmc/host/pxamci.c:238: error: 'MMC_SEND_CID' undeclared (first use in this function)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
