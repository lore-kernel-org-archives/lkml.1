Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0BHJnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:43:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48899 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab0BHJnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:43:20 -0500
Date: Mon, 8 Feb 2010 10:43:18 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier@gentoo.org>, Nate Case <ncase@xes-inc.com>,
       Daniel Silverstone <dsilvers@simtec.co.uk>,
       Kevin Wells <kevin.wells@nxp.com>,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] gpiolib: make names array and its values const
Message-ID: <20100208094318.GE15255@pengutronix.de>
References: <20100203155558.GH11354@pengutronix.de> <1265620180-14150-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100208093724.GA13019@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100208093724.GA13019@jasper.tkos.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Baruch,

On Mon, Feb 08, 2010 at 11:37:24AM +0200, Baruch Siach wrote:
> Hi Uwe,
> 
> On Mon, Feb 08, 2010 at 10:09:38AM +0100, Uwe Kleine-König wrote:
> > gpiolib doesn't need to modify the names and I assume most initializers
> > use sting constants that shouldn't be modified anyhow.
> 
> s/sting/string/
Thanks, fixed in my tree.

BTW, you can get the updated series at

	git://git.pengutronix.de/git/ukl/linux-2.6.git gpiolib/names

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
