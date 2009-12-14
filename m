Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZLNLu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZLNLu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbZLNLu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:50:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60607 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757005AbZLNLuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:50:25 -0500
Date: Mon, 14 Dec 2009 11:50:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091214115023.GA22388@rakim.wolfsonmicro.main>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
 <20091207114825.GA26965@rakim.wolfsonmicro.main>
 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
 <20091213131921.GA1437@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091213131921.GA1437@ucw.cz>
X-Cookie: The worst is enemy of the bad.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 02:19:22PM +0100, Pavel Machek wrote:

> ...but then there are all the systems that rely on /proc/apm
> emulation, like openembedded popular on sharp zaurus...

OpenEmbedded is a meta-distribution so doesn't use any particular
software here - I suspect you're referring to things like the GPE stack
which isn't so actively developed these days.
