Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0BHJj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:39:26 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:51290 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0BHJjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:39:25 -0500
Date: Mon, 8 Feb 2010 11:37:24 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
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
Message-ID: <20100208093724.GA13019@jasper.tkos.co.il>
References: <20100203155558.GH11354@pengutronix.de>
 <1265620180-14150-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265620180-14150-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Mon, Feb 08, 2010 at 10:09:38AM +0100, Uwe Kleine-König wrote:
> gpiolib doesn't need to modify the names and I assume most initializers
> use sting constants that shouldn't be modified anyhow.

s/sting/string/

> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Kevin Wells <kevin.wells@nxp.com>
> ---

[snip]

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
