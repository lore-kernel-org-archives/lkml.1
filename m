Return-Path: <linux-kernel-owner+w=401wt.eu-S2993130AbXEBTLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993130AbXEBTLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993136AbXEBTLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:11:15 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3868 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993130AbXEBTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:11:13 -0400
Date: Wed, 2 May 2007 20:11:01 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Stefan Roese <ml@stefan-roese.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Correct location for ADC/DAC drivers
Message-ID: <20070502191101.GB16696@flint.arm.linux.org.uk>
Mail-Followup-To: Robert Schwebel <r.schwebel@pengutronix.de>,
	Stefan Roese <ml@stefan-roese.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <200705011435.45046.ml@stefan-roese.de> <Pine.LNX.4.60.0705012301500.4972@poirot.grange> <200705021225.54417.ml@stefan-roese.de> <20070502133512.GK22585@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502133512.GK22585@pengutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 03:35:12PM +0200, Robert Schwebel wrote:
> On Wed, May 02, 2007 at 12:25:53PM +0200, Stefan Roese wrote:
> > Is there a maintainer for this "drivers/mfd" directory?
> 
> rmk

I wouldn't go that far.  There's no real infrastructure there
to maintain, so I'd actually say that the directory was
maintainerless.  However, I'll own up to the UCB/MCP drivers
in there.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
