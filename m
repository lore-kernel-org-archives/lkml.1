Return-Path: <linux-kernel-owner+w=401wt.eu-S1762852AbXLRDJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762852AbXLRDJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbXLRDJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:09:35 -0500
Received: from no-dns-yet.demon.co.uk ([83.105.13.114]:34552 "EHLO
	mailgate.netunix.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXLRDJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:09:34 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 22:09:34 EST
Date: Tue, 18 Dec 2007 02:58:29 +0000 (GMT)
From: Chris Newport <crn@netunix.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22 regression)
In-Reply-To: <47670BDF.80409@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.60.0712180255450.10484@mailgate.netunix.com>
References: <bug-9160-4803@http.bugzilla.kernel.org/> <47112797.7060003@s5r6.in-berlin.de>
 <47670BDF.80409@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007, Stefan Richter wrote:

> It's a 100% reproducible oops on Sparc (with FireWire controller) for
> 2.6.23 and 2.6.24 kernels, but not 2.6.22.  The reporter confirmed that
> the bug also happens

How do you achieve a sparc system with firewire ?
AFAIK there is no SBUS firewire card.

Only sparc64 and some rare javastations have PCI slots.

