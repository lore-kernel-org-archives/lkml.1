Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZE0UoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZE0UoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbZE0Une
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:43:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:55159 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbZE0Unb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <20090527175609.GB31861@flint.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> 
	<4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 14:43:12 -0600
Message-ID: <fa686aa40905271343l66841a03k8985ab29008ca72a@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Scott Wood <scottwood@freescale.com>, Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 11:56 AM, Russell King
<rmk+lkml@arm.linux.org.uk> wrote:
> So, repeat this mantra: device drivers should contain no platform specifics.
> Platform specifics should be separated from the driver and implemented by
> platform support code.

/me suspects we are having a violent agreement on this point.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
