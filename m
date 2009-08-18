Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZHRNpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZHRNpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758900AbZHRNpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:45:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55961 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897AbZHRNpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:45:52 -0400
Date: Tue, 18 Aug 2009 14:45:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Jarkko Nikula <jhnikula@gmail.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v3] ASoC: OMAP: Enhance OMAP1510 DMA progress
	software counter
Message-ID: <20090818134540.GB24620@sirena.org.uk>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl> <200908110107.11485.jkrzyszt@tis.icnet.pl> <200908112144.30731.jkrzyszt@tis.icnet.pl> <20090817122605.0b240ea7.jhnikula@gmail.com> <20090817100313.GA5756@rakim.wolfsonmicro.main> <4A8AAFAD.9050705@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8AAFAD.9050705@tis.icnet.pl>
X-Cookie: The horror... the horror!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 03:42:05PM +0200, Janusz Krzysztofik wrote:

> And now, how is the patch 1/3 supposed to get into the mainline? Whom  
> should I ping from time to time to get it integrated? If not then, as  
> you know for sure, applying patch 2/3 whithout 1/3 will result in ASoC  
> support for OMAP1510 broken.

Normally the OMAP tree, though that's possibly a bit tricky due to the
ARM tree closing early.  If Tony's OK with merging via the ALSA tree we
could also apply the ARM patch there?
