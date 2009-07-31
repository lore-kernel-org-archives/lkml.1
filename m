Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZGaAxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZGaAxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZGaAxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:53:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52326 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZGaAxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:53:06 -0400
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Matt Fleming'" <matt@console-pimps.org>,
       "'Adrian Hunter'" <adrian.hunter@nokia.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Jarkko Lavinen'" <jarkko.lavinen@nokia.com>,
       "'linux-omap Mailing List'" <linux-omap@vger.kernel.org>,
       "'Pierre Ossman'" <pierre@ossman.eu>,
       "'Denis Karpov'" <ext-denis.2.karpov@nokia.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop> <20090729111327.GB6057@console-pimps.org>
Subject: RE: [PATCH V2 0/32] mmc and omap_hsmmc patches
Date: Thu, 30 Jul 2009 19:52:46 -0500
Message-ID: <000c01ca1179$387d6f20$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcoQPdcF+XiSuPlPQFmCCOmzo8eBXABOrEGA
In-Reply-To: <20090729111327.GB6057@console-pimps.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Matt Fleming
> Sent: Wednesday, July 29, 2009 6:13 AM
> To: Adrian Hunter
> Cc: Andrew Morton; Jarkko Lavinen; linux-omap Mailing List; Pierre Ossman;
> Denis Karpov; lkml
> Subject: Re: [PATCH V2 0/32] mmc and omap_hsmmc patches
> 
> On Tue, Jul 28, 2009 at 01:38:34PM +0300, Adrian Hunter wrote:
> > Hi
> >
> > Here is version 2 of our 32 patches for mmc and omap_hsmmc.
> >
> > They include Matt Fleming's change for card caps, and 2 other fixes:
> > 	- use a spin lock rather than enable / diable irq
> > 	- make disable delay specified in milliseconds not jiffies because
> the
> > 	value is an int, and jiffies are unsigned long (also millisecs are
> > 	better anyway)
> >
> 
> Thanks for doing this Adrian. I appreciate it. My Reviewed-by tag still
> applies.

I reviewed the omap_hsmmc series. They look good.

Regards,
Madhu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


