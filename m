Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbXEDGLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbXEDGLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXEDGLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:11:19 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:51630 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbXEDGLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:11:18 -0400
From: Stefan Roese <ml@stefan-roese.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: Correct location for ADC/DAC drivers
Date: Fri, 4 May 2007 08:11:42 +0200
User-Agent: KMail/1.9.5
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <200705011435.45046.ml@stefan-roese.de> <20070502133512.GK22585@pengutronix.de> <20070502191101.GB16696@flint.arm.linux.org.uk>
In-Reply-To: <20070502191101.GB16696@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705040811.43312.ml@stefan-roese.de>
X-RZG-AUTH: j/Xgg0n2J5AIUJCkqLmy+bJbs1jMc+ebRMH8X0gX2f46QMnUI4cTITA7kWi4b/tFeJ1A
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007 21:11, Russell King wrote:
> > > Is there a maintainer for this "drivers/mfd" directory?
> >
> > rmk
>
> I wouldn't go that far.  There's no real infrastructure there
> to maintain, so I'd actually say that the directory was
> maintainerless.  However, I'll own up to the UCB/MCP drivers
> in there.

So perhaps you could answer is you feel that these ADC & DAC chrdev device 
drivers would fit into this drivers/mfd directory, or are better suited for 
the drivers/char directory?

Thanks.

Best regards,
Stefan
