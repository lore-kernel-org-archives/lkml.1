Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbXETTRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbXETTRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbXETTRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:17:07 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:45800 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbXETTRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:17:06 -0400
Message-ID: <46509E9C.6010003@drzeus.cx>
Date: Sun, 20 May 2007 21:16:44 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <andrew@sanpeople.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>,
       Sascha Hauer <s.hauer@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
       David Brownell <david-b@pacbell.net>,
       "=?ISO-8859-1?Q?Juha_Yrj=F6l=E4?=" <juha.yrjola@solidboot.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       "Briglia >> Anderson F. Briglia" <anderson.briglia@indt.org.br>,
       Kyungmin Park <kmpark@infradead.org>, "Khasim, Syed" <x0khasim@ti.com>
Subject: Re: [RFC] Orphaning MMC host drivers
References: <4648BAC9.5020405@drzeus.cx> <20070520191151.GA5376@flint.arm.linux.org.uk>
In-Reply-To: <20070520191151.GA5376@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Mon, May 14, 2007 at 09:38:49PM +0200, Pierre Ossman wrote:
>> I've reached the point where I've grown tired of trying to figure out
>> who has hardware for what. I intend to commit the following in a few
>> days so if you care about the quality of the drivers it's time to step
>> up to the plate.
> 
> You can add me for mmci.c
> 

Great. Do you want the LAKML there aswell?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
