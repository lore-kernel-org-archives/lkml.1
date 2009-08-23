Return-Path: <linux-kernel-owner+w=401wt.eu-S933982AbZHWRtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbZHWRtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 13:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933248AbZHWRtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 13:49:15 -0400
Received: from d1.icnet.pl ([212.160.220.21]:56952 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZHWRtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 13:49:14 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [RFC][PATCH 1/3 v2] ARM: OMAP: DMA: Add support for DMA channel self linking on OMAP1510
Date: Sun, 23 Aug 2009 19:45:39 +0200
User-Agent: KMail/1.9.10
Cc: Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Jarkko Nikula <jhnikula@gmail.com>
References: <200908101050.02530.jkrzyszt@tis.icnet.pl> <200908231756.13016.jkrzyszt@tis.icnet.pl> <20090823170359.GA3488@sirena.org.uk>
In-Reply-To: <20090823170359.GA3488@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908231945.40187.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday 23 August 2009 19:03:59 Mark Brown wrote:
> It's not that it's not fair, at this point it's not possible - please
> make any changes you feel are required against current ASoC.  The patch
> has been applied for a little while now and is buried quite deep in the
> already published history.

Mark,

I see your point. It also seemed to me that you had already applied my 
original patch, however while preparing that v2 I found no single evidence of 
it being applied, so took into consideration it was not my patch I had on my 
mind but Eduardo's patches on OMAP McBSP that you had agreeed with Tony to 
push via ASoC tree. The last message regarding this original patch I am able 
to locate was from Jarkko[1], where he said it would be better to leave this 
one in Tony's hands.

If I missed something and my original patch has really been applied, I'll be 
happy to prepare a new version that reverts previos changes and makes those 
proposed in patch v2, if those are acceptable.

Thanks,
Janusz

[1] http://www.spinics.net/lists/linux-omap/msg17172.html
