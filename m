Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZLNMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZLNMOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbZLNMON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:14:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37121 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757116AbZLNMOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:14:11 -0500
Date: Mon, 14 Dec 2009 12:14:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Subject: Re: [POWER] battery calibration parameters from sysfs
Message-ID: <20091214121409.GC22388@rakim.wolfsonmicro.main>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
 <20091204104930.GA28625@sirena.org.uk>
 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
 <20091207114825.GA26965@rakim.wolfsonmicro.main>
 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
 <20091213131921.GA1437@ucw.cz>
 <20091214115023.GA22388@rakim.wolfsonmicro.main>
 <20091214115826.GA2280@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214115826.GA2280@elf.ucw.cz>
X-Cookie: The worst is enemy of the bad.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 12:58:26PM +0100, Pavel Machek wrote:
> On Mon 2009-12-14 11:50:24, Mark Brown wrote:

> > OpenEmbedded is a meta-distribution so doesn't use any particular
> > software here - I suspect you're referring to things like the GPE stack
> > which isn't so actively developed these days.

> Both Opie and GPE have the problem IIRC...

Yeah, if you're working on older systems like that you'll probably have
to do some userspace work as well as kernel work.
