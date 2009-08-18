Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbZHRNmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbZHRNmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZHRNmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:42:23 -0400
Received: from d1.icnet.pl ([212.160.220.21]:49992 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZHRNmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:42:22 -0400
Message-ID: <4A8AAFAD.9050705@tis.icnet.pl>
Date: Tue, 18 Aug 2009 15:42:05 +0200
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System
User-Agent: IceDove 1.5.0.14pre (X11/20080304)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jarkko Nikula <jhnikula@gmail.com>
CC: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v3] ASoC: OMAP: Enhance OMAP1510 DMA progress software
 counter
References: <200908101050.08074.jkrzyszt@tis.icnet.pl> <200908110107.11485.jkrzyszt@tis.icnet.pl> <200908112144.30731.jkrzyszt@tis.icnet.pl> <20090817122605.0b240ea7.jhnikula@gmail.com> <20090817100313.GA5756@rakim.wolfsonmicro.main>
In-Reply-To: <20090817100313.GA5756@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Mon, Aug 17, 2009 at 12:26:05PM +0300, Jarkko Nikula wrote:
> 
>> I'm fine with this 3rd version. Probably Mark would like to have git
>> format-patch formatted version for avoiding manual commit log editing.
> 
>> Acked-by: Jarkko Nikula <jhnikula@gmail.com>
> 
> Applied both 2-3, thanks.

Jarkko, Mark,

Thanks.

And now, how is the patch 1/3 supposed to get into the mainline? Whom 
should I ping from time to time to get it integrated? If not then, as 
you know for sure, applying patch 2/3 whithout 1/3 will result in ASoC 
support for OMAP1510 broken.

Thanks,
Janusz

