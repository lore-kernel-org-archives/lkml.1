Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbZGaJwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbZGaJwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 05:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZGaJwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 05:52:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38660 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751661AbZGaJwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 05:52:37 -0400
Date: Fri, 31 Jul 2009 10:52:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jarkko Nikula <jhnikula@gmail.com>, Jonathan McDowell <noodles@earth.li>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>, alsa-devel@alsa-project.org,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>
Subject: Re: [RFC] [PATCH 3/3 v2] ASoC: add support for Amstrad E3 (Delta)
 machine
Message-ID: <20090731095234.GB10844@rakim.wolfsonmicro.main>
References: <200907291318.54897.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907291318.54897.jkrzyszt@tis.icnet.pl>
X-Cookie: I have a TINY BOWL in my HEAD
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 01:18:53PM +0200, Janusz Krzysztofik wrote:

> 2) patch 2/3 form this series: TTY: Add definition of a new line
>    discipline required by Amstrad E3 (Delta) ASoC driver[2].

The ASoC parts of this all look OK - what's the status of the TTY patch?
