Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXKESZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXKESZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXKESZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:25:33 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51663 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXKESZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:25:32 -0500
Date: Mon, 5 Nov 2007 19:25:30 +0100
From: Andreas Mohr <andim2@users.sourceforge.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: andi@lisas.de, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-user@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
Message-ID: <20071105182530.GA6113@rhlx01.hs-esslingen.de>
Reply-To: andi@lisas.de
References: <47166C83.2050207@s5r6.in-berlin.de> <m3fy09ffp9.fsf@maximus.localdomain> <4719A0C4.3050301@s5r6.in-berlin.de> <m3bqausztv.fsf@maximus.localdomain> <4719FF0F.3080504@s5r6.in-berlin.de> <m3ejfp4bg9.fsf@maximus.localdomain> <4724C9DA.7030900@s5r6.in-berlin.de> <m33avvdlbq.fsf@maximus.localdomain> <20071104193109.GA4033@rhlx01.hs-esslingen.de> <m38x5dhb0f.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m38x5dhb0f.fsf@maximus.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 05, 2007 at 12:00:16AM +0100, Krzysztof Halasa wrote:
> Andreas Mohr <andim2@users.sourceforge.net> writes:
> > And viewing from a quite problematic angle (card is in running PC,
> > difficult to view) strongly seems to indicate a VT630_6_ (the "6" is
> > quite clearly visible).
> > This means that I currently cannot offer any mfct. date data however,
> > unfortunately.
> 
> Yeah. I think (feel or something) VIA does the usual thing with
> revision numbers so rev 0x46 means always the same silicon (VT6306)
> and rev 0x80 is always the same VT6307. There might be other
> revisions but I think we won't find non-VT6306 rev 0x46 or
> non-VT6307 rev 0x80.

OK, PC was off now (good to be using S2D instead of S2R ;),
the card data is:

"SN1394", "STARNET V1.0"
mfct.: 0450



VIA VT6306
0449CD TAIWAN
2HG1002703

(IOW, a moderately new VT6306 card)


SEEPROM:

ATMEL 418
93C46
PI27   A


I'm only an occasional Firewire user (external backup HDD, miniDV
grabbing), but I'm very thankful for your nice investigations!

Andreas Mohr
