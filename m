Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZGaN1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZGaN1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZGaN1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:27:43 -0400
Received: from d1.icnet.pl ([212.160.220.21]:54547 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZGaN1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:27:42 -0400
Message-ID: <4A72F131.7010806@tis.icnet.pl>
Date: Fri, 31 Jul 2009 15:27:13 +0200
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System
User-Agent: IceDove 1.5.0.14pre (X11/20080304)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
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
References: <200907291318.54897.jkrzyszt@tis.icnet.pl>	<20090731095234.GB10844@rakim.wolfsonmicro.main>	<4A72DC71.6020904@tis.icnet.pl> <20090731131647.012afb23@lxorguk.ukuu.org.uk>
In-Reply-To: <20090731131647.012afb23@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> Furthermore, I am still thinking about renaming the ldisc with a more 
>>> generic name. That way, it could be probably reused by other similiar 
>>> implementations. As long as the ldisc is registered from a board 
>>> specific code, it should not interfere with other implemnetations 
>>> reusing the same ldisc number, even if compiled in side by side.
>> Any objections on renaming ldisc from N_AMSDLETA to N_V253?
> 
> None
> 

Thanks, will resubmit as patch 2/3 v2 and 3/3 v3 then.

Janusz
