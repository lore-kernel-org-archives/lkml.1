Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZGaMRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZGaMRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZGaMRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:17:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49591 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752228AbZGaMRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:17:06 -0400
Date: Fri, 31 Jul 2009 13:16:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jarkko Nikula <jhnikula@gmail.com>,
       Jonathan McDowell <noodles@earth.li>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>, alsa-devel@alsa-project.org,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>
Subject: Re: [RFC] [PATCH 3/3 v2] ASoC: add support for Amstrad E3 (Delta)
 machine
Message-ID: <20090731131647.012afb23@lxorguk.ukuu.org.uk>
In-Reply-To: <4A72DC71.6020904@tis.icnet.pl>
References: <200907291318.54897.jkrzyszt@tis.icnet.pl>
	<20090731095234.GB10844@rakim.wolfsonmicro.main>
	<4A72DC71.6020904@tis.icnet.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Furthermore, I am still thinking about renaming the ldisc with a more 
> > generic name. That way, it could be probably reused by other similiar 
> > implementations. As long as the ldisc is registered from a board 
> > specific code, it should not interfere with other implemnetations 
> > reusing the same ldisc number, even if compiled in side by side.
> 
> Any objections on renaming ldisc from N_AMSDLETA to N_V253?

None
