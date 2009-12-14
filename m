Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZLNL6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZLNL6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZLNL6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:58:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57829 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbZLNL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:58:33 -0500
Date: Mon, 14 Dec 2009 12:58:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091214115826.GA2280@elf.ucw.cz>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
 <20091207114825.GA26965@rakim.wolfsonmicro.main>
 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
 <20091213131921.GA1437@ucw.cz>
 <20091214115023.GA22388@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214115023.GA22388@rakim.wolfsonmicro.main>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-12-14 11:50:24, Mark Brown wrote:
> On Sun, Dec 13, 2009 at 02:19:22PM +0100, Pavel Machek wrote:
> 
> > ...but then there are all the systems that rely on /proc/apm
> > emulation, like openembedded popular on sharp zaurus...
> 
> OpenEmbedded is a meta-distribution so doesn't use any particular
> software here - I suspect you're referring to things like the GPE stack
> which isn't so actively developed these days.

Both Opie and GPE have the problem IIRC...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
