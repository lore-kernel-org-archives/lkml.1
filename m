Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbXETTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbXETTMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXETTMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:12:14 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2184 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbXETTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:12:13 -0400
Date: Sun, 20 May 2007 20:11:51 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <andrew@sanpeople.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>,
       Sascha Hauer <s.hauer@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
       David Brownell <david-b@pacbell.net>,
       Juha =?iso-8859-1?B?WXJq9mzk?= <juha.yrjola@solidboot.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       "Briglia >> Anderson F. Briglia" <anderson.briglia@indt.org.br>,
       Kyungmin Park <kmpark@infradead.org>, "Khasim, Syed" <x0khasim@ti.com>
Subject: Re: [RFC] Orphaning MMC host drivers
Message-ID: <20070520191151.GA5376@flint.arm.linux.org.uk>
Mail-Followup-To: Pierre Ossman <drzeus-mmc@drzeus.cx>,
	LKML <linux-kernel@vger.kernel.org>,
	Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
	Andrew Victor <andrew@sanpeople.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Manuel Lauss <mano@roarinelk.homelinux.net>,
	Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	David Brownell <david-b@pacbell.net>,
	Juha =?iso-8859-1?B?WXJq9mzk?= <juha.yrjola@solidboot.com>,
	Carlos Aguiar <carlos.aguiar@indt.org.br>,
	"Briglia >> Anderson F. Briglia" <anderson.briglia@indt.org.br>,
	Kyungmin Park <kmpark@infradead.org>,
	"Khasim, Syed" <x0khasim@ti.com>
References: <4648BAC9.5020405@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4648BAC9.5020405@drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 09:38:49PM +0200, Pierre Ossman wrote:
> I've reached the point where I've grown tired of trying to figure out
> who has hardware for what. I intend to commit the following in a few
> days so if you care about the quality of the drivers it's time to step
> up to the plate.

You can add me for mmci.c

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
