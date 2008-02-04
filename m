Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYBDPch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYBDPch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYBDPc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:32:27 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46379 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbYBDPc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:32:26 -0500
Message-ID: <47A73003.8050100@garzik.org>
Date: Mon, 04 Feb 2008 10:32:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
References: <20080201231147.GA18174@suse.de>	<20080202111322.GA30767@elte.hu>	<47A49171.2000003@garzik.org>	<20080202170828.GA12748@elte.hu>	<47A4A96D.2040709@garzik.org>	<20080202175738.GA26560@elte.hu>	<47A4BB3C.6050709@garzik.org>	<20080202193524.GC27927@elte.hu>	<47A4D71F.3060009@garzik.org>	<20080204125736.GA32056@elte.hu> <20080204051230.70d5b735.akpm@linux-foundation.org>
In-Reply-To: <20080204051230.70d5b735.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Actually I (and probably others) generally avoid cc'ing mailing lists on
> patch traffic.  I spew out enough script-generated traffic as it is.

You pretty much always ensure the driver author gets CC'd, which is 
exemplary :)

	Jeff



