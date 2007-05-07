Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbXEGVVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbXEGVVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbXEGVVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:21:10 -0400
Received: from khc.piap.pl ([195.187.100.11]:42097 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbXEGVVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:21:09 -0400
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Jeff Garzik" <jeff@garzik.org>,
       "Russell King" <rmk@arm.linux.org.uk>, lnetdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 0/3] Intel IXP4xx network drivers
References: <m3abwhcy74.fsf@maximus.localdomain>
	<c384c5ea0705071339u312f421bm539ae539530e28f4@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 07 May 2007 23:21:07 +0200
In-Reply-To: <c384c5ea0705071339u312f421bm539ae539530e28f4@mail.gmail.com> (Leon Woestenberg's message of "Mon, 7 May 2007 22:39:52 +0200")
Message-ID: <m3abwgfhz0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

"Leon Woestenberg" <leon.woestenberg@gmail.com> writes:

> drivers/net/ixp4xx/ixp4xx_eth.c
> drivers/net/ixp4xx/ixp4xx_npe.c
> drivers/net/ixp4xx/ixp4xx_qmgr.c
> ...
>
> suggestion: credit Christian for his work by putting his copyright in
> the header as well?

Obviously, as I wrote, his work was a great help for me.
However, a copyright is a different thing, this is a complete
rewrite with maybe two small fragments adapted from his code
(including the "fuses" thing). I can put info in the sources,
though.
-- 
Krzysztof Halasa
