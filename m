Return-Path: <linux-kernel-owner+w=401wt.eu-S933269AbXAaRwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbXAaRwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXAaRwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:52:51 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59177 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933269AbXAaRwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:52:49 -0500
Message-ID: <45C0D765.4010709@garzik.org>
Date: Wed, 31 Jan 2007 12:52:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
References: <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org> <20070130075325.GA591@elte.hu> <45BEFBB2.8090402@garzik.org> <20070130080830.GC2840@elte.hu> <45C0B570.4000000@garzik.org> <20070131173832.GA13653@elte.hu>
In-Reply-To: <20070131173832.GA13653@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>  19:    2413090          0   IO-APIC-fasteoi   uhci_hcd:usb2, libata

Yep, that's a good candidate for such experiments :)

	Jeff



