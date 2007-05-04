Return-Path: <linux-kernel-owner+w=401wt.eu-S1767711AbXEDHpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767711AbXEDHpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767700AbXEDHpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:45:12 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3857 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767711AbXEDHpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:45:10 -0400
Date: Fri, 4 May 2007 08:44:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stefan Roese <ml@stefan-roese.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Correct location for ADC/DAC drivers
Message-ID: <20070504074453.GA18212@flint.arm.linux.org.uk>
Mail-Followup-To: Stefan Roese <ml@stefan-roese.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <200705011435.45046.ml@stefan-roese.de> <20070502133512.GK22585@pengutronix.de> <20070502191101.GB16696@flint.arm.linux.org.uk> <200705040811.43312.ml@stefan-roese.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705040811.43312.ml@stefan-roese.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 08:11:42AM +0200, Stefan Roese wrote:
> On Wednesday 02 May 2007 21:11, Russell King wrote:
> > > > Is there a maintainer for this "drivers/mfd" directory?
> > >
> > > rmk
> >
> > I wouldn't go that far.  There's no real infrastructure there
> > to maintain, so I'd actually say that the directory was
> > maintainerless.  However, I'll own up to the UCB/MCP drivers
> > in there.
> 
> So perhaps you could answer is you feel that these ADC & DAC chrdev device 
> drivers would fit into this drivers/mfd directory, or are better suited for 
> the drivers/char directory?

No idea; firstly I've long since deleted the email, secondly I've not much
interest in the directory itself, and thirdly I've enough patches to review
already.  Finally, I'm out all day today, including the evening.  I doubt
I'll read any further email until the weekend.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
