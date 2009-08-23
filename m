Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbZHWREk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbZHWREk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 13:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934033AbZHWREj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 13:04:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49878 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934021AbZHWREj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 13:04:39 -0400
Date: Sun, 23 Aug 2009 18:03:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [RFC][PATCH 1/3 v2] ARM: OMAP: DMA: Add support
	for DMA channel self linking on OMAP1510
Message-ID: <20090823170359.GA3488@sirena.org.uk>
References: <200908101050.02530.jkrzyszt@tis.icnet.pl> <200908231756.13016.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908231756.13016.jkrzyszt@tis.icnet.pl>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 05:56:12PM +0200, Janusz Krzysztofik wrote:

> I know it's not very fair to change the patch after others that depend on it
> have already been applied, but I hope there will be no problems with accepting
> the way I have reimplemented it. In any case, I'll appreciate any comments or
> suggestions.

It's not that it's not fair, at this point it's not possible - please
make any changes you feel are required against current ASoC.  The patch
has been applied for a little while now and is buried quite deep in the
already published history.
