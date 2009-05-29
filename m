Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZE2Azh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZE2Azh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 20:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZE2Aza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 20:55:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:58440 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZE2Az3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 20:55:29 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090528150409.GO22742@pengutronix.de>
References: <20090527150527.GK6805@pengutronix.de>
	 <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <4A1D8FBA.6040802@freescale.com>
	 <20090527192909.GA32398@flint.arm.linux.org.uk>
	 <20090527205218.GA5591@sirena.org.uk>
	 <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com>
	 <20090528124307.GN22742@pengutronix.de>
	 <alpine.LFD.2.00.0905281457170.3397@localhost.localdomain>
	 <20090528150409.GO22742@pengutronix.de>
Content-Type: text/plain
Date: Fri, 29 May 2009 10:51:14 +1000
Message-Id: <1243558274.17903.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 17:04 +0200, Sascha Hauer wrote:
> 
> We normally hide these subtle details behind a baseboard= kernel
> parameter. I agree with you that it's far better to have a
> standardized
> way to specify this. For my taste the oftree is too bloated for this
> purpose.

Define "bloated" ?

We got a lot of push back on powerpc initially with this exact same
argument "too bloated" but that was never backed up with facts and
numbers, and I would mostly say that nobody makes it anymore now
that it's there and people use it.

Cheers,
Ben.


