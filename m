Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbZE1Oy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbZE1Oy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZE1Oyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:54:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:59622 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbZE1Oyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:54:51 -0400
MIME-Version: 1.0
In-Reply-To: <20090528091513.GA14789@n2100.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> 
	<4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> 
	<1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 May 2009 08:54:33 -0600
Message-ID: <fa686aa40905280754s536df8adsca0ead180563cc65@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 3:15 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> In order for me to be convinced that OF is not going to cause us grief,
> I'd like to see a range of platforms converted to OF to check that we're
> not going to find any unexpected problems - eg, a load of PXA platforms,
> particularly those with the above kinds of problems.

/me goes back to working on this.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
