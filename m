Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZGaVi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZGaVi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZGaViZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:38:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51378 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbZGaViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:38:24 -0400
Date: Fri, 31 Jul 2009 22:38:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20090731213812.GB6335@sirena.org.uk>
References: <200907291318.54897.jkrzyszt@tis.icnet.pl>
 <200907301112.53525.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907301112.53525.jkrzyszt@tis.icnet.pl>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [RFC] [PATCH 3/3 v2] ASoC: add support for
 Amstrad E3 (Delta) machine
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 11:12:52AM +0200, Janusz Krzysztofik wrote:

> I am aware that I have forgot to correct one checkpatch indicated issue. Sorry
> for this.  If there are no other changes to the locking bits suggested, the
> issue will be corrected this way:

I've applied this (squashed into the original patch), together with your
other two ASoC patches and the TTY patch.  If you want to change the
name of the line discipline please send a followup patch before the next
merge window.

Thanks for your work on this, and on getting the OMAP1 support working.
