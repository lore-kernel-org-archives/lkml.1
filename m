Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZGVHwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZGVHwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 03:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZGVHwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 03:52:05 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:63744 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbZGVHwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 03:52:04 -0400
Message-ID: <4A66C51C.7020900@roosoft.ltd.uk>
Date: Wed, 22 Jul 2009 08:51:56 +0100
From: Don Alexander <e3-dev@roosoft.ltd.uk>
Reply-To: e3-dev@roosoft.ltd.uk
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Discussion of the Amstrad E3 emailer hardware/software 
	<e3-hacking@earth.li>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tony Lindgren <tony@atomide.com>,
       alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       Jarkko Nikula <jhnikula@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [E3-hacking] [RFC] [PATCH 0/3] Add support for Amstrad E3 (Delta)
 audio to ASoC
References: <200907220522.15134.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200907220522.15134.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janusz Krzysztofik wrote:
> This series of patches adds support for audio device found on Amstrad E3 
> (Delta) videophone to ASoC.
>
> 1/3:	ASoC: Add support for Conexant CX20442-11 voice modem codec
> 2/3:	TTY: Add definition of a new line discipline required by Amstrad E3
> 	(Delta) ASoC driver
> 3/3:	ASoC: add support for Amstrad E3 (Delta) machine
> 4/3:	OMAP1: Readd basic support for DSP initialization
>
> Created and tested against linux-2.5.31-rc3.
> Applies and works with linux-omap-2.6 commit 
> 7c5cb7862d32cb344be7831d466535d5255e35ac as well
>
> Patch 4/3 is a temporary solution that should help interested parties in 
> testing the driver or even making use of it before an official DSP support 
> gets back to the omap or mainline tree.
>
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
>
> _______________________________________________
> e3-hacking mailing list
> e3-hacking@earth.li
> http://www.earth.li/cgi-bin/mailman/listinfo/e3-hacking
>
>   
Good job Jarkko ! :) Busy with a few other things atm but will dust off
the old E3 and take a poke at it when I can. It maybe boxed but it is
not forgotten :)

Cheers,



-- 
==

Don Alexander

E3 Development & tweaking ;)

RooSoft Ltd

