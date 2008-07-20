Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYGTX2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYGTX2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYGTX21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:28:27 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:6200
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbYGTX20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:28:26 -0400
X-Trace: 4537626/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAAAK9mg0jDiV6i/2dsb2JhbAAIrRU
X-IronPort-AV: E=Sophos;i="4.31,219,1215385200"; 
   d="scan'208";a="4537626"
X-IP-Direction: IN
Subject: Re: [PATCH 1/3] at91_mci: Enable MMC_CAP_SDIO_IRQ only when it
	actually works
From: ian <spyro@f2s.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <20080720131310.74d83d54@mjolnir.drzeus.cx>
References: <487F120F.2050305@atmel.com>
	 <20080717125544.36f41947@mjolnir.drzeus.cx> <48809B00.1070405@atmel.com>
	 <20080719010143.142d59a0@mjolnir.drzeus.cx>
	 <1216547739.3200.5.camel@wirenth>
	 <20080720131310.74d83d54@mjolnir.drzeus.cx>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 00:28:23 +0100
Message-Id: <1216596503.3200.24.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-20 at 13:13 +0200, Pierre Ossman wrote:
> It does tend to make a mess of things when you start adding up all the
> gotchas of each and every broken controller out there (it seems like
> every controller decides to violate the spec in their own creative
> way).

True.

> What about David's idea? Reconfiguring the PIN to be a GPIO pin with
> an interrupt shouldn't be that difficult?

If it works its a better solution...

